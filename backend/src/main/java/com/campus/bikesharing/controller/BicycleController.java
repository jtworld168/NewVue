package com.campus.bikesharing.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.bikesharing.common.Result;
import com.campus.bikesharing.entity.Bicycle;
import com.campus.bikesharing.service.BicycleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/bicycles")
public class BicycleController {

    @Autowired
    private BicycleService bicycleService;

    @GetMapping("/list")
    public Result<IPage<Bicycle>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String bikeNo,
            @RequestParam(required = false) Integer type,
            @RequestParam(required = false) Integer status) {

        LambdaQueryWrapper<Bicycle> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.hasText(bikeNo), Bicycle::getBikeNo, bikeNo)
               .eq(type != null, Bicycle::getType, type)
               .eq(status != null, Bicycle::getStatus, status)
               .orderByDesc(Bicycle::getCreateTime);

        IPage<Bicycle> result = bicycleService.page(new Page<>(page, pageSize), wrapper);
        return Result.success(result);
    }

    @GetMapping("/{id}")
    public Result<Bicycle> getById(@PathVariable Integer id) {
        Bicycle bicycle = bicycleService.getById(id);
        return bicycle != null ? Result.success(bicycle) : Result.error("Bicycle not found");
    }

    @PostMapping
    public Result<?> save(@RequestBody Bicycle bicycle) {
        bicycleService.save(bicycle);
        return Result.success("Created successfully", bicycle);
    }

    @PutMapping
    public Result<?> update(@RequestBody Bicycle bicycle) {
        bicycleService.updateById(bicycle);
        return Result.success("Updated successfully", bicycle);
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Integer id) {
        bicycleService.removeById(id);
        return Result.success("Deleted successfully", null);
    }
}
