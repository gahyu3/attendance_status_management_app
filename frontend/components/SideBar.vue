<template>
  <v-navigation-drawer permanent>
    <v-list-item title="グループ"></v-list-item>
    <v-divider></v-divider>
    <v-list>
      <v-list-item v-for="(group, index) in groups" :key="group.id" :value="group.name" :active="index === activeIndex" @click="getGroupUserFetch(group.name, selectedDate), setActive(index), setGroup(group.name)">
        <v-list-item-title>{{ group.name }}</v-list-item-title>
      </v-list-item>
    </v-list>
  </v-navigation-drawer>
</template>

<script setup>
import { ref, onMounted } from 'vue';
const config = useRuntimeConfig()
const groups = ref([])

const activeIndex = ref(0);

function setActive(index) {
  activeIndex.value = index;
}

const groupName = useState("groupName", () => "");

function setGroup(name) {
  groupName.value = name
}

onMounted(async () => {
  await getGroupsFetch();
  if (groups.value.length > 0) {
    await getGroupUserFetch(groups.value[0].name, selectedDate.value);
    setGroup(groups.value[0].name)
  } else {
    console.warn('グループデータが空です');
  }
});

const accessToken = useCookie("access-token")
const client = useCookie("client")
const uid = useCookie("uid")

async function getGroupsFetch() {
  try {
    const response = await fetch(`${config.public.apiBase}/api/v1/groups`, {
      headers: {
        "access-token": accessToken.value,
        "client": client.value,
        "uid": uid.value
      }
    });
    if (!response.ok) throw new Error('ネットワークエラー');

    const data = await response.json();
    console.log(data.groups);
    groups.value = data.groups;
  } catch (error) {
    console.error('エラー:', error);
  }
}

const groupUserAttendancesData = useState("groupUserAttendancesData", () => "");

const { selectedDate } = useDatePicker()

async function getGroupUserFetch(name, day) {
  try {
    const params = new URLSearchParams({
      name: name,
      date: day
    })
    const response = await fetch(`${config.public.apiBase}/api/v1/dashboards?${params}`, {
      headers: {
        "access-token": accessToken.value,
        "client": client.value,
        "uid": uid.value
      }
    });
    if (!response.ok) throw new Error('ネットワークエラー');

    const data = await response.json();
    console.log(data.group_user_attendances);
    groupUserAttendancesData.value = data.group_user_attendances;
  } catch (error) {
    console.error('エラー:', error);
  }
}


</script>
