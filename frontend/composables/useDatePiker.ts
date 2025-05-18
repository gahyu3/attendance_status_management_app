export function useDatePicker() {
  const selectedDate = useState('selectedDate', () => new Date())

  const formatDate = computed(() => {
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
