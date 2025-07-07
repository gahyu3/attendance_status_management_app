<template>
  <v-row>
    <v-col cols="5">
      <div>
        <div class="ms-9 mb-1">
          <v-btn>{{ displayedMonth }}</v-btn>
        </div>
        <div class="pb-1">
          <v-btn rounded="0" size="small"  class="rounded-s-xl" @click="
            onPrev">前</v-btn>
          <v-btn rounded="0" size="small" class="px-8" @click="onToday">今月</v-btn>
          <v-btn rounded="0" size="small" class="rounded-e-xl" @click="onNext">次</v-btn>
        </div>
      </div>
    </v-col>
    <v-col align-self="center">
      <v-row>
        <div v-if="user">
        <h1>{{ user.user_name }}</h1>
      </div>
      </v-row>
    </v-col>
    <v-col align-self="center">
      <v-row justify="end" class="pe-10">
        <NuxtLink to="/dashboard">
          <v-btn>日時切替</v-btn>
        </NuxtLink>
      </v-row>
    </v-col>
</v-row>

</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import type { UserResponse } from '~/types';
defineProps<{
  onNext: () => void,
  onPrev: () => void,
  onToday: () => void,
  displayedMonth?: string
}>()

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
