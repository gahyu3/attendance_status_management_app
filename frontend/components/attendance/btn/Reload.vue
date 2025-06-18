<template>
  <v-btn v-if="selectedGroup" icon="mdi-cached" @click="getAttendance(formatDate, selectedGroup.id)"></v-btn>
</template>

<script setup lang="ts">
import type { AttendancesResponse } from '~/types'

const config = useRuntimeConfig()
const { getAuthHeaders } = useApiClient()

const { selectedDate, formatDate } = useDatePicker()
const { attendances } = useAttendances()
const { selectedGroup } = useSelectedGroup()

// グループ名と日付を指定して出席データを取得（クリックイベント用）
async function getAttendance(date: string, groupId: number): Promise<void> {

  try {
    const response: AttendancesResponse = await $fetch(`${config.public.apiBase}/api/v1/attendances`, {
      headers: getAuthHeaders(),
      query: {
        date: date,
        group_id: groupId
      }
    })
    if (response.attendances) {
      console.log(response)
      attendances.value = response
    }
  } catch (error) {
    console.error('APIエラー:', error)
  }
}

</script>
