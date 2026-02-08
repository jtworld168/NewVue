import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUserStore = defineStore('user', () => {
  const token = ref<string>(localStorage.getItem('token') || '')
  const username = ref<string>(localStorage.getItem('username') || '')
  const userInfo = ref<any>(null)

  const isLoggedIn = ref<boolean>(!!token.value)

  const login = (loginToken: string, user: string) => {
    token.value = loginToken
    username.value = user
    isLoggedIn.value = true
    localStorage.setItem('token', loginToken)
    localStorage.setItem('username', user)
  }

  const logout = () => {
    token.value = ''
    username.value = ''
    isLoggedIn.value = false
    userInfo.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('username')
  }

  const setUserInfo = (info: any) => {
    userInfo.value = info
  }

  return {
    token,
    username,
    userInfo,
    isLoggedIn,
    login,
    logout,
    setUserInfo
  }
})
