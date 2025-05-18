<template>
  <v-dialog v-model="dialog" @after-leave="onDialogToggle"
            width="auto">
    <v-card width="500"
            style="max-width: 90vw;"
            title="ユーザー編集"
            class="pa-10">
      <v-form @submit.prevent="updateUser(editUser.user_name)">
        <div class="d-flex justify-center">
          <v-avatar :image="image" size="120"/>
        </div>
        <div class="d-flex justify-center pt-5 pb-5">
          <v-btn :disabled="user.id !== currentUser.id" text="アバター編集" @click="onInput"></v-btn>
        </div>
        <input type="file" ref="file" @change="prevImage" class="d-none"></input>
        <v-text-field v-model="editUser.user_name"
                      label="ユーザーネーム"
                      placeholder="太郎"
                      type="text"
                      :readonly="user.id !== currentUser.id"
                      ></v-text-field>
        <v-btn :disabled="user.id !== currentUser.id" text="編集" type="submit"></v-btn>
        <v-btn class="ms-auto"
          text="閉じる"
          @click="dialog = false">
        </v-btn>
      </v-form>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { ref, watch, reactive } from 'vue'

const dialog = defineModel()
const props = defineProps({
                user: {}
              })

const config = useRuntimeConfig()
const { getAuthHeaders } = useApiClient()

const currentUser = useState("currentUser");
const groupUserAttendancesData = useState("groupUserAttendancesData");

const file = ref(null)
const image = ref(null)
const uploadFile = ref(null)
const originalImage = ref(null)
const editUser = reactive({
  id: props.user?.id,
  user_name: props.user?.user_name
})

// watch(
//   () => props.user,
//   (user) => {
//     if (user) {
//       copyObject(user)
//       const imageUrl = `${config.public.apiBase}${user.avatar_image.url}`

//       image.value = imageUrl
//       originalImage.value = imageUrl
//     }
//   },
//   { immediate: true }
// )

function copyObject(user) {
  editUser.id = user.id
  editUser.user_name = user.user_name
}

function onInput() {
  file.value.click()
}

// 選択した画像をプレビュー表示
function prevImage(event) {
  const selectedFile = event.target.files[0]
  console.log(selectedFile)
  if (selectedFile) {
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

async function updateUser(userName) {

  const formData = new FormData()
  formData.append('user[user_name]', userName)

  if (uploadFile.value) {
    formData.append('user[avatar_image]', uploadFile.value)
  }

  try {
    const response = await $fetch(`${config.public.apiLocal}/api/v1/profile`,{
      method: "PUT",
      headers: getAuthHeaders(),
      body: formData
    })
    console.log('アップロード結果:', response)

    if (response) {
        currentUser.value = response
        dialog.value = false
        const attendance = groupUserAttendancesData.value.find(a => a.user.id === editUser.id)
        if (attendance) {
          attendance.user = response
        }
    }
  } catch (error) {
    console.log("APIエラー", error)
  }
}
</script>
