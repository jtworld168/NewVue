import request from './index'

export const loginApi = (data: { username: string; password: string }) =>
  request.post('/api/auth/login', data)

export const registerApi = (data: any) =>
  request.post('/api/auth/register', data)
