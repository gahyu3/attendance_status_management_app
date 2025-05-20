<template>
    <v-app-bar color="primary" height="100">
      <v-app-bar-title>
        Application
      </v-app-bar-title>
    <template v-slot:append>
      <Avatar :user="currentUser" />
      <div v-if="currentUser">
        {{ currentUser.user_name }}
      </div>
      <v-btn @click="logout">ログアウト</v-btn>
    </template>
  </v-app-bar>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import type { LoginResponse, LogoutResponse } from '~/types/index'

const config = useRuntimeConfig()
const { getAuthHeaders } = useApiClient()

const { currentUser } = useCurrentUser()
const { data } = await useFetch<LoginResponse>('/api/auth')

if (data.value) {
  currentUser.value = data.value.data
}

async function logout(): Promise<void> {
  try {
    const response: LogoutResponse = await $fetch(`${config.public.apiLocal}/api/v1/sign_out`, {
      method: "DELETE",
      headers: getAuthHeaders()
    })
    if (response.success === true) {
      // クッキーを削除してログアウト
      useCookie("access-token").value = null
      useCookie("client").value = null
      useCookie("uid").value = null
      await navigateTo("/login")
    }
  } catch (error) {
    console.error("ログアウト失敗", error)
  }
}

</script>

