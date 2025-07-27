<template>
  <v-dialog v-model="dialog" @after-leave="onDialogToggle"
            width="auto">
    <v-card width="500"
            style="max-width: 90vw;"
            title="ユーザー編集"
            class="pa-10">
      <v-form @submit.prevent="() => updateUserSafe()">
        <div class="d-flex justify-center">
          <v-avatar v-if="user?.avatar_image?.url" :image="image" size="120"/>
          <v-icon v-else
            icon="mdi-account-circle"
            size="120"
            class="cursor-pointer"/>
        </div>
        <div class="d-flex justify-center pt-5 pb-5">
          <v-btn :disabled="user?.id !== currentUser?.id" text="アバター編集" @click="onInput"></v-btn>
        </div>
        <input type="file" ref="file" @change="prevImage" class="d-none"></input>
        <v-text-field v-model="editUser.user_name"
                      label="ユーザーネーム"
                      placeholder="太郎"
                      type="text"
                      variant="outlined"
                      :rules="[v => !!v || '名前は必須です']"
                      :readonly="user?.id !== currentUser?.id"
                      ></v-text-field>
        <v-btn :disabled="user?.id !== currentUser?.id"
          class="me-5"
          text="編集"
          type="submit">
        </v-btn>
        <v-btn class="ms-auto"
                text="閉じる"
                @click="dialog = false">
        </v-btn>
      </v-form>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import { ref, watch, reactive } from 'vue'
import type { ProfileResponse, User } from '~/types';

const config = useRuntimeConfig()
const dialog = defineModel<boolean>()
const props = defineProps<{
                user: User | null
              }>()

const { getAuthHeaders } = useApiClient()

const { currentUser } = useCurrentUser()
const { attendances } = useAttendances()

const localhost = ref('')
const file = ref<HTMLInputElement | null>(null)
const image = ref<string>("")
const uploadFile = ref<File | null>(null)
const originalImage = ref<string>("")
const editUser = reactive({
  id: props.user?.id,
  user_name: props.user?.user_name
})

watch(
  () => props.user,
  (user) => {
    if (user) {
      copyObject(user)
      if (config.public.apiBase === "http://localhost:3000") {
        localhost.value = `${config.public.apiBase}`
      }

      const imageUrl = `${localhost.value}${user.avatar_image?.url}`

      image.value = imageUrl
      originalImage.value = imageUrl
    }
  },
  { immediate: true }
)

function copyObject(user: User): void {
  editUser.id = user.id
  editUser.user_name = user.user_name
}

function onInput() {
  file.value?.click()
}

// 選択した画像をプレビュー表示
function prevImage(event: Event) {
  const target = event.target as HTMLInputElement
  if (target?.files && target.files[0]) {
      const selectedFile = target.files[0]
      image.value = URL.createObjectURL(selectedFile)
      uploadFile.value = selectedFile
  }
}

// ダイアログを閉じた時に元の画像を表示
function onDialogToggle() {
    image.value = originalImage.value
    Object.assign(editUser, props.user)
}

// updateUserの引数を保証して実行
function updateUserSafe() {
  const name = editUser.user_name
  if (typeof name !== 'string' || name.trim() === '') return
  updateUser(name)
}

async function updateUser(userName: string) {

  const formData = new FormData()
  formData.append('user[user_name]', userName)

  if (uploadFile.value) {
    formData.append('user[avatar_image]', uploadFile.value)
  }

  try {
    const response: User = await $fetch(`${config.public.apiBase}/api/v1/profile`,{
      method: "PUT",
      headers: getAuthHeaders(),
      body: formData
    })

    currentUser.value = response
    const attendance = attendances.value?.attendances.find(att => att.user.id === editUser.id)
    if (attendance) {
      attendance.user = response
    }
    dialog.value = false
  } catch (error) {
    console.error("APIエラー", error)
  }
}
</script>

<style>
.fc-h-event .fc-event-main {
  padding-left: 35px;
}
</style>
