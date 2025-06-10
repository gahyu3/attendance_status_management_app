<template>
  <ClientOnly>
    <GoogleLogin :callback="callback"/>
  </ClientOnly>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import type { LoginResponse, Token } from '~/types';
const config = useRuntimeConfig()

const callback = (response: any) => {
  if (response) {
    googleLogin(response)
  }
  console.log("Handle the response", response)

async function googleLogin(response: any) {
  let tokenHeaders: Token = {
      'access-token': null,
      client: null,
      uid: null
  }

  const token: LoginResponse = response.credential
  try {
    await $fetch(`${config.public.apiBase}/api/v1/login`, {
      method: "POST",
      body: {
        id_token: token
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
  }
}
}

</script>
