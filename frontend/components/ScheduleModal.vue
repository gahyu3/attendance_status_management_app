<template>
  <v-dialog v-model="dialog"
            width="auto">
    <v-card width="500"
            style="max-width: 90vw;"
            title="予定編集"
            class="pa-10">
      <v-form>
        <div class="py-5">
          <v-chip size="x-large" color="primary" variant="tonal">
            {{ formatDate }}
          </v-chip>
        </div>
        <v-select
          v-model="item.schedule"
          label="参加予定"
          :items="scheduleList"
          variant="outlined"
        ></v-select>
        <v-text-field v-model="item.remarks"
                        label="備考"
                        type="text"
                        variant="outlined"
                        maxlength="10"
                        :counter="10"
                        ></v-text-field>
        <v-btn type="submit">
          編集
        </v-btn>
      </v-form>
      <v-btn class="ms-auto"
            text="閉じる"
            @click="dialog = false">
      </v-btn>
    </v-card>
  </v-dialog>
</template>

<script setup>
defineProps({
  item:{}
})

const dialog = defineModel()
const { selectedDate, formatDate } = useDatePicker()
const scheduleList = [
  { title: "終日参加", value: "full_day_attendance"},
  { title: "午前参加", value: "morning_attendance" },
  { title: "午後参加", value: "afternoon_attendance" },
];

</script>
