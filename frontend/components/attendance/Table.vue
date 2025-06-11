<template>
        <v-data-table :headers="headers" :items="attendances?.attendances">
          <template #item.avatar="{ item }">
            <Avatar :user="item.user" />
          </template>
          <template #item.user="{ item }">
            {{ item.user.user_name }}
          </template>
          <template #item.schedule="{ item }">
            <AttendanceBtnSchedule :item="item" />
          </template>
          <template #item.attendances_status="{ item }">
            <AttendanceBtnStatus :item="item" />
          </template>
          <template #item.destroy="{ item }">
            <AttendanceBtnDestroy :item="item" v-if="isUserCurrentUser(item.user_id)" />
          </template>
        </v-data-table>
        <AttendanceBtnCreate />
</template>

<script setup lang="ts">
const { currentUser } = useCurrentUser()
const { attendances } = useAttendances()


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

function isUserCurrentUser(userId: number): boolean {
  return userId === currentUser.value?.id
};

</script>

