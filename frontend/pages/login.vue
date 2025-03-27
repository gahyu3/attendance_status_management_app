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
const config = useRuntimeConfig()

const form = ref({
  email: "",
  password: ""
})

const response = ref(null)
const errorMessage = ref("")

const submitForm = async () => {
  try {
    const res = await $fetch(`${config.public.apiBase}/api/v1/sign_in`, {
      method: "POST",
      body: form.value
    })
    response.value = res
    errorMessage.value= ""
  } catch (error) {
    errorMessage.value = error.data.errors.join(', ')
  }
}
</script>
