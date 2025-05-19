import type { AttendanceResponse } from '~/types/index';

export const useAttendances = () => {
  return useState<AttendanceResponse | null>("attendance", () => null);
}
