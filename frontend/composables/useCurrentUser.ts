// composables/useCurrentUser.ts
import type { User } from '~/types/index'

export const useCurrentUser = () => {
  return useState<User | null>('currentUser', () => null)
}
