<template>
  <v-dialog
      v-model="dialog"
      width="auto"
    >
      <v-card
        max-width="400"
        prepend-icon="mdi-update"
        text="Your application will relaunch automatically after the update is complete."
        title="ユーザー編集"
      >
        <template v-slot:actions>
          <v-btn
            class="ms-auto"
            text="閉じる"
            @click="dialog = false"
          ></v-btn>
        </template>
      </v-card>
    </v-dialog>
</template>

<script setup>
import { ref } from 'vue'

const dialog = defineModel()
</script>
