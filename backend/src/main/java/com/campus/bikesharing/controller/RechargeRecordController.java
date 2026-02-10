package com.campus.bikesharing.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.bikesharing.common.Result;
import com.campus.bikesharing.entity.RechargeRecord;
import com.campus.bikesharing.service.RechargeRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/recharge-records")
public class RechargeRecordController {

    @Autowired
    private RechargeRecordService rechargeRecordService;

    @GetMapping("/list")
    public Result<IPage<RechargeRecord>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Integer userId,
            @RequestParam(required = false) Integer status) {

        LambdaQueryWrapper<RechargeRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(userId != null, RechargeRecord::getUserId, userId)
               .eq(status != null, RechargeRecord::getStatus, status)
               .orderByDesc(RechargeRecord::getCreateTime);

        IPage<RechargeRecord> result = rechargeRecordService.page(new Page<>(page, pageSize), wrapper);
        return Result.success(result);
    }

    @GetMapping("/{id}")
    public Result<RechargeRecord> getById(@PathVariable Long id) {
        RechargeRecord record = rechargeRecordService.getById(id);
        return record != null ? Result.success(record) : Result.error("Recharge record not found");
    }

    @PostMapping
    public Result<?> save(@RequestBody RechargeRecord record) {
        rechargeRecordService.save(record);
        return Result.success("Created successfully", record);
    }

    @PutMapping
    public Result<?> update(@RequestBody RechargeRecord record) {
        rechargeRecordService.updateById(record);
        return Result.success("Updated successfully", record);
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        rechargeRecordService.removeById(id);
        return Result.success("Deleted successfully", null);
    }
}
