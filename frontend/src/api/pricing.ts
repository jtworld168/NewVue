import request from './index'

export const getPricingList = (params: any) => request.get('/api/pricing-rules/list', { params })
export const getPricingById = (id: number) => request.get(`/api/pricing-rules/${id}`)
export const addPricing = (data: any) => request.post('/api/pricing-rules', data)
export const updatePricing = (data: any) => request.put('/api/pricing-rules', data)
export const deletePricing = (id: number) => request.delete(`/api/pricing-rules/${id}`)
