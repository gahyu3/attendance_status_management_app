import type { Group } from '~/types/index';

export function useSelectedGroup(): {
  selectedGroup: Ref<Group | null>
} {
  const selectedGroup = useState<Group | null>("selectedGroup", () => null);
  return { selectedGroup };
}
