<template>
  <v-dialog v-model="dialog" @update:modelValue="onDialogToggle"
            width="auto">
      <v-card width="500"
              style="max-width: 90vw;"
              title="ユーザー編集"
              class="pa-10">
        <v-form>
          <div class="d-flex justify-center">
            <v-avatar :image="image" size="120"/>
          </div>
          <div class="d-flex justify-center pt-5 pb-5">
            <v-btn @click="onInput">アバター編集</v-btn>
          </div>
          <input type="file" ref="file" @change="prevImage" class="d-none"></input>

          <v-text-field v-model="user.user_name"
                        label="ユーザーネーム"
                        placeholder="太郎"
                        type="text"></v-text-field>
        </v-form>
        <template v-slot:actions>
          <v-btn  class="ms-auto"
                  text="閉じる"
                  @click="dialog = false">
          </v-btn>
        </template>
      </v-card>
    </v-dialog>
</template>

<script setup>
import { ref, watch } from 'vue'

const dialog = defineModel()
const props = defineProps({
                user: {}
              })

const config = useRuntimeConfig()

const file = ref(null)
const image = ref(null)
const originalImage = ref(null)

watch(
  () => props.user,
  (newUser) => {
    if (newUser?.avatar_image?.url) {
      const imageUrl = `${config.public.apiBase}${newUser.avatar_image.url}`
      image.value = imageUrl
      originalImage.value = imageUrl
    }
  },
  { immediate: true }
)

function onInput() {
  file.value.click()
}

// 選択した画像をプレビュー表示
function prevImage(event) {
  const selectedFile = event.target.files[0]
  if (selectedFile) {
    image.value = URL.createObjectURL(selectedFile)
    console.log(image.value)
  }
}

// ダイアログを閉じた時に元の画像を表示
function onDialogToggle(isOpen) {
  if (!isOpen) {
    image.value = originalImage.value
  }
}

</script>
