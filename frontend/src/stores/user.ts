import { defineStore } from 'pinia'
import { ref } from 'vue'
import { loginApi, registerApi } from '../api/auth'

export const useUserStore = defineStore('user', () => {
  const userInfo = ref<any>(JSON.parse(localStorage.getItem('userInfo') || 'null'))
  const token = ref<string>(localStorage.getItem('token') || '')

  const login = async (data: { username: string; password: string }) => {
    const res: any = await loginApi(data)
    userInfo.value = res.data || res
    localStorage.setItem('userInfo', JSON.stringify(userInfo.value))
    return res
  }

  const register = async (data: any) => {
    const res: any = await registerApi(data)
    return res
  }

  const logout = () => {
    userInfo.value = null
    token.value = ''
    localStorage.removeItem('userInfo')
    localStorage.removeItem('token')
  }

  return { userInfo, token, login, register, logout }
})
