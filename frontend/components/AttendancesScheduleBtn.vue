<template>
  <v-btn>{{ scheduleToJapanese(item.schedule) }}</v-btn>
</template>

<script setup>
import { ref } from 'vue'
const config = useRuntimeConfig()

defineProps({
  item:{}
})

const scheduleMap = {
  full_day_attendance: "終日参加",
  morning_attendance: "午前参加",
  afternoon_attendance: "午後参加"
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
