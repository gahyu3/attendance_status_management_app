<template>
  <CalendarHeader   :on-next="next"
                    :on-prev="prev"
                    :on-today="today"
                    :displayed-month="displayedMonth" />
  <FullCalendar ref="calendar" :options="calendarOptions" />
  <DialogSchedule v-if="item" v-model="dialog" :item="item" :current-event="currentEvent"/>
</template>


<script setup lang="ts">
import { onMounted, ref } from 'vue'
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
const events = ref<EventItem[]>([])
const userId = Number(route.query.user_id)
const groupId = Number(route.query.group_id)
const currentStart = ref('')
const currentEnd = ref('')
const dialog = ref(false)
const item = ref<Attendance | null>()
const attendance = ref()
const currentEvent = ref()


onMounted(() => {
  getCalendar(currentStart.value, currentEnd.value, userId, groupId)
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

    attendance.value = response.attendances
    const eventArray =  changeAttendance(response)
    events.value = eventArray
    reloadCalendarEvents()
  } catch (error) {
    console.error('APIエラー', error)
  }
}

function changeAttendance(value: any): EventItem[] {
  return value.attendances.map((item: Attendance) => setEvent(item))
}

const scheduleMap: Record<Schedule, string> = {
  full_day_attendance: "終日参加",
  morning_attendance: "午前参加",
  afternoon_attendance: "午後参加"
}

function setEvent(value: Attendance): EventItem {
  return {
    title: scheduleToJapanese(value.schedule),
    start: new Date(value.date),
    end: new Date(value.date),
    allDay: true,
    color: btnColor(value.schedule),
    extendedProps: {
      id: value.id
    }
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

// カレンダーのイベントを更新
function reloadCalendarEvents() {
  const api = calendar.value?.getApi()
  if (api) {
    api.removeAllEvents()
    api.addEventSource(events.value)
  }
}

const scheduleColorMap: Record<Schedule, string> = {
  full_day_attendance: "#4CAF50",
  morning_attendance: "yellow",
  afternoon_attendance: "grey"
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


const calendarOptions = {
  plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
  initialView: 'dayGridMonth', // 週表示（終日含む）
  headerToolbar: {
    left: '',
    center: '',
    end: ''
  },
  locales: allLocales,
  locale: 'ja',
  allDaySlot: true,
  editable: true,
  dayCellContent: function (arg: any) {
    return { html: String(arg.date.getDate()) }
  },
  dayCellDidMount(info: any) {
  if (info.isToday) {
    info.el.style.backgroundColor = '#ffebee'
    console.log('今日の日:', info.date)
  }},
  dateClick(info: any) {
    console.log('日付クリック:', info)
  },
  eventClick(info: any) {
    dialog.value = true
    currentEvent.value = info.event
    findAttendance(info.event)
    console.log("イベントクリック", info.event.extendedProps.id)
  },
  datesSet(info: any) {
    displayedMonth.value = info.view.title
    currentStart.value = info.startStr
    currentEnd.value = info.endStr
    getCalendar(currentStart.value, currentEnd.value, userId, groupId)
    console.log('表示範囲が変わりました')
    console.log('表示月', info.view.title)
    console.log('開始日:', info.startStr)
    console.log('終了日:', info.endStr)
  },
  events: events.value,
}

function findAttendance(event: EventItem) {
  const eventAttendance = attendance.value?.find((a: { id: number; }) => a.id === event.extendedProps.id)
  item.value = eventAttendance
}

</script>
