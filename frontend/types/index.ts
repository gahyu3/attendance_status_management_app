export interface UserResponse {
  data: User
}

export interface User {
  id: number
  user_name: string
  email: string
}

export interface LogoutResponse {
  success: boolean
}






