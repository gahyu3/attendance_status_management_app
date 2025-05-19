export function useApiClient() {
  const getAuthHeaders = (): Record<string, string> => {
    const accessToken = useCookie<string | null>("access-token")
    const client = useCookie<string | null>("client")
    const uid = useCookie<string | null>("uid")

    return {
      "access-token": accessToken.value ?? "",
      "client": client.value ?? "",
      "uid": uid.value ?? ""
    }
  }
  return { getAuthHeaders }
}
