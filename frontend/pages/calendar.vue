<template>
  <CalendarHeader   :on-next="next"
                    :on-prev="prev"
                    :on-today="today"
                    :displayed-month="displayedMonth" />
  <FullCalendar ref="calendar" :options="calendarOptions" />
  <DialogSchedule v-model="dialog"  :item="item"
                                    :attendance="attendance"
                                    :current-event="currentEvent"
                                    :events="events"
                                    :set-event="setEvent"
                                    :date="date"
                                    :type="type"
                                    :calendar="calendar"/>
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
const date = ref()
const type = ref("edit")


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

const scheduleColorMap: Record<Schedule, string> = {
  full_day_attendance: "#4CAF50",
  morning_attendance: "#FDD835",
  afternoon_attendance: "orange"
}

// カレンダーのイベントを更新
function reloadCalendarEvents() {
  const api = calendar.value?.getApi()
  if (api) {
    api.removeAllEvents()
    api.addEventSource(events.value)
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
    if (checkEvents(info.date)) {
      type.value = "edit"
      item.value = findByDateAttendance(info.date)
    } else {
      item.value = null
      date.value = info.dateStr
      type.value = "new"
    }
    dialog.value = true
    console.log('日付クリック:', info.date)
  },
  eventClick(info: any) {
    dialog.value = true
    date.value = null
    currentEvent.value = info.event
    type.value = "edit"
    item.value = findAttendance(info.event)
    console.log("イベントクリック", info.event.extendedProps.id)
  },
  datesSet(info: any) {
    displayedMonth.value = info.view.title
    currentStart.value = info.startStr
    currentEnd.value = info.endStr
    getCalendar(currentStart.value, currentEnd.value, userId, groupId)
  },
  events: events.value,
}

function findAttendance(event: EventItem) {
  const eventAttendance = attendance.value?.find((a: { id: number; }) => a.id === event.extendedProps.id)
  if (eventAttendance) {
    return eventAttendance
  }
}

function findByDateAttendance(date: Date) {
  const event = events.value.find(e => {
    const d1 = new Date(e.start)
    return (
      d1.getFullYear() === date.getFullYear() &&
      d1.getMonth() === date.getMonth() &&
      d1.getDate() === date.getDate()
    )
  })

  if (event) {
    return findAttendance(event)
  }
}

function checkEvents(date: Date): boolean {
  return events.value.some(e => {
    const d1 = new Date(e.start)
    return (
      d1.getFullYear() === date.getFullYear() &&
      d1.getMonth() === date.getMonth() &&
      d1.getDate() === date.getDate()
    )
  })
}
</script>
