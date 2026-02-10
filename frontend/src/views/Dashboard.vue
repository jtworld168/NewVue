<script setup lang="ts">
</script>

<template>
  <div>
    <h2 style="margin-bottom:20px">高校共享单车管理系统</h2>
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>用户管理</template>
          <p>管理系统内所有用户信息</p>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>站点管理</template>
          <p>管理单车停放站点</p>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>单车管理</template>
          <p>管理共享单车信息</p>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>订单管理</template>
          <p>管理用户骑行订单</p>
        </el-card>
      </el-col>
    </el-row>
    <el-row :gutter="20" style="margin-top:20px">
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>维修记录</template>
          <p>管理单车维修记录</p>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>钱包管理</template>
          <p>管理用户钱包信息</p>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>充值记录</template>
          <p>管理用户充值记录</p>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>费用规则</template>
          <p>管理计费规则</p>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>
