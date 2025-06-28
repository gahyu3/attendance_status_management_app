<template>
  <v-btn v-if="currentUser && selectedGroup && isNotAttending()"
        text="出席"
        @click="createAttendance(formatDate,
                                currentUser?.id,
                                selectedGroup?.id)">
  </v-btn>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { AttendanceResponse } from '~/types/index';

const config = useRuntimeConfig()

const { getAuthHeaders } = useApiClient()
const { formatDate } = useDatePicker()
const { currentUser } = useCurrentUser()
const { attendances } = useAttendances()
const { selectedGroup } = useSelectedGroup()

function isNotAttending() {
  return !attendances.value?.attendances.find(a =>
    a.user.id === currentUser.value?.id &&
    a.date === formatDate.value &&
    a.group_id === selectedGroup.value?.id
  )
}

// 出席データを作成して追加
async function createAttendance(date: string,
                                userid: number,
                                groupId: number): Promise<void> {

  const attendanceParams = {
    attendance: {
      date: date,
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

    if (response.attendance) {
      console.log(response)
      attendances.value?.attendances.push(response.attendance)
    }
  } catch (error) {
    console.error('APIエラー:', error)
  }
};

</script>
