<template>
  <v-btn v-if="item"
        :text="scheduleToJapanese(item?.schedule)"
        :color="btnColor(item?.schedule)"
        @click="dialog = true">
  </v-btn>
  <DialogSchedule v-model="dialog" :item="item" />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { Attendance, Schedule } from '~/types';

defineProps<{ item: Attendance | null }>()

const dialog = ref(false)

const scheduleMap: Record<Schedule, string> = {
  full_day_attendance: "終日参加",
  morning_attendance: "午前参加",
  afternoon_attendance: "午後参加"
}

const scheduleColorMap: Record<Schedule, string> = {
  full_day_attendance: "success",
  morning_attendance: "yellow",
  afternoon_attendance: "grey"
}

// ステータスに応じたボタンの色を返す
function btnColor(scheduleStatus: Schedule): string{
  return scheduleColorMap[scheduleStatus]
}


// ステータスを日本語化
function scheduleToJapanese(schedule: Schedule): string {
  return scheduleMap[schedule]
}

</script>
