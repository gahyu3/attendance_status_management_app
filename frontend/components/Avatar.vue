<template>
  <v-avatar v-if="user?.avatar_image?.url"
            @click="dialog = true"
            :image="`${config.public.apiBase}${user?.avatar_image?.url}`"
            size="32"
            class="cursor-pointer"
            start/>
  <v-icon v-else
          @click="dialog = true"
          icon="mdi-account-circle"
          size="x-large"
          class="cursor-pointer"
          start/>
  <ProfileModal v-model="dialog" :user="user"/>
</template>

<script setup>
defineProps({
  user: {},
})
const config = useRuntimeConfig();
const dialog = ref(false)

</script>
