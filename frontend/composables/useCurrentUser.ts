import type { User } from '~/types/index'

export function useCurrentUser(): {
  currentUser: Ref<User | null>
} {
  const currentUser = useState<User | null>("currentUser", () => null);
  return { currentUser };
}
