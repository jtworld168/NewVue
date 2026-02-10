<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { getUserList, addUser, updateUser, deleteUser } from '../api/user'
import { ElMessage, ElMessageBox } from 'element-plus'

const tableData = ref<any[]>([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogTitle = ref('新增用户')
const isEdit = ref(false)

const searchForm = reactive({ username: '', realName: '', phone: '' })
const form = reactive({
  id: undefined as number | undefined,
  username: '',
  password: '',
  realName: '',
  identityNumber: '',
  phone: '',
  email: '',
  userType: 0,
  status: 0
})

const userTypeOptions = [
  { label: '学生', value: 0 },
  { label: '教职工', value: 1 },
  { label: '管理员', value: 2 },
  { label: '维修员', value: 3 }
]
const statusOptions = [
  { label: '正常', value: 0 },
  { label: '冻结', value: 1 }
]

const loadData = async () => {
  try {
    const res: any = await getUserList({ page: currentPage.value, pageSize: pageSize.value, ...searchForm })
    tableData.value = res.data?.records || []
    total.value = res.data?.total || 0
  } catch (e: any) {
    ElMessage.error(e.message || '加载失败')
  }
}

const handleSearch = () => { currentPage.value = 1; loadData() }
const resetSearch = () => {
  searchForm.username = ''; searchForm.realName = ''; searchForm.phone = ''
  handleSearch()
}

const resetForm = () => {
  form.id = undefined; form.username = ''; form.password = ''; form.realName = ''
  form.identityNumber = ''; form.phone = ''; form.email = ''; form.userType = 0; form.status = 0
}

const handleAdd = () => { resetForm(); isEdit.value = false; dialogTitle.value = '新增用户'; dialogVisible.value = true }
const handleEdit = (row: any) => {
  isEdit.value = true; dialogTitle.value = '编辑用户'; dialogVisible.value = true
  Object.assign(form, row)
}

const handleSubmit = async () => {
  try {
    if (isEdit.value) { await updateUser(form) } else { await addUser(form) }
    ElMessage.success('操作成功'); dialogVisible.value = false; loadData()
  } catch (e: any) { ElMessage.error(e.message || '操作失败') }
}

const handleDelete = (id: number) => {
  ElMessageBox.confirm('确认删除该记录？', '提示', { type: 'warning' }).then(async () => {
    try { await deleteUser(id); ElMessage.success('删除成功'); loadData() }
    catch (e: any) { ElMessage.error(e.message || '删除失败') }
  }).catch(() => {})
}

onMounted(loadData)
</script>

<template>
  <div>
    <el-form :inline="true" :model="searchForm" style="margin-bottom:16px">
      <el-form-item label="用户名"><el-input v-model="searchForm.username" placeholder="用户名" clearable /></el-form-item>
      <el-form-item label="真实姓名"><el-input v-model="searchForm.realName" placeholder="真实姓名" clearable /></el-form-item>
      <el-form-item label="手机号"><el-input v-model="searchForm.phone" placeholder="手机号" clearable /></el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSearch">搜索</el-button>
        <el-button @click="resetSearch">重置</el-button>
      </el-form-item>
    </el-form>
    <el-button type="primary" style="margin-bottom:16px" @click="handleAdd">新增</el-button>
    <el-table :data="tableData" border stripe>
      <el-table-column prop="id" label="ID" width="60" />
      <el-table-column prop="username" label="用户名" />
      <el-table-column prop="realName" label="真实姓名" />
      <el-table-column prop="identityNumber" label="学号/工号" />
      <el-table-column prop="phone" label="手机号" />
      <el-table-column prop="email" label="邮箱" />
      <el-table-column prop="userType" label="用户类型">
        <template #default="scope">{{ userTypeOptions.find(o => o.value === scope.row.userType)?.label }}</template>
      </el-table-column>
      <el-table-column prop="status" label="状态">
        <template #default="scope">{{ statusOptions.find(o => o.value === scope.row.status)?.label }}</template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="170" />
      <el-table-column label="操作" width="200">
        <template #default="scope">
          <el-button size="small" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination style="margin-top:16px" v-model:current-page="currentPage" v-model:page-size="pageSize" :total="total" :page-sizes="[10,20,50]" layout="total, sizes, prev, pager, next" @size-change="loadData" @current-change="loadData" />

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="用户名"><el-input v-model="form.username" /></el-form-item>
        <el-form-item v-if="!isEdit" label="密码"><el-input v-model="form.password" type="password" show-password /></el-form-item>
        <el-form-item label="真实姓名"><el-input v-model="form.realName" /></el-form-item>
        <el-form-item label="学号/工号"><el-input v-model="form.identityNumber" /></el-form-item>
        <el-form-item label="手机号"><el-input v-model="form.phone" /></el-form-item>
        <el-form-item label="邮箱"><el-input v-model="form.email" /></el-form-item>
        <el-form-item label="用户类型">
          <el-select v-model="form.userType"><el-option v-for="o in userTypeOptions" :key="o.value" :label="o.label" :value="o.value" /></el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="form.status"><el-option v-for="o in statusOptions" :key="o.value" :label="o.label" :value="o.value" /></el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>
