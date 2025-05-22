<template>
  <v-btn v-if="item"
          icon="mdi mdi-close-thick"
          variant="tonal"
          size="x-small"
          color="red"
          @click="deleteAttendance(item.id)">
  </v-btn>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { Attendance } from '~/types';

defineProps<{ item: Attendance | null }>()

const config = useRuntimeConfig()
const { getAuthHeaders } = useApiClient()
const { attendances } = useAttendances()

// 出席データを削除
async function deleteAttendance(attendanceId: number | null): Promise<void> {

  if (!attendanceId) return

  try {
    await $fetch(`${config.public.apiLocal}/api/v1/attendances/${attendanceId}`, {
      method: "DELETE",
      headers: getAuthHeaders(),
    })
    // attendances から該当データを削除
    const list = attendances.value?.attendances;
    const index = list?.findIndex(att => att.id === attendanceId);
    if (list && index !== undefined && index >= 0) {
      list.splice(index, 1);
    }
  } catch (error) {
    console.error('APIエラー:', error)
  }
};

</script>
