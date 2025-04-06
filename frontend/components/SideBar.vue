<template>
  <v-navigation-drawer permanent>
    <v-list-item title="グループ"></v-list-item>
    <v-divider></v-divider>
    <v-list>
      <v-list-item link v-for="group in groups" :key="group.id">
        <v-list-item-title>{{ group.name }}</v-list-item-title>
      </v-list-item>
    </v-list>
  </v-navigation-drawer>
</template>

<script setup>
import { ref, onMounted } from 'vue';
const config = useRuntimeConfig()

const groups = ref([])

onMounted(() => {
  groupsFetch();
})

const accessToken = useCookie("access-token")
const client = useCookie("client")
const uid = useCookie("uid")

async function groupsFetch() {
  try {
    const response = await fetch(`${config.public.apiBase}/api/v1/dashboards`, {
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

</script>
