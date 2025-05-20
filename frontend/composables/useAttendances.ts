import type { AttendanceResponse } from '~/types/index';

export function useAttendances(): {
  attendances: Ref<AttendanceResponse | null>
} {
  const attendances = useState<AttendanceResponse | null>("attendance", () => null);
  return { attendances };
}
