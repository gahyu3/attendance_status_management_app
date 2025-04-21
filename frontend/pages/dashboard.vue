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
      <v-btn @click="createAttendance(formatDate, currentUser.id, selectedGroup.id)">+</v-btn>
    </div>
  </v-main>

</template>

<script setup>
import { ref } from 'vue';
const config = useRuntimeConfig()
const currentUser = useState("currentUser");
const selectedGroup = useState("selectedGroup");
const { formatDate } = useDatePicker()

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

const { getData: postAttendanceData,
        postFetch: postAttendanceFetch
      } = usePostFetch(`${config.public.apiBase}/api/v1/attendances`);

async function createAttendance(date, user_id, group_id) {

  const attendanceParams =
    { query: {
        attendance: {
          date: date,
          remarks: "",
          user_id: user_id,
          group_id: group_id,
          }
        }
    };

  await postAttendanceFetch(attendanceParams)

  if (postAttendanceData.value) {
    groupUserAttendancesData.value.push(postAttendanceData.value.attendance)
  }
};

</script>
