<template>
  <v-btn icon="mdi mdi-close-thick" variant="tonal" size="x-small" color="red" @click="deleteAttendance(item.id)">
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

// 出席データを削除
async function deleteAttendance(attendanceId) {
  try {
    const response = await $fetch(`${config.public.apiLocal}/api/v1/attendances/${attendanceId}`, {
      method: "DELETE",
      headers: getAuthHeaders(),
    })
    if (response) {
      console.log(response)
      const index = groupUserAttendancesData.value.findIndex(attendance => attendance.id === attendanceId)
      groupUserAttendancesData.value.splice(index, 1)
    }
  } catch (error) {
    console.error('APIエラー:', error)
  }
};

</script>
