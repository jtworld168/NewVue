package com.campus.bikesharing.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.bikesharing.common.Result;
import com.campus.bikesharing.entity.PricingRule;
import com.campus.bikesharing.service.PricingRuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pricing-rules")
public class PricingRuleController {

    @Autowired
    private PricingRuleService pricingRuleService;

    @GetMapping("/list")
    public Result<IPage<PricingRule>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String ruleName,
            @RequestParam(required = false) Integer status) {

        LambdaQueryWrapper<PricingRule> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.hasText(ruleName), PricingRule::getRuleName, ruleName)
               .eq(status != null, PricingRule::getStatus, status)
               .orderByDesc(PricingRule::getCreateTime);

        IPage<PricingRule> result = pricingRuleService.page(new Page<>(page, pageSize), wrapper);
        return Result.success(result);
    }

    @GetMapping("/{id}")
    public Result<PricingRule> getById(@PathVariable Integer id) {
        PricingRule rule = pricingRuleService.getById(id);
        return rule != null ? Result.success(rule) : Result.error("Pricing rule not found");
    }

    @PostMapping
    public Result<?> save(@RequestBody PricingRule rule) {
        pricingRuleService.save(rule);
        return Result.success("Created successfully", rule);
    }

    @PutMapping
    public Result<?> update(@RequestBody PricingRule rule) {
        pricingRuleService.updateById(rule);
        return Result.success("Updated successfully", rule);
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Integer id) {
        pricingRuleService.removeById(id);
        return Result.success("Deleted successfully", null);
    }

    @DeleteMapping("/batch")
    public Result<?> batchDelete(@RequestBody List<Integer> ids) {
        pricingRuleService.removeByIds(ids);
        return Result.success("批量删除成功", null);
    }
}
