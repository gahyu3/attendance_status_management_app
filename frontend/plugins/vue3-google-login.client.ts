// plugins/vue3-google-login.client.ts
import { defineNuxtPlugin } from '#app'
import vue3GoogleLogin from 'vue3-google-login'

export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.vueApp.use(vue3GoogleLogin, {
    clientId: useRuntimeConfig().public.googleClientId
  })
})
