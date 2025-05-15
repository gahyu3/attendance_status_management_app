<template>
  <v-navigation-drawer permanent>
    <v-list-item title="グループ"></v-list-item>
    <v-divider></v-divider>
    <v-list>
      <v-list-item v-for="(group, index) in groups.groups"
      :key="group.id"
      :value="group.name"
      :active="index === activeIndex"
      @click="onClickGroupUsers(group.name, formatDate),
                  setActive(index),
                  setGroup(group)">
        <v-list-item-title>{{ group.name }}</v-list-item-title>
      </v-list-item>
    </v-list>
  </v-navigation-drawer>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const config = useRuntimeConfig()

// 日付関連の state を取得（選択中の日付とそのフォーマット）
const { selectedDate, formatDate } = useDatePicker()


// 現在選択されているグループ情報
const selectedGroup = useState("selectedGroup", () => "");


// 現在アクティブなグループのインデックス
const activeIndex = ref(0);

// 出席データの格納用（useState を利用してグローバルに保持）
const groupUserAttendancesData = useState("groupUserAttendancesData", () => []);

// グループ別ユーザー出席データ取得用
const { getData: groupUsersData,
        getFetch: groupUsersFetch
      } = useGetFetch(`${config.public.apiBase}/api/v1/attendances`)

// グループ一覧データ取得用
const { getData: groupsData,
        getFetch: groupsFetch
      } = useGetFetch(`${config.public.apiBase}/api/v1/groups`)

// アクティブなインデックスをセット
function setActive(index) {
  activeIndex.value = index;
}

// 現在選択中のグループ名をセット
function setGroup(group) {
  selectedGroup.value = group
}

// 初回マウント時にグループと出席データを取得
// onMounted(async () => {
//   await groupsFetch();
//   if (groupsData.value) {
//     groups.value = groupsData.value.groups
//   }
//   if (groups.value.length > 0) {
//     await groupUsersFetch({
//       query: {
//         name: groups.value[0].name,
//         date: formatDate.value
//       }
//     });
//     if (groupUsersData.value?.attendances) {
//       groupUserAttendancesData.value = groupUsersData.value.attendances;
//     } else {
//       console.warn('group_user_attendances の取得に失敗しました');
//     }

//     setGroup(groups.value[0])
//   } else {
//     console.warn('グループデータが空です');
//   }
// });

// グループ名と日付を指定して出席データを取得（クリックイベント用）
async function onClickGroupUsers(name, day) {
  await groupUsersFetch({
    query: {
      name: name,
      date: day
    }
  })

  if (groupUsersData.value.attendances) {
    groupUserAttendancesData.value = groupUsersData.value.attendances
  } else {
    console.warn('出席データが見つかりません');
  }
}

const { data: groups, pending, error } = await useFetch('/api/group')

</script>
