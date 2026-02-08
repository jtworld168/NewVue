<template>
  <div class="settings-page">
    <h1 class="page-title">系统设置</h1>
    
    <el-row :gutter="20">
      <el-col :xs="24" :md="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>基本设置</span>
            </div>
          </template>
          
          <el-form
            :model="basicSettings"
            label-width="120px"
          >
            <el-form-item label="系统名称">
              <el-input v-model="basicSettings.systemName" />
            </el-form-item>
            
            <el-form-item label="系统描述">
              <el-input
                v-model="basicSettings.systemDescription"
                type="textarea"
                :rows="3"
              />
            </el-form-item>
            
            <el-form-item label="启用维护模式">
              <el-switch v-model="basicSettings.maintenanceMode" />
            </el-form-item>
            
            <el-form-item label="每页显示数">
              <el-input-number
                v-model="basicSettings.pageSize"
                :min="10"
                :max="100"
                :step="10"
              />
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="handleSaveBasic">
                保存设置
              </el-button>
              <el-button @click="handleResetBasic">重置</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
      
      <el-col :xs="24" :md="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>通知设置</span>
            </div>
          </template>
          
          <el-form
            :model="notificationSettings"
            label-width="120px"
          >
            <el-form-item label="邮件通知">
              <el-switch v-model="notificationSettings.emailEnabled" />
            </el-form-item>
            
            <el-form-item label="短信通知">
              <el-switch v-model="notificationSettings.smsEnabled" />
            </el-form-item>
            
            <el-form-item label="浏览器通知">
              <el-switch v-model="notificationSettings.browserEnabled" />
            </el-form-item>
            
            <el-form-item label="通知邮箱">
              <el-input
                v-model="notificationSettings.notificationEmail"
                placeholder="admin@example.com"
              />
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="handleSaveNotification">
                保存设置
              </el-button>
              <el-button @click="handleResetNotification">重置</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
    </el-row>
    
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :xs="24" :md="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>安全设置</span>
            </div>
          </template>
          
          <el-form
            :model="securitySettings"
            label-width="120px"
          >
            <el-form-item label="密码过期天数">
              <el-input-number
                v-model="securitySettings.passwordExpireDays"
                :min="30"
                :max="365"
              />
            </el-form-item>
            
            <el-form-item label="最大登录尝试">
              <el-input-number
                v-model="securitySettings.maxLoginAttempts"
                :min="3"
                :max="10"
              />
            </el-form-item>
            
            <el-form-item label="会话超时(分钟)">
              <el-input-number
                v-model="securitySettings.sessionTimeout"
                :min="15"
                :max="1440"
              />
            </el-form-item>
            
            <el-form-item label="启用双因素认证">
              <el-switch v-model="securitySettings.twoFactorEnabled" />
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="handleSaveSecurity">
                保存设置
              </el-button>
              <el-button @click="handleResetSecurity">重置</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
      
      <el-col :xs="24" :md="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>系统信息</span>
            </div>
          </template>
          
          <el-descriptions :column="1" border>
            <el-descriptions-item label="系统版本">
              {{ systemInfo.version }}
            </el-descriptions-item>
            <el-descriptions-item label="构建时间">
              {{ systemInfo.buildTime }}
            </el-descriptions-item>
            <el-descriptions-item label="技术栈">
              {{ systemInfo.techStack }}
            </el-descriptions-item>
            <el-descriptions-item label="运行环境">
              {{ systemInfo.environment }}
            </el-descriptions-item>
          </el-descriptions>
          
          <div style="margin-top: 20px">
            <el-button type="danger" plain @click="handleClearCache">
              清除缓存
            </el-button>
            <el-button type="warning" plain @click="handleExportSettings">
              导出设置
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'

const basicSettings = reactive({
  systemName: '后台管理系统',
  systemDescription: 'Vue 3 后台管理系统模板',
  maintenanceMode: false,
  pageSize: 20
})

const notificationSettings = reactive({
  emailEnabled: true,
  smsEnabled: false,
  browserEnabled: true,
  notificationEmail: 'admin@example.com'
})

const securitySettings = reactive({
  passwordExpireDays: 90,
  maxLoginAttempts: 5,
  sessionTimeout: 30,
  twoFactorEnabled: false
})

const systemInfo = reactive({
  version: '1.0.0',
  buildTime: '2024-02-08 15:00:00',
  techStack: 'Vue 3 + Vite + TypeScript + Element Plus',
  environment: 'Production'
})

const handleSaveBasic = () => {
  ElMessage.success('基本设置保存成功')
}

const handleResetBasic = () => {
  Object.assign(basicSettings, {
    systemName: '后台管理系统',
    systemDescription: 'Vue 3 后台管理系统模板',
    maintenanceMode: false,
    pageSize: 20
  })
  ElMessage.info('已重置为默认值')
}

const handleSaveNotification = () => {
  ElMessage.success('通知设置保存成功')
}

const handleResetNotification = () => {
  Object.assign(notificationSettings, {
    emailEnabled: true,
    smsEnabled: false,
    browserEnabled: true,
    notificationEmail: 'admin@example.com'
  })
  ElMessage.info('已重置为默认值')
}

const handleSaveSecurity = () => {
  ElMessage.success('安全设置保存成功')
}

const handleResetSecurity = () => {
  Object.assign(securitySettings, {
    passwordExpireDays: 90,
    maxLoginAttempts: 5,
    sessionTimeout: 30,
    twoFactorEnabled: false
  })
  ElMessage.info('已重置为默认值')
}

const handleClearCache = () => {
  ElMessage.success('缓存已清除')
}

const handleExportSettings = () => {
  const settings = {
    basic: basicSettings,
    notification: notificationSettings,
    security: securitySettings
  }
  const blob = new Blob([JSON.stringify(settings, null, 2)], {
    type: 'application/json'
  })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = 'system-settings.json'
  a.click()
  URL.revokeObjectURL(url)
  ElMessage.success('设置已导出')
}
</script>

<style scoped>
.settings-page {
  padding: 0;
}

.page-title {
  margin: 0 0 20px 0;
  font-size: 24px;
  font-weight: 600;
  color: #333;
}

.card-header {
  font-weight: 600;
}
</style>
