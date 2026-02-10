import request from './index'

export const getRechargeList = (params: any) => request.get('/api/recharge-records/list', { params })
export const getRechargeById = (id: number) => request.get(`/api/recharge-records/${id}`)
export const addRecharge = (data: any) => request.post('/api/recharge-records', data)
export const updateRecharge = (data: any) => request.put('/api/recharge-records', data)
export const deleteRecharge = (id: number) => request.delete(`/api/recharge-records/${id}`)
