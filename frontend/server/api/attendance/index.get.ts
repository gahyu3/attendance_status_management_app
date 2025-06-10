export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig(event)
  const accessToken = getCookie(event, 'access-token')
  const client = getCookie(event, 'client')
  const uid = getCookie(event, 'uid')

  const query = getQuery(event)
  const date = query.date
  const groupId = query.group_id

  if (!accessToken || !client || !uid) {
    throw createError({ statusCode: 401, message: 'Unauthorized' })
  }

  if ( !date || !groupId) {
    throw createError({ statusCode: 401, message: 'dataかgroupIdがありません' })
  }

  const response = await $fetch(`${config.public.apiLocal}/api/v1/attendances`, {
    method: 'GET',
    headers: {
      'access-token': accessToken,
      'client': client,
      'uid': uid,
    },
    query: {
      date: date,
      group_id : groupId
    }
  })

  return response
})
