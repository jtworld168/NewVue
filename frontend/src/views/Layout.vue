<script setup lang="ts">
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()

const handleLogout = () => {
  userStore.logout()
  ElMessage.success('已退出登录')
  router.push('/login')
}

const menuItems = [
  { index: '/dashboard', title: '首页', icon: 'HomeFilled' },
  { index: '/users', title: '用户管理', icon: 'User' },
  { index: '/stations', title: '站点管理', icon: 'OfficeBuilding' },
  { index: '/bicycles', title: '单车管理', icon: 'Bicycle' },
  { index: '/orders', title: '订单管理', icon: 'List' },
  { index: '/maintenance', title: '维修记录', icon: 'SetUp' },
  { index: '/wallets', title: '钱包管理', icon: 'Wallet' },
  { index: '/recharge', title: '充值记录', icon: 'Money' },
  { index: '/pricing', title: '费用规则', icon: 'PriceTag' }
]
</script>

<template>
  <el-container style="height:100%">
    <el-aside width="220px" style="background:#304156">
      <div style="color:#fff;text-align:center;padding:20px 0;font-size:16px;font-weight:bold">
        共享单车管理系统
      </div>
      <el-menu :default-active="$route.path" router background-color="#304156" text-color="#bfcbd9" active-text-color="#409eff">
        <el-menu-item v-for="item in menuItems" :key="item.index" :index="item.index">
          <el-icon><component :is="item.icon" /></el-icon>
          <span>{{ item.title }}</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header style="display:flex;justify-content:flex-end;align-items:center;background:#fff;box-shadow:0 1px 4px rgba(0,0,0,.08)">
        <span style="margin-right:16px">{{ userStore.userInfo?.username || '管理员' }}</span>
        <el-button type="danger" size="small" @click="handleLogout">退出登录</el-button>
      </el-header>
      <el-main style="background:#f0f2f5;padding:20px">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>
