<template>
  <v-navigation-drawer permanent>
    <v-list-item title="Group"></v-list-item>
    <v-divider></v-divider>
    <li v-for="item in groups">
      {{ item.name }}
    </li>
  {{ groups }}
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
