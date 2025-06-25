<template>
  <v-avatar v-if="user?.avatar_image?.url"
            @click="dialog = true"
            :image="`${localhost}${user?.avatar_image.url}`"
            size="32"
            class="cursor-pointer"
            start/>
  <v-icon v-else
          @click="dialog = true"
          icon="mdi-account-circle"
          size="x-large"
          class="cursor-pointer"
          start/>
  <DialogProfile v-model="dialog" :user="user"/>
</template>

<script setup lang="ts">
import type { User } from '~/types/index';
const props = defineProps<{ user: User | null}>()
const config = useRuntimeConfig();
const dialog = ref(false)
const localhost = ref('')

onMounted(() => {
  if (config.public.apiBase === "http://localhost:3000") {
    localhost.value = `${config.public.apiBase}`
  }
})

</script>
