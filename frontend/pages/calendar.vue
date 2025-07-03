<template>
  <v-row>
    <v-col>
      <div>
        <div class="ms-8 mb-1">
          <v-btn>{{ displayedMonth }}</v-btn>
        </div>
        <div class="pb-1">
          <v-btn rounded="0" size="small"  class="rounded-s-xl" @click="prev">前</v-btn>
          <v-btn rounded="0" size="small" class="px-8" @click="today">今月</v-btn>
          <v-btn rounded="0" size="small" class="rounded-e-xl" @click="next">次</v-btn>
        </div>
      </div>
    </v-col>
    <v-col align-self="center">
      <v-row justify="end" class="pe-10">
        <NuxtLink to="/dashboard">
          <v-btn>日時切替</v-btn>
        </NuxtLink>
      </v-row>
    </v-col>
  </v-row>
  <FullCalendar ref="calendar" :options="calendarOptions" />
</template>


<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useDate } from 'vuetify'
import type { Attendance, AttendancesResponse, EventItem, Schedule } from '~/types';
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import interactionPlugin from '@fullcalendar/interaction'
import allLocales from '@fullcalendar/core/locales-all'

definePageMeta({
  middleware: [
    "auth",
  ],
});

const config = useRuntimeConfig();
const { getAuthHeaders } = useApiClient()
const route = useRoute()
const calendar = ref()
const displayedMonth = ref()
const events: Ref<EventItem[]> = ref([]);

onMounted(() => {
  const userId = Number(route.query.user_id)
  const groupId = Number(route.query.group_id)
  getCalendar( currentStart.value, currentEnd.value, userId, groupId )
})

async function getCalendar(startDate: string, endDate: string, userId: number, groupId: number): Promise<void> {
  try {
    const response: AttendancesResponse = await $fetch(`${config.public.apiBase}/api/v1/attendances/calendar`, {
      headers: getAuthHeaders(),
      query: {
        start_date: startDate,
        end_date: endDate,
        user_id: userId,
        group_id: groupId
      }
    })

    changeAttendance(response)

  } catch (error) {
    console.error('APIエラー', error)
  }
}

function next() {
  calendar.value.getApi().next()
}

function prev() {
  calendar.value.getApi().prev()
}

function today() {
  calendar.value.getApi().today()
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
    allDay: true,
    color: btnColor(value.schedule)
  };
}

// ステータスを日本語化
function scheduleToJapanese(schedule: Schedule): string{
    return scheduleMap[schedule]
}

// ステータスに応じたボタンの色を返す
function btnColor(scheduleStatus: Schedule): string{
  return scheduleColorMap[scheduleStatus]
}

const scheduleColorMap: Record<Schedule, string> = {
  full_day_attendance: "#4CAF50",
  morning_attendance: "yellow",
  afternoon_attendance: "grey"
}

const currentStart = ref('')
const currentEnd = ref('')

const calendarOptions = {
  plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
  initialView: 'dayGridMonth', // 週表示（終日含む）
  headerToolbar: {
    left: '',
    center: '',
    end: ''
  },
  locales: allLocales,
  locale: 'ja', // ← ここで日本語を指定
  allDaySlot: true, // ← これが「終日スロット」表示を有効にする
  editable: true,
  dayCellContent: function (arg: any) {
    // 数字だけを返す（日付）
    return { html: String(arg.date.getDate()) }
  },
  dayCellDidMount(info: any) {
  if (info.isToday) {
    info.el.style.backgroundColor = '#ffebee' // 薄い赤系
    console.log('今日の日:', info.date)
  }},
  dateClick(info: any) {
    console.log('クリックされたイベント:', info)
  },
  events: events.value,
  datesSet(info: any) {
    displayedMonth.value = info.view.title
    currentStart.value = info.startStr
    currentEnd.value = info.endStr
    console.log('表示範囲が変わりました')
    console.log('表示月', info.view.title)
    console.log('開始日:', info.startStr)
    console.log('終了日:', info.endStr)
  }
}

</script>
