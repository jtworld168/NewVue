package com.campus.bikesharing.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.bikesharing.common.Result;
import com.campus.bikesharing.entity.Station;
import com.campus.bikesharing.service.StationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stations")
public class StationController {

    @Autowired
    private StationService stationService;

    @GetMapping("/list")
    public Result<IPage<Station>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String address) {

        LambdaQueryWrapper<Station> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.hasText(name), Station::getName, name)
               .like(StringUtils.hasText(address), Station::getAddress, address)
               .orderByDesc(Station::getCreateTime);

        IPage<Station> result = stationService.page(new Page<>(page, pageSize), wrapper);
        return Result.success(result);
    }

    @GetMapping("/{id}")
    public Result<Station> getById(@PathVariable Integer id) {
        Station station = stationService.getById(id);
        return station != null ? Result.success(station) : Result.error("Station not found");
    }

    @PostMapping
    public Result<?> save(@RequestBody Station station) {
        stationService.save(station);
        return Result.success("Created successfully", station);
    }

    @PutMapping
    public Result<?> update(@RequestBody Station station) {
        stationService.updateById(station);
        return Result.success("Updated successfully", station);
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Integer id) {
        stationService.removeById(id);
        return Result.success("Deleted successfully", null);
    }

    @DeleteMapping("/batch")
    public Result<?> batchDelete(@RequestBody List<Integer> ids) {
        stationService.removeByIds(ids);
        return Result.success("批量删除成功", null);
    }
}
