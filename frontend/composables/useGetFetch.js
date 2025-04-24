import { ref } from 'vue'
import { useCookie } from '#app'

export default function useGetFetch(url) {

  const accessToken = useCookie("access-token")
  const client = useCookie("client")
  const uid = useCookie("uid")

  const getData = ref(null)

  async function getFetch({ query = {} } = {}) {
    const queryString = new URLSearchParams(query).toString()
    const fullUrl = queryString ? `${url}?${queryString}` : `${url}`
  
    try {
      const response = await fetch(fullUrl, {
        headers: {
          "access-token": accessToken.value,
          "client": client.value,
          "uid": uid.value
        }
      });

      if (!response.ok) throw new Error('ネットワークエラー');

      const resData = await response.json();
      getData.value = resData
      console.log(resData);
    } catch (error) {
      console.error('エラー:', error);
    }
  }


  return {
    getData,
    getFetch,
  }
}
