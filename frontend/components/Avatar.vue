<template>
  <v-avatar v-if="userImageUrl"
            :image="`${config.public.apiBase}${userImageUrl}`"
            size="32"
            start/>
  <v-icon v-else icon="mdi-account-circle" size="x-large" start/>
</template>

<script setup>
defineProps({
  userImageUrl: ""
})
const config = useRuntimeConfig();

</script>
