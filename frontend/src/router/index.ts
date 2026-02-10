import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  { path: '/login', name: 'Login', component: () => import('../views/Login.vue') },
  { path: '/register', name: 'Register', component: () => import('../views/Register.vue') },
  {
    path: '/',
    component: () => import('../views/Layout.vue'),
    redirect: '/dashboard',
    children: [
      { path: 'dashboard', name: 'Dashboard', component: () => import('../views/Dashboard.vue') },
      { path: 'users', name: 'Users', component: () => import('../views/UserManage.vue') },
      { path: 'stations', name: 'Stations', component: () => import('../views/StationManage.vue') },
      { path: 'bicycles', name: 'Bicycles', component: () => import('../views/BicycleManage.vue') },
      { path: 'orders', name: 'Orders', component: () => import('../views/OrderManage.vue') },
      { path: 'maintenance', name: 'Maintenance', component: () => import('../views/MaintenanceManage.vue') },
      { path: 'wallets', name: 'Wallets', component: () => import('../views/WalletManage.vue') },
      { path: 'recharge', name: 'Recharge', component: () => import('../views/RechargeManage.vue') },
      { path: 'pricing', name: 'Pricing', component: () => import('../views/PricingManage.vue') }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, _from, next) => {
  const userInfo = localStorage.getItem('userInfo')
  if (to.path !== '/login' && to.path !== '/register' && !userInfo) {
    next('/login')
  } else {
    next()
  }
})

export default router
