<template>
  <ClientOnly>
    <v-navigation-drawer>
      <v-list-item title="グループ"></v-list-item>
      <v-divider></v-divider>
      <v-list>
        <v-list-item v-for="(group, index) in groups.groups"
        :key="group.id"
        :value="group.name"
        :active="index === activeIndex"
        @click="getAttendance(formatDate, group.id),
                setActive(index),
                setGroup(group)">
          <v-list-item-title>{{ group.name }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
  </ClientOnly>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';

const config = useRuntimeConfig()
const { getAuthHeaders } = useApiClient()

const { selectedDate, formatDate } = useDatePicker()
const selectedGroup = useState("selectedGroup", () => null);
const groupUserAttendancesData = useState("groupUserAttendancesData", () => []);

const { data: groups } = await useFetch('/api/group')
const { data: attendances } = await useFetch('/api/attendance', {
  query: {
    date: formatDate,
    group_id: 1
  }
})

const activeIndex = ref(0);

onMounted(() => {
  if (attendances.value?.attendances) {
    groupUserAttendancesData.value = attendances.value.attendances
    }
  if (groups.value?.groups) {
    selectedGroup.value = groups.value?.groups?.[0]
    }
  }
)

// アクティブなインデックスをセット
function setActive(index: number): void {
  activeIndex.value = index;
}

// 現在選択中のグループ名をセット
function setGroup(group: string): void {
  selectedGroup.value = group
}

// グループ名と日付を指定して出席データを取得（クリックイベント用）
async function getAttendance(date, groupId) {

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
