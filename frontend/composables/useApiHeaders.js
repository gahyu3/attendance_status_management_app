export function useApiClient() {
  const getAuthHeaders = () => {
    const accessToken = useCookie("access-token")
    const client = useCookie("client")
    const uid = useCookie("uid")

    return {
      "access-token": accessToken.value,
      "client": client.value,
      "uid": uid.value
    }
  }
  return { getAuthHeaders }
}
