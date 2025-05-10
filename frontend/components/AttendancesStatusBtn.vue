<template>
  <v-btn :color=btnColor(item.attendances_status) @click="updateStatus(item.id, item.attendances_status)">
    {{ statusToJapanese(item.attendances_status) }}
  </v-btn>
</template>

<script setup>
import { ref } from 'vue'
const config = useRuntimeConfig()

defineProps({
  item:{}
})

const groupUserAttendancesData = useState("groupUserAttendancesData");

const { getData: updateAttendanceData,
  postFetch: updateAttendanceFetch
} = usePostFetch(`${config.public.apiBase}/api/v1/attendances`);

// PUTリクエストを送信
async function updateAttendance(attendance_id, newStatus) {
  const attendanceParams =
  { query: {
    attendance: {
      attendances_status: newStatus,
    }
  }
};

await updateAttendanceFetch("PUT", attendance_id, attendanceParams)
}

// UIとバックエンドの両方の出席ステータスを更新する関数
async function updateStatus(attendance_id, currentStatus) {
  const newStatus = changeStatus(currentStatus)
  await updateAttendance(attendance_id, newStatus)
  if (updateAttendanceData.value) {
    const newStatus = updateAttendanceData.value.attendance.attendances_status
    const index = groupUserAttendancesData.value.findIndex(a => a.id === attendance_id)

    groupUserAttendancesData.value[index].attendances_status = newStatus
  } else {
    console.log("データがありません")
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
