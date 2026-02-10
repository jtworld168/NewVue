<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { getBicycleList, addBicycle, updateBicycle, deleteBicycle, batchDeleteBicycle } from '../api/bicycle'
import { ElMessage, ElMessageBox } from 'element-plus'

const tableData = ref<any[]>([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogTitle = ref('新增单车')
const isEdit = ref(false)
const selectedIds = ref<number[]>([])

const searchForm = reactive({ bikeNo: '', type: '' as string | number, status: '' as string | number })
const form = reactive({
  id: undefined as number | undefined,
  bikeNo: '',
  imageUrl: '',
  type: 0,
  status: 0,
  currentStationId: undefined as number | undefined,
  batteryLevel: undefined as number | undefined,
  purchaseDate: '',
  lastMaintenanceTime: ''
})

const typeOptions = [
  { label: '普通单车', value: 0 },
  { label: '电动单车', value: 1 }
]
const statusOptions = [
  { label: '可用', value: 0 },
  { label: '使用中', value: 1 },
  { label: '维修中', value: 2 },
  { label: '报废', value: 3 }
]

const loadData = async () => {
  try {
    const params: any = { page: currentPage.value, pageSize: pageSize.value, bikeNo: searchForm.bikeNo }
    if (searchForm.type !== '') params.type = searchForm.type
    if (searchForm.status !== '') params.status = searchForm.status
    const res: any = await getBicycleList(params)
    tableData.value = res.data?.records || []
    total.value = res.data?.total || 0
  } catch (e: any) { ElMessage.error(e.message || '加载失败') }
}

const handleSearch = () => { currentPage.value = 1; loadData() }
const resetSearch = () => { searchForm.bikeNo = ''; searchForm.type = ''; searchForm.status = ''; handleSearch() }

const resetForm = () => {
  form.id = undefined; form.bikeNo = ''; form.imageUrl = ''; form.type = 0; form.status = 0
  form.currentStationId = undefined; form.batteryLevel = undefined; form.purchaseDate = ''; form.lastMaintenanceTime = ''
}

const handleAdd = () => { resetForm(); isEdit.value = false; dialogTitle.value = '新增单车'; dialogVisible.value = true }
const handleEdit = (row: any) => { isEdit.value = true; dialogTitle.value = '编辑单车'; dialogVisible.value = true; Object.assign(form, row) }

const handleSubmit = async () => {
  try {
    if (isEdit.value) { await updateBicycle(form) } else { await addBicycle(form) }
    ElMessage.success('操作成功'); dialogVisible.value = false; loadData()
  } catch (e: any) { ElMessage.error(e.message || '操作失败') }
}

const handleDelete = (id: number) => {
  ElMessageBox.confirm('确认删除该记录？', '提示', { type: 'warning' }).then(async () => {
    try { await deleteBicycle(id); ElMessage.success('删除成功'); loadData() } catch (e: any) { ElMessage.error(e.message || '删除失败') }
  }).catch(() => {})
}

const handleSelectionChange = (rows: any[]) => {
  selectedIds.value = rows.map((r: any) => r.id)
}

const handleBatchDelete = () => {
  if (selectedIds.value.length === 0) { ElMessage.warning('请选择要删除的记录'); return }
  ElMessageBox.confirm(`确认删除选中的 ${selectedIds.value.length} 条记录？`, '提示', { type: 'warning' }).then(async () => {
    try { await batchDeleteBicycle(selectedIds.value); ElMessage.success('批量删除成功'); loadData() }
    catch (e: any) { ElMessage.error(e.message || '批量删除失败') }
  }).catch(() => {})
}

onMounted(loadData)
</script>

<template>
  <div>
    <el-form :inline="true" :model="searchForm" style="margin-bottom:16px">
      <el-form-item label="编号"><el-input v-model="searchForm.bikeNo" placeholder="单车编号" clearable /></el-form-item>
      <el-form-item label="类型">
        <el-select v-model="searchForm.type" placeholder="全部" clearable>
          <el-option v-for="o in typeOptions" :key="o.value" :label="o.label" :value="o.value" />
        </el-select>
      </el-form-item>
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
      <el-table-column label="图片" width="80">
        <template #default="scope">
          <el-image v-if="scope.row.imageUrl" :src="scope.row.imageUrl" style="width:50px;height:50px" fit="cover" :preview-src-list="[scope.row.imageUrl]" />
          <span v-else>暂无</span>
        </template>
      </el-table-column>
      <el-table-column prop="bikeNo" label="编号" />
      <el-table-column prop="type" label="类型">
        <template #default="scope">{{ typeOptions.find(o => o.value === scope.row.type)?.label }}</template>
      </el-table-column>
      <el-table-column prop="status" label="状态">
        <template #default="scope">{{ statusOptions.find(o => o.value === scope.row.status)?.label }}</template>
      </el-table-column>
      <el-table-column prop="currentStationId" label="所属站点" />
      <el-table-column prop="batteryLevel" label="电量" />
      <el-table-column prop="purchaseDate" label="购入日期" width="120" />
      <el-table-column prop="lastMaintenanceTime" label="上次维护时间" width="170" />
      <el-table-column prop="createTime" label="创建时间" width="170" />
      <el-table-column label="操作" width="200">
        <template #default="scope">
          <el-button size="small" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination style="margin-top:16px" v-model:current-page="currentPage" v-model:page-size="pageSize" :total="total" :page-sizes="[10,20,50]" layout="total, sizes, prev, pager, next, jumper" @size-change="loadData" @current-change="loadData" />

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px">
      <el-form :model="form" label-width="120px">
        <el-form-item label="编号"><el-input v-model="form.bikeNo" /></el-form-item>
        <el-form-item label="图片URL"><el-input v-model="form.imageUrl" placeholder="请输入单车图片URL" /></el-form-item>
        <el-form-item label="类型">
          <el-select v-model="form.type"><el-option v-for="o in typeOptions" :key="o.value" :label="o.label" :value="o.value" /></el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="form.status"><el-option v-for="o in statusOptions" :key="o.value" :label="o.label" :value="o.value" /></el-select>
        </el-form-item>
        <el-form-item label="所属站点ID"><el-input-number v-model="form.currentStationId" :controls="false" /></el-form-item>
        <el-form-item label="电量"><el-input-number v-model="form.batteryLevel" :min="0" :max="100" /></el-form-item>
        <el-form-item label="购入日期"><el-date-picker v-model="form.purchaseDate" type="date" value-format="YYYY-MM-DD" /></el-form-item>
        <el-form-item label="上次维护时间"><el-date-picker v-model="form.lastMaintenanceTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>
