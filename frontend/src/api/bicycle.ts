import request from './index'

export const getBicycleList = (params: any) => request.get('/api/bicycles/list', { params })
export const getBicycleById = (id: number) => request.get(`/api/bicycles/${id}`)
export const addBicycle = (data: any) => request.post('/api/bicycles', data)
export const updateBicycle = (data: any) => request.put('/api/bicycles', data)
export const deleteBicycle = (id: number) => request.delete(`/api/bicycles/${id}`)
export const batchDeleteBicycle = (ids: number[]) => request.delete('/api/bicycles/batch', { data: ids })
export const getBikeCountByStation = () => request.get('/api/bicycles/count-by-station')
