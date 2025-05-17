<template>
  <v-btn icon="mdi mdi-close-thick" variant="tonal" size="x-small" color="red" @click="deleteAttendance(item.id)">
  </v-btn>
</template>

<script setup>
import { ref } from 'vue'
const config = useRuntimeConfig()

defineProps({
  item:{}
})

const groupUserAttendancesData = useState("groupUserAttendancesData");

const { getData: destroyAttendanceData,
  postFetch: destroyAttendanceFetch
} = usePostFetch(`${config.public.apiBase}/api/v1/attendances`);

// 出席状況の削除
async function deleteAttendance(attendanceId) {
  await destroyAttendanceFetch("DELETE", attendanceId)

  if (destroyAttendanceData.value) {
    const index = groupUserAttendancesData.value.findIndex(a => a.id === attendanceId)
    groupUserAttendancesData.value.splice(index, attendanceId)
  } else {
    console.log("データがありません")
  }
}

</script>
