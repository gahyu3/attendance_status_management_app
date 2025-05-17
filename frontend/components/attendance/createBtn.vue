<template>
  <v-btn text="+" @click="createAttendance(formatDate,
                                          currentUser.id,
                                          selectedGroup.id)">
  </v-btn>
</template>


<script setup>
import { ref } from 'vue'

const config = useRuntimeConfig()
const { getAuthHeaders } = useApiClient()

const groupUserAttendancesData = useState("groupUserAttendancesData");
const currentUser = useState("currentUser");
const selectedGroup = useState("selectedGroup");
const { formatDate } = useDatePicker()

// 出席データを作成して追加
async function createAttendance(date, userid, groupId) {

  const attendanceParams = {
    attendance: {
      date: date,
      remarks: "",
      user_id: userid,
      group_id: groupId,
    }
  };

  try {
    const response = await $fetch(`${config.public.apiLocal}/api/v1/attendances`, {
      method: "POST",
      headers: getAuthHeaders(),
      body: attendanceParams
    })
    if (response.attendance) {
      console.log(response)
      groupUserAttendancesData.value.push(response.attendance)
    }
  } catch (error) {
    console.error('APIエラー:', error)
  }
};

</script>
