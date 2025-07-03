<template>
  <div v-if="user">
    <h1>{{ user.user_name }}</h1>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import type { UserResponse } from '~/types';

const config = useRuntimeConfig();
const { getAuthHeaders } = useApiClient()
const route = useRoute()
const userId = Number(route.query.user_id)

const user = ref()

onMounted(() => {
  getUser(userId)
})

async function getUser(userId: number): Promise<void> {
  try {
    const response: UserResponse = await $fetch(`${config.public.apiBase}/api/v1/users/${userId}`, {
      headers: getAuthHeaders()
    })

    user.value = response.user
  } catch (error) {
    console.error('APIエラー', error)
  }
}

</script>
