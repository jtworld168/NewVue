package com.campus.bikesharing.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.bikesharing.common.Result;
import com.campus.bikesharing.entity.MaintenanceRecord;
import com.campus.bikesharing.service.MaintenanceRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/maintenance-records")
public class MaintenanceRecordController {

    @Autowired
    private MaintenanceRecordService maintenanceRecordService;

    @GetMapping("/list")
    public Result<IPage<MaintenanceRecord>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Integer bikeId,
            @RequestParam(required = false) Integer status) {

        LambdaQueryWrapper<MaintenanceRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(bikeId != null, MaintenanceRecord::getBikeId, bikeId)
               .eq(status != null, MaintenanceRecord::getStatus, status)
               .orderByDesc(MaintenanceRecord::getCreateTime);

        IPage<MaintenanceRecord> result = maintenanceRecordService.page(new Page<>(page, pageSize), wrapper);
        return Result.success(result);
    }

    @GetMapping("/{id}")
    public Result<MaintenanceRecord> getById(@PathVariable Long id) {
        MaintenanceRecord record = maintenanceRecordService.getById(id);
        return record != null ? Result.success(record) : Result.error("Maintenance record not found");
    }

    @PostMapping
    public Result<?> save(@RequestBody MaintenanceRecord record) {
        maintenanceRecordService.save(record);
        return Result.success("Created successfully", record);
    }

    @PutMapping
    public Result<?> update(@RequestBody MaintenanceRecord record) {
        maintenanceRecordService.updateById(record);
        return Result.success("Updated successfully", record);
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        maintenanceRecordService.removeById(id);
        return Result.success("Deleted successfully", null);
    }
}
