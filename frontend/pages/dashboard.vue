<template>
  <v-app-bar color="primary" height="100">
      <v-app-bar-title>
        Application
      </v-app-bar-title>
      <v-btn @click="logout">ログアウト</v-btn>
    </v-app-bar>

    <v-navigation-drawer :width="300">
      <v-list-item title="Group"></v-list-item>
      <v-divider></v-divider>
      <v-list-item link title="List Item 1"></v-list-item>
      <v-list-item link title="List Item 2"></v-list-item>
      <v-list-item link title="List Item 3"></v-list-item>
    </v-navigation-drawer>

    <v-main>
    </v-main>

</template>

<script setup>
const config = useRuntimeConfig()

definePageMeta({
  middleware: [
    "auth",
  ],
});

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
</script>
