<template>
  <div class="dashboard">
    <h1 class="page-title">仪表盘</h1>
    
    <!-- Statistics Cards -->
    <el-row :gutter="20" class="stats-row">
      <el-col :xs="24" :sm="12" :md="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background-color: #409eff;">
              <el-icon :size="30"><User /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.totalUsers }}</div>
              <div class="stat-label">总用户数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :xs="24" :sm="12" :md="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background-color: #67c23a;">
              <el-icon :size="30"><Document /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.totalOrders }}</div>
              <div class="stat-label">总订单数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :xs="24" :sm="12" :md="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background-color: #e6a23c;">
              <el-icon :size="30"><Money /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">¥{{ stats.totalRevenue }}</div>
              <div class="stat-label">总收入</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :xs="24" :sm="12" :md="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background-color: #f56c6c;">
              <el-icon :size="30"><ChatDotSquare /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.newMessages }}</div>
              <div class="stat-label">新消息</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- Charts Section -->
    <el-row :gutter="20" class="charts-row">
      <el-col :xs="24" :md="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>最近访问趋势</span>
            </div>
          </template>
          <div class="chart-placeholder">
            <el-icon :size="60" color="#ccc"><TrendCharts /></el-icon>
            <p>图表区域（可集成 ECharts 或其他图表库）</p>
          </div>
        </el-card>
      </el-col>
      
      <el-col :xs="24" :md="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>用户增长统计</span>
            </div>
          </template>
          <div class="chart-placeholder">
            <el-icon :size="60" color="#ccc"><Histogram /></el-icon>
            <p>图表区域（可集成 ECharts 或其他图表库）</p>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- Recent Activities -->
    <el-row :gutter="20">
      <el-col :span="24">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>最近活动</span>
            </div>
          </template>
          <el-timeline>
            <el-timeline-item
              v-for="activity in recentActivities"
              :key="activity.id"
              :timestamp="activity.timestamp"
              placement="top"
            >
              {{ activity.content }}
            </el-timeline-item>
          </el-timeline>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import {
  User,
  Document,
  Money,
  ChatDotSquare,
  TrendCharts,
  Histogram
} from '@element-plus/icons-vue'

const stats = ref({
  totalUsers: 1248,
  totalOrders: 856,
  totalRevenue: 125680,
  newMessages: 23
})

const recentActivities = ref([
  {
    id: 1,
    content: '用户 张三 注册了新账号',
    timestamp: '2024-02-08 14:30'
  },
  {
    id: 2,
    content: '订单 #12345 已完成支付',
    timestamp: '2024-02-08 13:20'
  },
  {
    id: 3,
    content: '管理员更新了系统配置',
    timestamp: '2024-02-08 12:15'
  },
  {
    id: 4,
    content: '用户 李四 提交了新的反馈',
    timestamp: '2024-02-08 11:00'
  }
])

onMounted(() => {
  // Load dashboard data
  console.log('Dashboard mounted')
})
</script>

<style scoped>
.dashboard {
  padding: 0;
}

.page-title {
  margin: 0 0 20px 0;
  font-size: 24px;
  font-weight: 600;
  color: #333;
}

.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  margin-bottom: 20px;
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 20px;
}

.stat-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 60px;
  height: 60px;
  border-radius: 10px;
  color: #fff;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 28px;
  font-weight: bold;
  color: #333;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  color: #999;
}

.charts-row {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
}

.chart-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 300px;
  color: #999;
}

.chart-placeholder p {
  margin-top: 10px;
  font-size: 14px;
}
</style>
