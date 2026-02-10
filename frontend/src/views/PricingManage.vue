<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { getPricingList, addPricing, updatePricing, deletePricing } from '../api/pricing'
import { ElMessage, ElMessageBox } from 'element-plus'

const tableData = ref<any[]>([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogTitle = ref('新增费用规则')
const isEdit = ref(false)

const searchForm = reactive({ ruleName: '', status: '' as string | number })
const form = reactive({
  id: undefined as number | undefined,
  ruleName: '',
  basePrice: undefined as number | undefined,
  unitPrice: undefined as number | undefined,
  freeDuration: undefined as number | undefined,
  maxDailyPrice: undefined as number | undefined,
  effectiveDate: '',
  status: 0
})

const statusOptions = [
  { label: '启用', value: 0 },
  { label: '停用', value: 1 }
]

const loadData = async () => {
  try {
    const params: any = { page: currentPage.value, pageSize: pageSize.value }
    if (searchForm.ruleName) params.ruleName = searchForm.ruleName
    if (searchForm.status !== '') params.status = searchForm.status
    const res: any = await getPricingList(params)
    tableData.value = res.data?.records || []
    total.value = res.data?.total || 0
  } catch (e: any) { ElMessage.error(e.message || '加载失败') }
}

const handleSearch = () => { currentPage.value = 1; loadData() }
const resetSearch = () => { searchForm.ruleName = ''; searchForm.status = ''; handleSearch() }

const resetForm = () => {
  form.id = undefined; form.ruleName = ''; form.basePrice = undefined; form.unitPrice = undefined
  form.freeDuration = undefined; form.maxDailyPrice = undefined; form.effectiveDate = ''; form.status = 0
}

const handleAdd = () => { resetForm(); isEdit.value = false; dialogTitle.value = '新增费用规则'; dialogVisible.value = true }
const handleEdit = (row: any) => { isEdit.value = true; dialogTitle.value = '编辑费用规则'; dialogVisible.value = true; Object.assign(form, row) }

const handleSubmit = async () => {
  try {
    if (isEdit.value) { await updatePricing(form) } else { await addPricing(form) }
    ElMessage.success('操作成功'); dialogVisible.value = false; loadData()
  } catch (e: any) { ElMessage.error(e.message || '操作失败') }
}

const handleDelete = (id: number) => {
  ElMessageBox.confirm('确认删除该记录？', '提示', { type: 'warning' }).then(async () => {
    try { await deletePricing(id); ElMessage.success('删除成功'); loadData() } catch (e: any) { ElMessage.error(e.message || '删除失败') }
  }).catch(() => {})
}

onMounted(loadData)
</script>

<template>
  <div>
    <el-form :inline="true" :model="searchForm" style="margin-bottom:16px">
      <el-form-item label="规则名称"><el-input v-model="searchForm.ruleName" placeholder="规则名称" clearable /></el-form-item>
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
    <el-button type="primary" style="margin-bottom:16px" @click="handleAdd">新增</el-button>
    <el-table :data="tableData" border stripe>
      <el-table-column prop="id" label="ID" width="60" />
      <el-table-column prop="ruleName" label="规则名称" />
      <el-table-column prop="basePrice" label="起步价" />
      <el-table-column prop="unitPrice" label="单价" />
      <el-table-column prop="freeDuration" label="免费时长(分钟)" />
      <el-table-column prop="maxDailyPrice" label="封顶价" />
      <el-table-column prop="effectiveDate" label="生效日期" width="120" />
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
      <el-form :model="form" label-width="120px">
        <el-form-item label="规则名称"><el-input v-model="form.ruleName" /></el-form-item>
        <el-form-item label="起步价"><el-input-number v-model="form.basePrice" :min="0" :precision="2" :controls="false" /></el-form-item>
        <el-form-item label="单价"><el-input-number v-model="form.unitPrice" :min="0" :precision="2" :controls="false" /></el-form-item>
        <el-form-item label="免费时长(分钟)"><el-input-number v-model="form.freeDuration" :min="0" :controls="false" /></el-form-item>
        <el-form-item label="封顶价"><el-input-number v-model="form.maxDailyPrice" :min="0" :precision="2" :controls="false" /></el-form-item>
        <el-form-item label="生效日期"><el-date-picker v-model="form.effectiveDate" type="date" value-format="YYYY-MM-DD" /></el-form-item>
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
