<template>
  <NuxtLink to="/calendar">
    <v-icon icon="mdi mdi-calendar-blank-outline"></v-icon>
  </NuxtLink>
  <AttendanceHeader />
  <AttendanceTable />
</template>

<script setup lang="ts">
definePageMeta({
  middleware: [
    "auth",
  ],
});
</script>

