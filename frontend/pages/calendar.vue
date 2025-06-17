<template>
  <NuxtLink to="/dashboard">
    <v-icon icon="mdi mdi-calendar-blank-outline"></v-icon>
  </NuxtLink>
  <v-btn @click="changeAttendance(attendanceList)">aaa</v-btn>
  {{ events }}
  <v-calendar ref="calendar"
          :v-model="today"
          :events="events"
          color="primary"
          type="month">
  <template #event="{ event }">
      <div class="px-2 py-1 rounded bg-green text-center">
        {{ scheduleToJapanese(event.title as Schedule) }}
      </div>
  </template>
  </v-calendar>
</template>


<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useDate } from 'vuetify'
import type { Attendance, EventItem, Schedule } from '~/types';

definePageMeta({
  middleware: [
    "auth",
  ],
});

const { selectedDate } = useDatePicker()

const calendar = ref()
const today = ref(new Date())
const attendanceList = [{
  id: 10,
  date: "2025-06-13",
  schedule: "full_day_attendance",
  attendances_status: "present",
  remarks: "",
  user_id: 7,
  group_id: 2,
  created_at: "2025-05-29T18:47:24.379+09:00",
  updated_at: "2025-05-29T18:47:24.379+09:00",
  user: {
    id: 7,
    provider: "email",
    uid: "brittney_brekke@collins-kling.test",
    allow_password_change: false,
    user_name: "野村 明日香",
    email: "brittney_brekke@collins-kling.test",
    avatar_image: {
      url: "/uploads/user/avatar_image/7/cat.jpg"
    }
  }},
{
  id: 10,
  date: "2025-06-20",
  schedule: "full_day_attendance",
  attendances_status: "present",
  remarks: "",
  user_id: 7,
  group_id: 2,
  created_at: "2025-05-29T18:47:24.379+09:00",
  updated_at: "2025-05-29T18:47:24.379+09:00",
  user: {
    id: 7,
    provider: "email",
    uid: "brittney_brekke@collins-kling.test",
    allow_password_change: false,
    user_name: "野村 明日香",
    email: "brittney_brekke@collins-kling.test",
    avatar_image: {
      url: "/uploads/user/avatar_image/7/cat.jpg"
    },
  }
}]

const events: Ref<EventItem[]> = ref([]);

function changeAttendance(value: any) {
  value.forEach((item: Attendance) => {
    const event = setAttendance(item)
    events.value?.push(event);
  });
}

const scheduleMap: Record<Schedule, string> = {
  full_day_attendance: "終日参加",
  morning_attendance: "午前参加",
  afternoon_attendance: "午後参加"
}

function setAttendance(value: Attendance): EventItem {
  return {
    title: value.schedule,
    start: new Date(value.date),
    end: new Date(value.date),
  };
}

// ステータスを日本語化
function scheduleToJapanese(schedule: Schedule): string{
    return scheduleMap[schedule]
}

</script>
