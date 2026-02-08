import request from '@/utils/request'

export interface LoginData {
  username: string
  password: string
}

export interface UserInfo {
  id: number
  username: string
  email: string
  role: string
}

// User API
export const login = (data: LoginData) => {
  return request({
    url: '/auth/login',
    method: 'post',
    data
  })
}

export const getUserInfo = () => {
  return request({
    url: '/user/info',
    method: 'get'
  })
}

export const logout = () => {
  return request({
    url: '/auth/logout',
    method: 'post'
  })
}

// Users management API
export const getUserList = (params?: any) => {
  return request({
    url: '/users',
    method: 'get',
    params
  })
}

export const createUser = (data: any) => {
  return request({
    url: '/users',
    method: 'post',
    data
  })
}

export const updateUser = (id: number, data: any) => {
  return request({
    url: `/users/${id}`,
    method: 'put',
    data
  })
}

export const deleteUser = (id: number) => {
  return request({
    url: `/users/${id}`,
    method: 'delete'
  })
}
