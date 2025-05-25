<template>
  <ClientOnly>
    <GoogleLogin :callback="callback"/>
  </ClientOnly>
</template>

<script setup lang="ts">
import { ref } from 'vue';
const token = ref(null)
const callback = (response: any) => {
  if (response) {
    token.value = response.credential
  }
  console.log("Handle the response", response)
}

</script>
