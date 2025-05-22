// /api/v1/sign_in
export interface LoginResponse {
  data: User
}

export interface User {
  id: number
  user_name: string
  email: string
  avatar_image?: {
    url: string
  }
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
  schedule: string
  attendances_status: Status
  remarks: string
  user_id: number
  group_id: number
  user: User
}

export interface StatusMap {
  present: string;
  away: string;
  before: string;
  finished: string;
}

export interface StatusColorMap {
  present: string,
  away: string,
  before: string,
  finished: string
}

export type Status = "present" | "away" | "before" | "finished";




