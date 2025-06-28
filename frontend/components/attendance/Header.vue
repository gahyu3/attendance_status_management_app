<template>
  <v-row>

    <v-col>
      <DateField />
    </v-col>

    <v-col align-self="center">
      <AttendanceBtnCreate />
    </v-col>

    <v-col align-self="center">
      <v-row justify="end" class="pe-10">
        <AttendanceBtnReload />
      </v-row>
    </v-col>

  </v-row>
</template>
