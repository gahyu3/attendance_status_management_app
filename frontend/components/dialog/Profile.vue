<template>
  <v-dialog v-model="dialog" @after-leave="onDialogToggle"
            width="auto">
    <v-card width="500"
            style="max-width: 90vw;"
            title="ユーザー編集"
            class="pa-10">
      <v-form v-if="editUser.user_name" @submit.prevent="updateUser(editUser.user_name)">
        <div class="d-flex justify-center">
          <v-avatar v-if="image" :image="image" size="120"/>
        </div>
        <div class="d-flex justify-center pt-5 pb-5">
          <v-btn :disabled="user?.id !== currentUser?.id" text="アバター編集" @click="onInput"></v-btn>
        </div>
        <input type="file" ref="file" @change="prevImage" class="d-none"></input>
        <v-text-field v-model="editUser.user_name"
                      label="ユーザーネーム"
                      placeholder="太郎"
                      type="text"
                      :readonly="user?.id !== currentUser?.id"
                      ></v-text-field>
        <v-btn :disabled="user?.id !== currentUser?.id" text="編集" type="submit"></v-btn>
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

const file = ref<HTMLInputElement | null>(null)
const image = ref<string | null>(null)
const uploadFile = ref<File | null>(null)
const originalImage = ref<string | null>(null)
const editUser = reactive({
  id: props.user?.id,
  user_name: props.user?.user_name
})

watch(
  () => props.user,
  (user) => {
    if (user) {
      copyObject(user)
      const imageUrl = `${config.public.apiLocal}${user.avatar_image?.url}`

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
      console.log(uploadFile.value)
  }
}

// ダイアログを閉じた時に元の画像を表示
function onDialogToggle() {
    image.value = originalImage.value
    Object.assign(editUser, props.user)
}

async function updateUser(userName: string): Promise<void> {

  const formData = new FormData()
  formData.append('user[user_name]', userName)

  if (uploadFile.value) {
    formData.append('user[avatar_image]', uploadFile.value)
  }

  try {
    const response: ProfileResponse = await $fetch(`${config.public.apiLocal}/api/v1/profile`,{
      method: "PUT",
      headers: getAuthHeaders(),
      body: formData
    })
    console.log('アップロード結果:', response)

    currentUser.value = response.current_user
    const attendance = attendances.value?.attendances.find(att => att.user.id === editUser.id)
    if (attendance) {
      attendance.user = response.current_user
    }
    dialog.value = false
  } catch (error) {
    console.log("APIエラー", error)
  }
}
</script>
