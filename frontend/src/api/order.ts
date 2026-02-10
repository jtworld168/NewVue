import request from './index'

export const getOrderList = (params: any) => request.get('/api/orders/list', { params })
export const getOrderById = (id: number) => request.get(`/api/orders/${id}`)
export const addOrder = (data: any) => request.post('/api/orders', data)
export const updateOrder = (data: any) => request.put('/api/orders', data)
export const deleteOrder = (id: number) => request.delete(`/api/orders/${id}`)
