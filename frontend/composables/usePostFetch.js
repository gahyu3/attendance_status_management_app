import { ref } from 'vue'
import { useCookie } from '#app'

export default function usePostFetch(url) {

  const accessToken = useCookie("access-token")
  const client = useCookie("client")
  const uid = useCookie("uid")

  const getData = ref(null)

  async function postFetch(request, queryParameterID = null, options = {} ) {
    const fullUrl = queryParameterID ? `${url}/${queryParameterID}` : `${url}`
    const { query = {} } = options

    try {
      const response = await fetch(fullUrl, {
        method: request,
        headers: {
          "access-token": accessToken.value,
          "client": client.value,
          "uid": uid.value,
          "Content-Type": "application/json"
        },
        body: query ? JSON.stringify(query) : ""
      });

      if (!response.ok) throw new Error('ネットワークエラー');

      const resData = await response.json();
      getData.value = resData
      console.log(resData, "出席状況作成");
    } catch (error) {
      console.error('エラー:', error);
    }
  }


  return {
    getData,
    postFetch,
  }
}
