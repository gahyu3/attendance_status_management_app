<template>
  <v-btn :color=btnColor(item.attendances_status) @click="updateStatus(item.id, item.attendances_status)">
    {{ item.attendances_status }}
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

// ステータスをトグルする（present → away、away → present）
function changeStatus(currentStatus) {
  switch (currentStatus) {
    case "present":
      return "away"
    case "away":
      return "present"
    default:
      return currentStatus
  }
}

// ステータスに応じたボタンの色を返す
function btnColor(currentStatus) {
  switch (currentStatus) {
    case "present":
      return "success"
    case "away":
      return "yellow"
    default:
      return ""
  }
}
</script>
