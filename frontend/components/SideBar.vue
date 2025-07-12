<template>
  <ClientOnly>
    <v-navigation-drawer permanent>
      <v-list-item title="グループ"></v-list-item>
      <v-divider></v-divider>
      <v-list>
        <v-list-item v-for="(group, index) in groupDate?.groups"
        :key="group.id"
        :value="group.name"
        :active="index === activeIndex"
        @click="getAttendance(formatDate, group.id);
                setActive(index);
                setGroup(group);
                navigateDashboard();">
          <v-list-item-title>{{ group.name }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
  </ClientOnly>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { navigateTo } from "nuxt/app";
import type { AttendancesResponse, GroupResponse, Group } from '~/types/index';

const config = useRuntimeConfig()
const { getAuthHeaders } = useApiClient()

const { selectedDate, formatDate } = useDatePicker()
const { attendances } = useAttendances()
const { selectedGroup } = useSelectedGroup()

const { data: groupDate } = await useFetch<GroupResponse>('/api/group')
const { data: attendanceDate } = await useFetch<AttendancesResponse>('/api/attendance', {
  query: {
    date: formatDate,
    group_id: 1
  }
})

const activeIndex = ref(0);

onMounted(() => {
  if (attendanceDate.value?.attendances) {
    attendances.value = attendanceDate.value
    }
  if (groupDate.value?.groups) {
    console.log(groupDate.value)
    selectedGroup.value = groupDate.value?.groups[0]
    }
  }
)

// dashboardページに移動
function navigateDashboard() {
  navigateTo("/dashboard")
}

// アクティブなインデックスをセット
function setActive(index: number): void {
  activeIndex.value = index;
}

// 現在選択中のグループ名をセット
function setGroup(group: Group): void {
  selectedGroup.value = group
}

// グループ名と日付を指定して出席データを取得（クリックイベント用）
async function getAttendance(date: string, groupId: number): Promise<void> {

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
