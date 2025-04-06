<template>

  <AppHeader />
  <SideBar />
  <v-main>
  </v-main>

</template>

<script setup>
definePageMeta({
  middleware: [
    "auth",
  ],
});

</script>
