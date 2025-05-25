<template>
  <v-main>
    <v-container class="h-100 d-flex align-center justify-center">
      <v-sheet :elevation="11"
                :width="500"
                border
                rounded
                class="pa-10">
      <div class="text-center mb-4">
        <h1>ログイン</h1>
      </div>
        <v-form @submit.prevent="formSubmit">
          <v-text-field
            v-model="form.email"
            label="メールアドレス"
            placeholder="johndoe@gmail.com"
            type="email">
          </v-text-field>
          <v-text-field
            v-model="form.password"
            label="パスワード"
            placeholder="●●●●●●●"
            type="password">
          </v-text-field>
          <div v-if="errorMessage" class="text-red mb-2">メールアドレスかパスワードが違います</div>

          <v-layout>
            <v-btn class="mx-auto"
                    color="success"
                    size="large"
                    type="submit">
                  ログイン
            </v-btn>
          </v-layout>
        </v-form>
        <GoogleBtn />
      </v-sheet>
    </v-container>
  </v-main>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { navigateTo } from "nuxt/app";
import type { Token } from '~/types';
const config = useRuntimeConfig()

const form = ref({
  email: "",
  password: ""
})

const errorMessage = ref("")

// ログインのPOSTリクエスト送信
async function formSubmit() {
  let tokenHeaders: Token = {
      'access-token': null,
      client: null,
      uid: null
  }

  try {
    await $fetch(`${config.public.apiLocal}/api/v1/sign_in`, {
      method: "POST",
      body: form.value,
      onResponse({ response }) {
        tokenHeaders = {
          'access-token': response.headers.get('access-token'),
          client: response.headers.get('client'),
          uid: response.headers.get('uid'),
        }
      }
    });

    const accessToken = useCookie('access-token', { maxAge: 60 * 60 * 24, secure: true })
    const client = useCookie('client', { maxAge: 60 * 60 * 24, secure: true })
    const uid = useCookie('uid', { maxAge: 60 * 60 * 24, secure: true })

    if (tokenHeaders['access-token'] && tokenHeaders.client && tokenHeaders.uid) {
      accessToken.value = tokenHeaders['access-token']
      client.value = tokenHeaders.client
      uid.value = tokenHeaders.uid
      errorMessage.value = ""

      return navigateTo("/dashboard")
    } else {
      throw new Error('tokenがありません')
    }

  } catch (error: any) {
    console.error(error)
    errorMessage.value = error.message
  }
}

</script>
