import request from './index'

export const getMaintenanceList = (params: any) => request.get('/api/maintenance-records/list', { params })
export const getMaintenanceById = (id: number) => request.get(`/api/maintenance-records/${id}`)
export const addMaintenance = (data: any) => request.post('/api/maintenance-records', data)
export const updateMaintenance = (data: any) => request.put('/api/maintenance-records', data)
export const deleteMaintenance = (id: number) => request.delete(`/api/maintenance-records/${id}`)
