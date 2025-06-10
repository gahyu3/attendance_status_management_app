<template>
  <v-dialog v-model="dialog" @after-leave="onDialogToggle"
            width="auto">
    <v-card width="500"
            style="max-width: 90vw;"
            title="予定編集"
            class="pa-10">
      <v-form @submit.prevent="updateSchedule(editItem.id,
                                              editItem.schedule,
                                              editItem.remarks)">
        <div class="py-5">
          <v-chip size="x-large" color="primary" variant="tonal">
            {{ formatDate }}
          </v-chip>
        </div>
        <v-select
          v-model="editItem.schedule"
          label="参加予定"
          :items="scheduleList"
          variant="outlined"
        ></v-select>
        <v-text-field v-model="editItem.remarks"
                      label="備考"
                      type="text"
                      variant="outlined"
                      maxlength="10"
                      :counter="10"
                      ></v-text-field>
        <v-btn type="submit">
          編集
        </v-btn>
        <v-btn class="ms-auto"
              text="閉じる"
              @click="dialog = false">
        </v-btn>
      </v-form>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import type { Attendance, AttendanceResponse } from '~/types'

const props = defineProps<{
                item: Attendance | null
              }>()

const config = useRuntimeConfig()
const dialog = defineModel<boolean>()
const { selectedDate, formatDate } = useDatePicker()
const { getAuthHeaders } = useApiClient()

const { attendances } = useAttendances()

const scheduleList = [
  { title: "終日参加", value: "full_day_attendance"},
  { title: "午前参加", value: "morning_attendance" },
  { title: "午後参加", value: "afternoon_attendance" },
];

const editItem = reactive({
  id: props.item?.id,
  schedule: props.item?.schedule,
  remarks: props.item?.remarks
})

watch(
  () => props.item,
  (item) => {
    if (item) {
      copyObject(item)
    }
  },
  { immediate: true }
)

function copyObject(item: Attendance): void {
  editItem.id = item.id
  editItem.schedule = item.schedule
  editItem.remarks = item.remarks
}

function onDialogToggle() {
  Object.assign(editItem, props.item)
}

// PUTリクエストを送信
async function updateSchedule(attendanceId?: number,
                              schedule?: string,
                              remarks?: string) {

  if (attendanceId == null || schedule == null) return

  const attendanceParams = {
      attendance: {
        schedule: schedule,
        remarks: remarks
    }
  };

  try {
    const response: AttendanceResponse = await $fetch(`${config.public.apiBase}/api/v1/attendances/${attendanceId}`, {
      method: "PUT",
      headers: getAuthHeaders(),
      body: attendanceParams
    })
    console.log(response)
    const updated = response.attendance;
    const attendanceList = attendances.value?.attendances;
    if (!attendanceList) return;

    const target = attendanceList.find(att => att.id === attendanceId);
    if (!target) return;

    target.schedule = updated.schedule;
    target.remarks = updated.remarks;

    dialog.value = false;
  } catch (error) {
    console.error('APIエラー:', error)
  }
}

</script>
