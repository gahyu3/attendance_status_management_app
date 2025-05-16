<template>
  <v-main>
    <v-container class="h-100 d-flex align-center justify-center">
      <v-sheet
        :elevation="11"
        :width="500"
        border
        rounded
        class="pa-10"
      >
      <div class="text-center mb-4">
        <h1>ログイン</h1>
      </div>
        <v-form @submit.prevent="submitForm">
          <v-text-field
            v-model="form.email"
            label="メールアドレス"
            placeholder="johndoe@gmail.com"
            type="email"
          ></v-text-field>
          <v-text-field
            v-model="form.password"
            label="パスワード"
            placeholder="●●●●●●●"
            type="password"
          ></v-text-field>
          <div v-if="errorMessage" class="text-red mb-2">メールアドレスかパスワードが違います</div>

          <v-layout>
            <v-btn
                  class="mx-auto"
                  color="success"
                  size="large"
                  type="submit"
                >
                  ログイン
            </v-btn>
          </v-layout>
        </v-form>
      </v-sheet>
    </v-container>
  </v-main>
</template>

<script setup>
import { ref } from 'vue'
import { navigateTo } from "nuxt/app";
const config = useRuntimeConfig()

const form = ref({
  email: "",
  password: ""
})

const responseData = ref(null)
const errorMessage = ref("")

const submitForm = async () => {
  try {
    const response = await fetch(`${config.public.apiLocal}/api/v1/sign_in`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(form.value)
    })

    const resData = await response.json()

    const accessToken = useCookie('access-token', { maxAge: 60 * 60 * 24, secure: true })
    const client = useCookie('client', { maxAge: 60 * 60 * 24, secure: true })
    const uid = useCookie('uid', { maxAge: 60 * 60 * 24, secure: true })

    if (accessToken && client && uid) {
      // トークンが存在する場合、sessionStorageに保存
      accessToken.value = response.headers.get('access-token')
      client.value = response.headers.get('client')
      uid.value = response.headers.get('uid')
      responseData.value = resData
      errorMessage.value = ""

      return navigateTo("/dashboard");
    } else {
      throw new Error('tokenがありません')
    }

  } catch (error) {
    console.error(error)
    errorMessage.value = error.message
  }
}
</script>
