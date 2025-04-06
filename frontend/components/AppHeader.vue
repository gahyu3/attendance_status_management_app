<template>
    <v-app-bar color="primary" height="100">
      <v-app-bar-title>
        Application
      </v-app-bar-title>
    <template v-slot:append>
      <v-icon icon="mdi-account-circle" size="x-large" start />
      {{ currentUser.user_name }}
      <v-btn @click="logout">ログアウト</v-btn>
    </template>
  </v-app-bar>
</template>

<script setup>
import { ref, onMounted } from 'vue';
const config = useRuntimeConfig()

const accessToken = useCookie("access-token")
const client = useCookie("client")
const uid = useCookie("uid")

const logout = async () => {
  if (!accessToken.value || !client.value || !uid.value) {
    console.log("ログインしていません")
    return
  }

  const response = await fetch(`${config.public.apiBase}/api/v1/sign_out`, {
    method: "DELETE",
    headers: {
      "access-token": accessToken.value,
      "client": client.value,
      "uid": uid.value
    }
  })

  if (response.ok) {
    // クッキーを削除してログアウト
    accessToken.value = null
    client.value = null
    uid.value = null
    return navigateTo("/login")
  } else {
    console.error("ログアウト失敗", await response.json())
  }
}

const currentUser = ref({});

// マウント時にログインユーザーを獲得
onMounted(() => {
  currentUserFetch();
})

async function currentUserFetch() {
  try {
    const response = await fetch(`${config.public.apiBase}/api/v1/validate_token`, {
      headers: {
        "access-token": accessToken.value,
        "client": client.value,
        "uid": uid.value
      }
    });

    if (response.ok) {
      const res = await response.json();
      currentUser.value = res.data
    } else {
      const errorRes = await response.json();
      console.error("ユーザー獲得失敗", errorRes);
    }
  } catch (error) {
    console.error("エラー発生:", error);
  }
}

</script>

