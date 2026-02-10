import request from './index'

export const getWalletList = (params: any) => request.get('/api/wallets/list', { params })
export const getWalletById = (id: number) => request.get(`/api/wallets/${id}`)
export const addWallet = (data: any) => request.post('/api/wallets', data)
export const updateWallet = (data: any) => request.put('/api/wallets', data)
export const deleteWallet = (id: number) => request.delete(`/api/wallets/${id}`)
