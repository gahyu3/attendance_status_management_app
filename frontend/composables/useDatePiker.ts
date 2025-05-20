export function useDatePicker(): {
  selectedDate: Ref<Date>,
  formatDate: ComputedRef<string>,
} {
  const selectedDate = useState<Date>('selectedDate', () => new Date())

  const formatDate = computed((): string => {
    return selectedDate.value.toLocaleDateString('ja-JP', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit'
    }).replaceAll('/', '-')
  })

  return {
    selectedDate,
    formatDate,
  }
}
