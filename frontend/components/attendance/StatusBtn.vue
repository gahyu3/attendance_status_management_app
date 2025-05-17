<template>
  <v-btn :color=btnColor(item.attendances_status) @click="updateAttendanceStatus(item.id, item.attendances_status)">
    {{ statusToJapanese(item.attendances_status) }}
  </v-btn>
</template>

<script setup>
import { ref } from 'vue'

defineProps({
  item:{}
})

const config = useRuntimeConfig()
const { getAuthHeaders } = useApiClient()

const groupUserAttendancesData = useState("groupUserAttendancesData");

// UIとバックエンドの両方の出席ステータスを更新する関数
async function updateAttendanceStatus(attendance_id, currentStatus) {
  const newStatus = changeStatus(currentStatus)
  await updateStatus(attendance_id, newStatus)
}

// PUTリクエストを送信
async function updateStatus(attendanceId, newStatus) {
  const attendanceParams = {
    attendance: {
      attendances_status: newStatus,
    }
  };

  try {
    const response = await $fetch(`${config.public.apiLocal}/api/v1/attendances/${attendanceId}`, {
      method: "PUT",
      headers: getAuthHeaders(),
      body: attendanceParams
    })
    if (response.attendance) {
      console.log(response)
      const newStatus = response.attendance.attendances_status
      const index = groupUserAttendancesData.value.findIndex(attendance => attendance.id === attendanceId)
      groupUserAttendancesData.value[index].attendances_status = newStatus
    }
  } catch (error) {
    console.error('APIエラー:', error)
  }
}

const statusMap = ref({
  present: "出席中",
  away: "離席中",
  before: "参加前",
  finished: "終了"
})

// ステータスを日本語化
function statusToJapanese(status) {
  if (statusMap.value[status] ) {
    return statusMap.value[status]
  } else {
    console.warn("ステータスが存在しません。")
  }
}

const statusList = ["present", "away", "before", "finished"]

// ステータスをトグルする（present → away → before → finished）
function changeStatus(currentStatus) {
  const currentIndex = statusList.indexOf(currentStatus)
  // 不明なステーテスの場合indexOfが-1を返すため
  if (currentIndex === -1) {
    console.warn("不明なステータスかステータスが存在しません")
    return null
  }
  const nextIndex = (currentIndex + 1) % statusList.length
  return statusList[nextIndex]
}

const statusColorMap = {
  present: "success",
  away: "yellow",
  before: "grey",
  finished: "grey"
}

// ステータスに応じたボタンの色を返す
function btnColor(currentStatus) {
  return statusColorMap[currentStatus] || ""
}
</script>
