  export default defineNuxtRouteMiddleware((to, from) => {
    const accessToken = useCookie('access-token')
    const client = useCookie('client')
    const uid = useCookie('uid')

    const isAuthenticated = !!accessToken.value && !!client.value && !!uid.value

    if (!isAuthenticated) {
      return navigateTo('/login') // ログインページにリダイレクト
    }
  })
