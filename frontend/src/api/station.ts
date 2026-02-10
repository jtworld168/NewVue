import request from './index'

export const getStationList = (params: any) => request.get('/api/stations/list', { params })
export const getStationById = (id: number) => request.get(`/api/stations/${id}`)
export const addStation = (data: any) => request.post('/api/stations', data)
export const updateStation = (data: any) => request.put('/api/stations', data)
export const deleteStation = (id: number) => request.delete(`/api/stations/${id}`)
