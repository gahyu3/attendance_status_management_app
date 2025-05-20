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
export interface AttendanceResponse {
  attendances: Attendance[]
}

export interface Attendance {
  id: number
  date: string
  schedule: string
  attendances_status: string
  remarks: string
  user_id: number
  group_id: number
  user: User
}





