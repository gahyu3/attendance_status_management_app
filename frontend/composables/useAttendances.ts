import type { Attendance } from '~/types/index';


export const useAttendances = () => {
  return useState<Attendance | null>("attendance", () => null);
}
