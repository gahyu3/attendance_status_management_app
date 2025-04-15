<template>

  <AppHeader />
  <SideBar />
  <v-main>
    <DateField />
    <div v-if="groupUserAttendancesData">
      <v-data-table :headers="headers" :items="groupUserAttendancesData">
        <template #item.user="{ item }">
          {{ item.user.user_name }}
        </template>
        <template #item.attendances_status="{ item }">
          <v-btn>
            {{ item.attendances_status }}
          </v-btn>
        </template>
      </v-data-table>
    </div>
  </v-main>

</template>

<script setup>
definePageMeta({
  middleware: [
    "auth",
  ],
});

const headers = [
  { title: "名前", value: "user" },
  { title: "予定", value: "schedule" },
  { title: "出席状況", value: "attendances_status" }
];

const groupUserAttendancesData = useState("groupUserAttendancesData");
</script>
