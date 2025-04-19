import { ref } from 'vue'
import { useCookie } from '#app'

export default function usePostFetch(url) {

  const accessToken = useCookie("access-token")
  const client = useCookie("client")
  const uid = useCookie("uid")

  const getData = ref(null)

  async function postFetch(date, user_id, group_id) {
    const attendanceParams = {
      attendance: {
        date: date,
        user_id: user_id,
        group_id: group_id,
        }
      }

    try {
      const response = await fetch(url, {
        method: "POST",
        headers: {
          "access-token": accessToken.value,
          "client": client.value,
          "uid": uid.value,
          "Content-Type": "application/json"
        },
        body: JSON.stringify(attendanceParams)
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
