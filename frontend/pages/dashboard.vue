<template>
  <p>ログイン成功</p>
  <v-btn @click="logout">ログアウト</v-btn>
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
