<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import * as echarts from 'echarts'
import { getBikeCountByStation } from '../api/bicycle'
import { getStationList } from '../api/station'
import { ElMessage } from 'element-plus'

const chartRef = ref<HTMLElement>()
let chartInstance: echarts.ECharts | null = null

const loadChartData = async () => {
  try {
    const [countRes, stationRes]: any[] = await Promise.all([
      getBikeCountByStation(),
      getStationList({ page: 1, pageSize: 100 })
    ])
    const countMap = countRes.data || {}
    const stations = stationRes.data?.records || []

    const names: string[] = []
    const values: number[] = []
    for (const station of stations) {
      names.push(station.name)
      values.push(countMap[station.id] || 0)
    }

    if (chartRef.value) {
      chartInstance = echarts.init(chartRef.value)
      chartInstance.setOption({
        title: { text: '各站点共享单车数量对比', left: 'center' },
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        xAxis: { type: 'category', data: names, axisLabel: { rotate: 30, fontSize: 12 } },
        yAxis: { type: 'value', name: '单车数量', minInterval: 1 },
        series: [{
          name: '单车数量',
          type: 'bar',
          data: values,
          itemStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: '#409eff' },
              { offset: 1, color: '#36cfc9' }
            ])
          },
          barWidth: '40%',
          label: { show: true, position: 'top' }
        }],
        grid: { left: '3%', right: '4%', bottom: '10%', containLabel: true }
      })
    }
  } catch (e: any) {
    ElMessage.error(e.message || '加载图表数据失败')
  }
}

const handleResize = () => {
  chartInstance?.resize()
}

onMounted(() => {
  loadChartData()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  chartInstance?.dispose()
})
</script>

<template>
  <div>
    <h2 style="margin-bottom:20px">高校共享单车管理系统</h2>
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card shadow="hover"><template #header>用户管理</template><p>管理系统内所有用户信息</p></el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover"><template #header>站点管理</template><p>管理单车停放站点</p></el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover"><template #header>单车管理</template><p>管理共享单车信息</p></el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover"><template #header>订单管理</template><p>管理用户骑行订单</p></el-card>
      </el-col>
    </el-row>
    <el-row :gutter="20" style="margin-top:20px">
      <el-col :span="6">
        <el-card shadow="hover"><template #header>维修记录</template><p>管理单车维修记录</p></el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover"><template #header>钱包管理</template><p>管理用户钱包信息</p></el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover"><template #header>充值记录</template><p>管理用户充值记录</p></el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover"><template #header>费用规则</template><p>管理计费规则</p></el-card>
      </el-col>
    </el-row>
    <el-card style="margin-top:20px">
      <div ref="chartRef" style="width:100%;height:400px"></div>
    </el-card>
  </div>
</template>
