<template>
  <v-btn>
    削除
  </v-btn>
</template>

<script setup>
import { ref } from 'vue'
const config = useRuntimeConfig()

defineProps({
  item:{}
})



</script>
