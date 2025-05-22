<template>
  <v-btn v-if="item"
        :color="btnColor(item.attendances_status)"
        @click="updateAttendanceStatus(item.id, item.attendances_status)">
    {{ statusToJapanese(item.attendances_status) }}
  </v-btn>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { Attendance, AttendanceResponse, Status, StatusColorMap, StatusMap } from '~/types';

defineProps<{ item: Attendance | null }>()

const config = useRuntimeConfig()
const { getAuthHeaders } = useApiClient()
const { attendances } = useAttendances()

// UIとバックエンドの両方の出席ステータスを更新する関数
async function updateAttendanceStatus(attendance_id: number, currentStatus: Status) {
  const newStatus = changeStatus(currentStatus)
  await updateStatus(attendance_id, newStatus)
}

// PUTリクエストを送信
async function updateStatus(attendanceId: number, newStatus: Status) {
  const attendanceParams = {
    attendance: {
      attendances_status: newStatus,
    }
  };

  try {
    const response: AttendanceResponse = await $fetch(`${config.public.apiLocal}/api/v1/attendances/${attendanceId}`, {
      method: "PUT",
      headers: getAuthHeaders(),
      body: attendanceParams
    })
      const newStatus = response.attendance.attendances_status
      const index = attendances.value?.attendances.findIndex(att => att.id === attendanceId)
      if (index !== undefined && index !== -1 && attendances.value) {
        attendances.value.attendances[index].attendances_status = newStatus;
      }
    } catch (error) {
    console.error('APIエラー:', error)
  }
}

const statusMap:Record<Status, string> = {
  present: "出席中",
  away: "離席中",
  before: "参加前",
  finished: "終了"
}

// ステータスを日本語化
function statusToJapanese(status: Status): string{
    return statusMap[status]
}

const statusList: Status[]  = ["present", "away", "before", "finished"]

// ステータスをトグルする（present → away → before → finished）
function changeStatus(currentStatus: Status): Status{
  const currentIndex = statusList.indexOf(currentStatus)
  const nextIndex = (currentIndex + 1) % statusList.length
  return statusList[nextIndex] || ""
}

const statusColorMap: StatusColorMap = {
  present: "success",
  away: "yellow",
  before: "grey",
  finished: "grey"
}

// ステータスに応じたボタンの色を返す
function btnColor(currentStatus: Status): string{
  return statusColorMap[currentStatus]
}
</script>
