<template>
  <p>ログイン成功</p>
</template>

<script setup>
definePageMeta({
  middleware: [
    'auth',
  ],
});
</script>
