<template>
  <NuxtLink to="/dashboard">
    <v-icon icon="mdi mdi-calendar-blank-outline"></v-icon>
  </NuxtLink>
  {{ events }}
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

const { selectedDate, formatDate } = useDatePicker()

const events: Ref<EventItem[]> = ref([]);

onMounted(() => {
  getCalendar(formatDate.value,1,1)
})

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
  value.attendances.forEach((item: Attendance) => {
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
    title: scheduleToJapanese(value.schedule),
    start: new Date(value.date),
    end: new Date(value.date),
    allDay: true
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
  events: events.value,
  datesSet(info: any) {
    // カレンダー表示が変更された時（前月/次月含む）に発火
    console.log('表示範囲が変わりました')
    console.log('開始日:', info.startStr)
    console.log('終了日:', info.endStr)
  }
}

</script>
