<template>
  <div>
    <v-menu :close-on-content-click="false">
      <template v-slot:activator="{ props }">
        <div class="d-flex justify-center pb-1">
          <v-btn v-bind="props" class="cursor-pointer">
            <client-only>{{ formatDate }}</client-only>
          </v-btn>
        </div>
      </template>
      <v-date-picker v-model="selectedDate" color="primary"></v-date-picker>
    </v-menu>
    <div class="d-flex justify-center pb-1">
      <v-btn rounded="0" size="small" class="rounded-s-xl" @click="dayBefore">-</v-btn>
      <v-btn rounded="0" size="small" class="px-8" @click="GetToday">今日</v-btn>
      <v-btn rounded="0" size="small" class="rounded-e-xl" @click="nextDay">+</v-btn>
    </div>
  </div>
</template>

<script setup lang="ts">
import { watch } from 'vue';
import type { AttendancesResponse } from '~/types/index';

const config = useRuntimeConfig()
const { getAuthHeaders } = useApiClient()

const { selectedDate, formatDate } = useDatePicker()
const { attendances } = useAttendances()
const { selectedGroup } = useSelectedGroup()

// 現在の日付を獲得
function GetToday() {
  selectedDate.value = new Date()
}

function nextDay() {
  const day = new Date(selectedDate.value)
  day.setDate(day.getDate() + 1)
  selectedDate.value = day
}

function dayBefore() {
  const day = new Date(selectedDate.value)
  day.setDate(day.getDate() - 1)
  selectedDate.value = day
}

watch(formatDate, async () => {
  const group = selectedGroup.value;
  if (!group || !group.id) return;
  await getAttendance(formatDate.value, group.id)
  });

// グループ名と日付を指定して出席データを取得（クリックイベント用）
async function getAttendance(date: string, groupId: number) {
  console.log('リクエスト送信', date)
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
