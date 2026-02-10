import request from './index'

export const getUserList = (params: any) => request.get('/api/users/list', { params })
export const getUserById = (id: number) => request.get(`/api/users/${id}`)
export const addUser = (data: any) => request.post('/api/users', data)
export const updateUser = (data: any) => request.put('/api/users', data)
export const deleteUser = (id: number) => request.delete(`/api/users/${id}`)
