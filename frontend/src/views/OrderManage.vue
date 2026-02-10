<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { getOrderList, addOrder, updateOrder, deleteOrder, batchDeleteOrder } from '../api/order'
import { ElMessage, ElMessageBox } from 'element-plus'

const tableData = ref<any[]>([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogTitle = ref('新增订单')
const isEdit = ref(false)
const selectedIds = ref<number[]>([])

const searchForm = reactive({ userId: '', bikeId: '', status: '' as string | number })
const form = reactive({
  id: undefined as number | undefined,
  userId: undefined as number | undefined,
  bikeId: undefined as number | undefined,
  startStationId: undefined as number | undefined,
  endStationId: undefined as number | undefined,
  startTime: '',
  endTime: '',
  duration: undefined as number | undefined,
  amount: undefined as number | undefined,
  status: 0
})

const statusOptions = [
  { label: '进行中', value: 0 },
  { label: '已完成', value: 1 },
  { label: '已取消', value: 2 }
]

const loadData = async () => {
  try {
    const params: any = { page: currentPage.value, pageSize: pageSize.value }
    if (searchForm.userId) params.userId = searchForm.userId
    if (searchForm.bikeId) params.bikeId = searchForm.bikeId
    if (searchForm.status !== '') params.status = searchForm.status
    const res: any = await getOrderList(params)
    tableData.value = res.data?.records || []
    total.value = res.data?.total || 0
  } catch (e: any) { ElMessage.error(e.message || '加载失败') }
}

const handleSearch = () => { currentPage.value = 1; loadData() }
const resetSearch = () => { searchForm.userId = ''; searchForm.bikeId = ''; searchForm.status = ''; handleSearch() }

const resetForm = () => {
  form.id = undefined; form.userId = undefined; form.bikeId = undefined; form.startStationId = undefined
  form.endStationId = undefined; form.startTime = ''; form.endTime = ''; form.duration = undefined
  form.amount = undefined; form.status = 0
}

const handleAdd = () => { resetForm(); isEdit.value = false; dialogTitle.value = '新增订单'; dialogVisible.value = true }
const handleEdit = (row: any) => { isEdit.value = true; dialogTitle.value = '编辑订单'; dialogVisible.value = true; Object.assign(form, row) }

const handleSubmit = async () => {
  try {
    if (isEdit.value) { await updateOrder(form) } else { await addOrder(form) }
    ElMessage.success('操作成功'); dialogVisible.value = false; loadData()
  } catch (e: any) { ElMessage.error(e.message || '操作失败') }
}

const handleDelete = (id: number) => {
  ElMessageBox.confirm('确认删除该记录？', '提示', { type: 'warning' }).then(async () => {
    try { await deleteOrder(id); ElMessage.success('删除成功'); loadData() } catch (e: any) { ElMessage.error(e.message || '删除失败') }
  }).catch(() => {})
}

const handleSelectionChange = (rows: any[]) => {
  selectedIds.value = rows.map((r: any) => r.id)
}

const handleBatchDelete = () => {
  if (selectedIds.value.length === 0) { ElMessage.warning('请选择要删除的记录'); return }
  ElMessageBox.confirm(`确认删除选中的 ${selectedIds.value.length} 条记录？`, '提示', { type: 'warning' }).then(async () => {
    try { await batchDeleteOrder(selectedIds.value); ElMessage.success('批量删除成功'); loadData() }
    catch (e: any) { ElMessage.error(e.message || '批量删除失败') }
  }).catch(() => {})
}

onMounted(loadData)
</script>

<template>
  <div>
    <el-form :inline="true" :model="searchForm" style="margin-bottom:16px">
      <el-form-item label="用户ID"><el-input v-model="searchForm.userId" placeholder="用户ID" clearable /></el-form-item>
      <el-form-item label="单车ID"><el-input v-model="searchForm.bikeId" placeholder="单车ID" clearable /></el-form-item>
      <el-form-item label="状态">
        <el-select v-model="searchForm.status" placeholder="全部" clearable>
          <el-option v-for="o in statusOptions" :key="o.value" :label="o.label" :value="o.value" />
        </el-select>
      </el-form-item>
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
      <el-table-column prop="userId" label="用户ID" />
      <el-table-column prop="bikeId" label="单车ID" />
      <el-table-column prop="startStationId" label="借车站点" />
      <el-table-column prop="endStationId" label="还车站点" />
      <el-table-column prop="startTime" label="开始时间" width="170" />
      <el-table-column prop="endTime" label="结束时间" width="170" />
      <el-table-column prop="duration" label="时长(分钟)" />
      <el-table-column prop="amount" label="金额" />
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
        <el-form-item label="用户ID"><el-input-number v-model="form.userId" :controls="false" /></el-form-item>
        <el-form-item label="单车ID"><el-input-number v-model="form.bikeId" :controls="false" /></el-form-item>
        <el-form-item label="借车站点"><el-input-number v-model="form.startStationId" :controls="false" /></el-form-item>
        <el-form-item label="还车站点"><el-input-number v-model="form.endStationId" :controls="false" /></el-form-item>
        <el-form-item label="开始时间"><el-date-picker v-model="form.startTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" /></el-form-item>
        <el-form-item label="结束时间"><el-date-picker v-model="form.endTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" /></el-form-item>
        <el-form-item label="时长(分钟)"><el-input-number v-model="form.duration" :min="0" :controls="false" /></el-form-item>
        <el-form-item label="金额"><el-input-number v-model="form.amount" :min="0" :precision="2" :controls="false" /></el-form-item>
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
