<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { getStationList, addStation, updateStation, deleteStation, batchDeleteStation } from '../api/station'
import { ElMessage, ElMessageBox } from 'element-plus'

const tableData = ref<any[]>([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogTitle = ref('新增站点')
const isEdit = ref(false)
const selectedIds = ref<number[]>([])

const searchForm = reactive({ name: '', address: '' })
const form = reactive({
  id: undefined as number | undefined,
  name: '',
  address: '',
  latitude: undefined as number | undefined,
  longitude: undefined as number | undefined,
  capacity: undefined as number | undefined,
  status: 0
})

const statusOptions = [
  { label: '启用', value: 0 },
  { label: '维修中', value: 1 },
  { label: '停用', value: 2 }
]

const loadData = async () => {
  try {
    const res: any = await getStationList({ page: currentPage.value, pageSize: pageSize.value, ...searchForm })
    tableData.value = res.data?.records || []
    total.value = res.data?.total || 0
  } catch (e: any) { ElMessage.error(e.message || '加载失败') }
}

const handleSearch = () => { currentPage.value = 1; loadData() }
const resetSearch = () => { searchForm.name = ''; searchForm.address = ''; handleSearch() }

const resetForm = () => {
  form.id = undefined; form.name = ''; form.address = ''; form.latitude = undefined
  form.longitude = undefined; form.capacity = undefined; form.status = 0
}

const handleAdd = () => { resetForm(); isEdit.value = false; dialogTitle.value = '新增站点'; dialogVisible.value = true }
const handleEdit = (row: any) => { isEdit.value = true; dialogTitle.value = '编辑站点'; dialogVisible.value = true; Object.assign(form, row) }

const handleSubmit = async () => {
  try {
    if (isEdit.value) { await updateStation(form) } else { await addStation(form) }
    ElMessage.success('操作成功'); dialogVisible.value = false; loadData()
  } catch (e: any) { ElMessage.error(e.message || '操作失败') }
}

const handleDelete = (id: number) => {
  ElMessageBox.confirm('确认删除该记录？', '提示', { type: 'warning' }).then(async () => {
    try { await deleteStation(id); ElMessage.success('删除成功'); loadData() } catch (e: any) { ElMessage.error(e.message || '删除失败') }
  }).catch(() => {})
}

const handleSelectionChange = (rows: any[]) => {
  selectedIds.value = rows.map((r: any) => r.id)
}

const handleBatchDelete = () => {
  if (selectedIds.value.length === 0) { ElMessage.warning('请选择要删除的记录'); return }
  ElMessageBox.confirm(`确认删除选中的 ${selectedIds.value.length} 条记录？`, '提示', { type: 'warning' }).then(async () => {
    try { await batchDeleteStation(selectedIds.value); ElMessage.success('批量删除成功'); loadData() }
    catch (e: any) { ElMessage.error(e.message || '批量删除失败') }
  }).catch(() => {})
}

onMounted(loadData)
</script>

<template>
  <div>
    <el-form :inline="true" :model="searchForm" style="margin-bottom:16px">
      <el-form-item label="站点名称"><el-input v-model="searchForm.name" placeholder="站点名称" clearable /></el-form-item>
      <el-form-item label="地址"><el-input v-model="searchForm.address" placeholder="地址" clearable /></el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSearch">搜索</el-button>
        <el-button @click="resetSearch">重置</el-button>
      </el-form-item>
    </el-form>
    <div style="margin-bottom:16px">
      <el-button type="primary" @click="handleAdd">新增</el-button>
      <el-button type="danger" @click="handleBatchDelete">批量删除</el-button>
    </div>
    <el-table :data="tableData" border stripe @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" />
      <el-table-column prop="id" label="ID" width="60" />
      <el-table-column prop="name" label="站点名称" />
      <el-table-column prop="address" label="地址" />
      <el-table-column prop="latitude" label="纬度" />
      <el-table-column prop="longitude" label="经度" />
      <el-table-column prop="capacity" label="容量" />
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
        <el-form-item label="站点名称"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="地址"><el-input v-model="form.address" /></el-form-item>
        <el-form-item label="纬度"><el-input-number v-model="form.latitude" :precision="6" :controls="false" /></el-form-item>
        <el-form-item label="经度"><el-input-number v-model="form.longitude" :precision="6" :controls="false" /></el-form-item>
        <el-form-item label="容量"><el-input-number v-model="form.capacity" :min="0" /></el-form-item>
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
