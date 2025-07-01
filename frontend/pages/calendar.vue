<template>
  <NuxtLink to="/dashboard">
    <v-icon icon="mdi mdi-calendar-blank-outline"></v-icon>
  </NuxtLink>
  <FullCalendar :options="calendarOptions" />
</template>


<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useDate } from 'vuetify'
import type { Attendance, AttendancesResponse, EventItem, Schedule } from '~/types';
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import interactionPlugin from '@fullcalendar/interaction'

definePageMeta({
  middleware: [
    "auth",
  ],
});
const config = useRuntimeConfig();
const { getAuthHeaders } = useApiClient()

const { selectedDate } = useDatePicker()

const events: Ref<EventItem[]> = ref([]);

async function getCalendar(date: string, userId: number, groupId: number): Promise<void> {
  try {
    const response: AttendancesResponse = await $fetch(`${config.public.apiBase}/api/v1/attendances/calendar`, {
      headers: getAuthHeaders(),
      query: {
        date: date,
        user_id: userId,
        group_id: groupId
      }
    })

    changeAttendance(response)

  } catch (error) {
    console.error('APIエラー', error)
  }
}


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

const calendarOptions = {
  plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
  initialView: 'dayGridMonth', // 週表示（終日含む）
  headerToolbar: {
    left: 'prev,next today',
    center: 'title',
    end: ''
  },
  allDaySlot: true, // ← これが「終日スロット」表示を有効にする
  editable: true,
  events: [
    {
      title: '終日イベント',
      start: '2025-06-30',
      allDay: true,
    },
    {
      title: '会議',
      start: '2025-06-30',
      end: '2025-06-30',
    },
  ],
}

</script>
