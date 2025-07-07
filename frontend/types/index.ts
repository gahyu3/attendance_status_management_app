// /api/v1/sign_in
export interface LoginResponse {
  data: User
}

export interface UserResponse {
    user: User
}

export interface User {
  id: number
  user_name: string
  email: string
  avatar_image?: {
    url: string
  }
}

export interface ProfileResponse {
  current_user: User
}

// /api/v1/sign_out
export interface LogoutResponse {
  success: boolean
}

// /api/v1/groups
export interface GroupResponse {
  groups: Group[]
}

export interface Group {
  id: number
  name: string
}

// /api/vi/attendances
export interface AttendancesResponse {
  attendances: Attendance[]
}

export interface AttendanceResponse {
  attendance: Attendance
}

export interface Attendance {
  id: number
  date: string
  schedule: Schedule
  attendances_status: Status
  remarks: string
  user_id: number
  group_id: number
  user: User
}

// リクエストtoken
export interface Token {
  'access-token': string | null,
  client: string | null,
  uid: string | null
}

// attendances_statusの型を限定
export type Status = "present" | "away" | "before" | "finished";

// Scheduleの型を限定
export type Schedule = "full_day_attendance" | "morning_attendance" | "afternoon_attendance";

// 月カレンダーイベント
export interface EventItem {
  title: string;
  start: Date;
  end: Date;
  allDay: boolean;
  color: string;
  extendedProps: {
    id: number
  }
};
