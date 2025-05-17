<template>
  <v-menu :close-on-content-click="false">
    <template v-slot:activator="{ props }">
      <v-btn v-bind="props" class="cursor-pointer">
        <client-only>{{ formatDate }}</client-only>
      </v-btn>
    </template>
    <v-date-picker v-model="selectedDate" color="primary"></v-date-picker>
  </v-menu>
  <v-btn @click="GetToday">今日</v-btn>
</template>

<script setup>
import { watch } from 'vue';

const config = useRuntimeConfig()
const { getAuthHeaders } = useApiClient()

const { selectedDate, formatDate } = useDatePicker()
const selectedGroup = useState("selectedGroup");
const groupUserAttendancesData = useState("groupUserAttendancesData");

// 現在の日付を獲得
function GetToday() {
  selectedDate.value = new Date()
}

watch(formatDate, async () => {
  await getAttendance(formatDate.value, selectedGroup.value.id)
  });

// グループ名と日付を指定して出席データを取得（クリックイベント用）
async function getAttendance(date, groupId) {
  console.log('リクエスト送信', date)
  try {
    const response = await $fetch(`${config.public.apiLocal}/api/v1/attendances`, {
      headers: getAuthHeaders(),
      query: {
        date: date,
        group_id: groupId
      }
    })
    if (response.attendances) {
      console.log(response)
      groupUserAttendancesData.value = response.attendances
    }
  } catch (error) {
    console.error('APIエラー:', error)
  }
}

</script>
