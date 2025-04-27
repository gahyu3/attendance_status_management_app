<template>
  <v-avatar v-if="avatarImageUrl"
            :image="`${config.public.apiBase}${avatarImageUrl}`"
            size="32"
            start/>
  <v-icon v-else icon="mdi-account-circle" size="x-large" start/>
</template>

<script setup>
defineProps({
  avatarImageUrl: ""
})
const config = useRuntimeConfig();

</script>
