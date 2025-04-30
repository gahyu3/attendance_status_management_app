<template>
  <v-avatar v-if="avatarImageUrl"
            @click="dialog = true"
            :image="`${config.public.apiBase}${avatarImageUrl}`"
            size="32"
            start/>
  <v-icon v-else
          @click="dialog = true"
          icon="mdi-account-circle"
          size="x-large" start/>
  <ProfileModal v-model="dialog"/>
</template>

<script setup>
defineProps({
  avatarImageUrl: ""
})
const config = useRuntimeConfig();
const dialog = ref(false)

</script>
