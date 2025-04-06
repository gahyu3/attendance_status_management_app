<template>
  <v-navigation-drawer permanent>
    <v-list-item title="グループ"></v-list-item>
    <v-divider></v-divider>
    <v-list>
      <v-list-item link v-for="group in groups" :key="group.id" @click="getGroupUserFetch(group.name, day)">
        <v-list-item-title>{{ group.name }}</v-list-item-title>
      </v-list-item>
    </v-list>
    {{ day }}
  </v-navigation-drawer>
</template>

<script setup>
import { ref, onMounted } from 'vue';
const config = useRuntimeConfig()

const groups = ref([])

onMounted(() => {
  getGroupsFetch();
})

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

const groupName = ref("")
const today = new Date()
const formatToday = today.toISOString().split('T')[0]
const day = ref(formatToday)

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
    console.log(data);
    groupName.value = data;
  } catch (error) {
    console.error('エラー:', error);
  }
}

</script>
