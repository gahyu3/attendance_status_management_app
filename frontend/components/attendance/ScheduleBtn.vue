<template>
  <v-btn @click="dialog = true" :color="btnColor(item.schedule)">{{ scheduleToJapanese(item.schedule) }}</v-btn>
  <DialogSchedule v-model="dialog" :item="item" />
</template>

<script setup>
import { ref } from 'vue'
const config = useRuntimeConfig()

defineProps({
  item:{}
})

const dialog = ref(false)

const scheduleMap = {
  full_day_attendance: "終日参加",
  morning_attendance: "午前参加",
  afternoon_attendance: "午後参加"
}

const scheduleColorMap = {
  full_day_attendance: "success",
  morning_attendance: "yellow",
  afternoon_attendance: "grey"
}

// ステータスに応じたボタンの色を返す
function btnColor(scheduleStatus) {
  return scheduleColorMap[scheduleStatus] || ""
}


// ステータスを日本語化
function scheduleToJapanese(schedule) {
  if (scheduleMap[schedule] ) {
    return scheduleMap[schedule]
  } else {
    console.warn("予定が存在しません。")
  }
}

</script>
