<template>
  <v-menu :close-on-content-click="false">
    <template v-slot:activator="{ props }">
      <v-btn v-bind="props" class="cursor-pointer">{{ formatted }}</v-btn>
    </template>
    <v-date-picker v-model="selectedDate" color="primary"></v-date-picker>
  </v-menu>
  <v-btn @click="GetToday">今日</v-btn>
</template>

<script setup>
import { ref } from 'vue';
import { useDate } from 'vuetify'

const today = new Date()
const selectedDate = ref(today)
const date = useDate()
const formatted = computed(() => {
  return selectedDate.value
    ? date.toISO(new Date(selectedDate.value))
    : ''
})

function GetToday() {
  selectedDate.value = today
}
</script>
