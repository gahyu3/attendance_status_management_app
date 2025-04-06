<template>

  <AppHeader />
  <SideBar />
  <v-main>
    {{ groupUserAttendancesData }}
  </v-main>

</template>

<script setup>
definePageMeta({
  middleware: [
    "auth",
  ],
});

const groupUserAttendancesData = useState("groupUserAttendancesData");

</script>
