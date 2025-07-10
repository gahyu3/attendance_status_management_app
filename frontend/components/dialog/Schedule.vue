<template>
  <v-dialog v-model="dialog" @after-leave="onDialogToggle"
            width="auto">
    <v-card width="500"
            style="max-width: 90vw;"
            title="予定編集"
            class="pa-10">
      <v-form @submit.prevent="onSubmit()">
        <div class="py-5">
          <v-chip size="x-large" color="primary" variant="tonal">
            <div v-if="type===`edit`">
              {{ item?.date }}
            </div v-else>
            {{ date }}
          </v-chip>
        </div>
        <v-select
          v-model="editItem.schedule"
          label="参加予定"
          :items="scheduleList"
          variant="outlined"
        ></v-select>
        <v-text-field v-model="editItem.remarks"
                      label="備考"
                      type="text"
                      variant="outlined"
                      maxlength="10"
                      :counter="10"
                      ></v-text-field>
        <v-btn type="submit">
          編集
        </v-btn>
        <v-btn class="ms-auto"
              text="閉じる"
              @click="dialog = false">
        </v-btn>
      </v-form>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import type { Attendance, AttendanceResponse, EventItem, Schedule } from '~/types'

const props = defineProps<{
                item: Attendance | null | undefined
                attendance?: Attendance[]
                currentEvent?: any
                events?: EventItem[]
                setEvent?: (value: Attendance) => EventItem
                date?: string
                type: string
                calendar?: any
              }>()

const config = useRuntimeConfig()
const route = useRoute()
const dialog = defineModel<boolean>()
const { selectedDate, formatDate } = useDatePicker()
const { getAuthHeaders } = useApiClient()

const { attendances } = useAttendances()

const scheduleList = [
  { title: "終日参加", value: "full_day_attendance"},
  { title: "午前参加", value: "morning_attendance" },
  { title: "午後参加", value: "afternoon_attendance" },
];

const scheduleMap: Record<Schedule, string> = {
  full_day_attendance: "終日参加",
  morning_attendance: "午前参加",
  afternoon_attendance: "午後参加"
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
  afternoon_attendance: "orange"
}

const editItem = reactive({
  id: props.item?.id,
  schedule: props.item?.schedule,
  remarks: props.item?.remarks
})

watch(
  () => props.item,
  (item) => {
    if (item) {
      copyObject(item)
    }
  },
  { immediate: true }
)

function copyObject(item: Attendance): void {
  editItem.id = item.id
  editItem.schedule = item.schedule
  editItem.remarks = item.remarks
}

function onDialogToggle() {
  Object.assign(editItem, props.item)
}

// PUTリクエストを送信
async function updateSchedule(attendanceId?: number,
                              schedule?: string,
                              remarks?: string) {

  if (attendanceId == null || schedule == null) return

  const attendanceParams = {
      attendance: {
        schedule: schedule,
        remarks: remarks
    }
  };

  try {
    const response: AttendanceResponse = await $fetch(`${config.public.apiBase}/api/v1/attendances/${attendanceId}`, {
      method: "PUT",
      headers: getAuthHeaders(),
      body: attendanceParams
    })
    console.log(response)
    const updated = response.attendance;
    const attendanceList = attendances.value?.attendances;
    if (props.currentEvent) {
      props.currentEvent.setProp('title', scheduleToJapanese(updated.schedule))
      props.currentEvent.setProp('color', btnColor(updated.schedule))
      if (props.item) {
        props.item.schedule = updated.schedule
      }
    }

    dialog.value = false;

    if (!attendanceList) return;

    const target = attendanceList.find(att => att.id === attendanceId);
    if (!target) return;

    target.schedule = updated.schedule;
    target.remarks = updated.remarks;

  } catch (error) {
    console.error('APIエラー:', error)
  }
}

// POSTリクエストを送信
async function createAttendance(date: string,
                                schedule: string,
                                userid: number,
                                groupId: number): Promise<void> {

  const attendanceParams = {
    attendance: {
      date: date,
      schedule: schedule,
      remarks: "",
      user_id: userid,
      group_id: groupId,
    }
  };

  try {
    const response: AttendanceResponse = await $fetch(`${config.public.apiBase}/api/v1/attendances`, {
      method: "POST",
      headers: getAuthHeaders(),
      body: attendanceParams
    })

    const a =  response.attendance
    if (props.setEvent) {
      const event = props.setEvent(a)
      addEvent(event)
      props.events?.push(event)
      props.attendance?.push(a)
    }

    dialog.value = false
  } catch (error) {
    console.error('APIエラー:', error)
  }
};

// イベントを追加
function addEvent(event: EventItem) {
  const api = props.calendar?.getApi()
  if (api) {
    api.addEvent(event)
  } else {
    console.log("calendarAPIがありません")
  }
}

// typeがedit か new 判別
function onSubmit() {
  if (props.type === 'edit') {
    updateSchedule(editItem.id, editItem.schedule, editItem.remarks)
  } else if (props.type === 'new') {
    const userId = Number(route.query.user_id)
    const groupId = Number(route.query.group_id)
    if (props.date && editItem.schedule) {
      createAttendance(props.date, editItem.schedule, userId, groupId)
    } else {
      console.log("dateがありません")
    }
  }
}

</script>
