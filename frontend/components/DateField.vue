<template>
  <v-menu :close-on-content-click="false">
    <template v-slot:activator="{ props }">
      <v-btn v-bind="props" class="cursor-pointer">{{ formatDate }}</v-btn>
    </template>
    <v-date-picker v-model="selectedDate" color="primary"></v-date-picker>
  </v-menu>
  <v-btn @click="GetToday">今日</v-btn>
</template>

<script setup>
import { ref, computed } from 'vue';
const groupName = useState("groupName");

const { selectedDate } = useDatePicker()

const formatDate = computed(() => {
  return new Date(selectedDate.value).toLocaleDateString('ja-JP', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit'
    })
})

function GetToday() {
  selectedDate.value = new Date()
}
</script>
