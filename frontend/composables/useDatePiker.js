export function useDatePicker() {
  const now = new Date()

  const selectedDate = useState('selectedDate', () => now)

  return {
    selectedDate,
  }
}
