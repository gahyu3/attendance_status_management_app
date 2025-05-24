import type { AttendancesResponse } from '~/types/index';

export function useAttendances(): {
  attendances: Ref<AttendancesResponse | null>
} {
  const attendances = useState<AttendancesResponse | null>("attendances", () => null);
  return { attendances };
}
