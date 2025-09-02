<template>
  <ClientOnly>
    <GoogleLogin :callback="callback">
      <v-btn color="green" prepend-icon="mdi mdi-google">
          <span v-if="!lording">ログイン</span>
          <span v-else>
            <v-progress-circular
              indeterminate
              color="white"
              size="20"
            ></v-progress-circular>
          </span>
      </v-btn>
    </GoogleLogin>
  </ClientOnly>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { GoogleLogin } from "vue3-google-login"
import type { LoginResponse, Token } from '~/types';
const config = useRuntimeConfig()

const callback = (response: any) => {
  if (response) {
    googleLogin(response)
  }
}

// const login = () => {
//   googleSdkLoaded((google) => {
//     google.accounts.id.initialize({
//       client_id: useRuntimeConfig().public.googleClientId,
//       callback: (response: any) => {
//         if (response) {
//           googleLogin(response)
//         }
//         console.log("Handle the response", response)
//       },
//       ux_mode: 'popup'
//     }),
//     google.accounts.id.prompt();
//   })
// }

// const login = () => {
//   googleSdkLoaded((google) => {
//     google.accounts.oauth2.initCodeClient({
//       client_id: useRuntimeConfig().public.googleClientId,
//       scope: 'email profile openid',
//       callback: (response) => {
//         console.log("Handle the response", response)
//       }
//     }).requestCode()
//   })
// }

// onMounted(() => {
//   login
// })

const lording = ref(false)

async function googleLogin(response: any) {
  lording.value = true
  let tokenHeaders: Token = {
      'access-token': null,
      client: null,
      uid: null
  }

  const code: LoginResponse = response.code

  try {
    await $fetch(`${config.public.apiBase}/api/v1/login`, {
      method: "POST",
      body: {
        code: code
      },
    onResponse({ response }) {
      tokenHeaders = {
        'access-token': response.headers.get('access-token'),
        client: response.headers.get('client'),
        uid: response.headers.get('uid'),
      }
    }
    })

    const accessToken = useCookie('access-token', { maxAge: 60 * 60 * 24, secure: true })
    const client = useCookie('client', { maxAge: 60 * 60 * 24, secure: true })
    const uid = useCookie('uid', { maxAge: 60 * 60 * 24, secure: true })

    if (tokenHeaders['access-token'] && tokenHeaders.client && tokenHeaders.uid) {
      accessToken.value = tokenHeaders['access-token']
      client.value = tokenHeaders.client
      uid.value = tokenHeaders.uid

      return navigateTo("/dashboard")
    } else {
      throw new Error('tokenがありません')
    }

  } catch (error) {
    console.error(error)
  } finally {
    lording.value = false
  }
}

</script>
