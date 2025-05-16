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
import { ref, watch } from 'vue';

const config = useRuntimeConfig()

const { selectedDate, formatDate } = useDatePicker()
const selectedGroup = useState("selectedGroup");
const groupUserAttendancesData = useState("groupUserAttendancesData");

// 現在の日付を獲得
function GetToday() {
  selectedDate.value = new Date()
}

// グループ別ユーザー出席データ取得用
const { getData: groupUsersData,
        getFetch: groupUsersFetch
      } = useGetFetch(`${config.public.apiLocal}/api/v1/attendances`)

watch(formatDate, async () => {
  await groupUsersFetch({
          query: {
            group_id: selectedGroup.value.id,
            date: formatDate.value,
          }
        })
  if (groupUsersData.value?.attendances) {
    groupUserAttendancesData.value = groupUsersData.value.attendances
  } else {
    console.warn('出席データが見つかりません');
  }
});
</script>
