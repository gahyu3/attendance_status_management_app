<template>

  <AppHeader />
  <SideBar />
  <v-main>
    <DateField />
    <div v-if="groupUserAttendancesData">
      <v-data-table :headers="headers" :items="groupUserAttendancesData">
        <template #item.avatar="{ item }">
          <Avatar :user="item.user" />
        </template>
        <template #item.user="{ item }">
          {{ item.user.user_name }}
        </template>
        <template #item.schedule="{ item }">
          <AttendancesScheduleBtn :item="item" />
        </template>
        <template #item.attendances_status="{ item }">
          <AttendancesStatusBtn :item="item" />
        </template>
        <template #item.destroy="{ item }">
          <AttendancesDestroyBtn :item="item" v-if="isUserCurrentUser(item.user_id)" />
        </template>
      </v-data-table>
      <AttendanceCreateBtn />
    </div>
  </v-main>

</template>

<script setup>
import { ref } from 'vue';
const config = useRuntimeConfig()
const currentUser = useState("currentUser");
const selectedGroup = useState("selectedGroup");
const groupUserAttendancesData = useState("groupUserAttendancesData");
const { formatDate } = useDatePicker()

definePageMeta({
  middleware: [
    "auth",
  ],
});

const headers = [
  { title: "", value: "avatar"},
  { title: "名前", value: "user" },
  { title: "備考", value: "remarks" },
  { title: "予定", value: "schedule" },
  { title: "出席状況", value: "attendances_status" },
  { title: "", value: "destroy" }
];

function isUserCurrentUser(userId) {
  return userId === currentUser.value.id
};


</script>
