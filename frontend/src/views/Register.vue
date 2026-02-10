<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()

const form = reactive({
  username: '',
  password: '',
  realName: '',
  identityNumber: '',
  phone: '',
  email: ''
})
const loading = ref(false)

const handleRegister = async () => {
  if (!form.username || !form.password) {
    ElMessage.warning('请输入用户名和密码')
    return
  }
  loading.value = true
  try {
    await userStore.register(form)
    ElMessage.success('注册成功，请登录')
    router.push('/login')
  } catch (e: any) {
    ElMessage.error(e.message || '注册失败')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div style="display:flex;justify-content:center;align-items:center;height:100%;background:#f0f2f5">
    <el-card style="width:450px">
      <template #header>
        <h2 style="text-align:center">用户注册</h2>
      </template>
      <el-form :model="form" label-width="80px" @keyup.enter="handleRegister">
        <el-form-item label="用户名">
          <el-input v-model="form.username" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" show-password />
        </el-form-item>
        <el-form-item label="真实姓名">
          <el-input v-model="form.realName" placeholder="请输入真实姓名" />
        </el-form-item>
        <el-form-item label="学号/工号">
          <el-input v-model="form.identityNumber" placeholder="请输入学号/工号" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="form.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="loading" style="width:100%" @click="handleRegister">注册</el-button>
        </el-form-item>
        <el-form-item>
          <router-link to="/login">已有账号？去登录</router-link>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>
