import type { Group } from '~/types/index';


export const useSelectedGroup = () => {
  return useState<Group | null>("selectedGroup", () => null);
}
