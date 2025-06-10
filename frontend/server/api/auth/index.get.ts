export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig(event)
  const accessToken = getCookie(event, 'access-token')
  const client = getCookie(event, 'client')
  const uid = getCookie(event, 'uid')

  if (!accessToken || !client || !uid) {
    throw createError({ statusCode: 401, message: 'Unauthorized' })
  }

  try {
    const response = await $fetch(`${config.public.apiLocal}/api/v1/validate_token`, {
      method: 'GET',
      headers: {
        'access-token': accessToken,
        'client': client,
        'uid': uid,
      }
    });
    return response

  } catch (error) {
    console.error("サーバーエラー", error);
  }

})
