package com.campus.bikesharing.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.bikesharing.common.Result;
import com.campus.bikesharing.entity.Wallet;
import com.campus.bikesharing.service.WalletService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/wallets")
public class WalletController {

    @Autowired
    private WalletService walletService;

    @GetMapping("/list")
    public Result<IPage<Wallet>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Integer userId) {

        LambdaQueryWrapper<Wallet> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(userId != null, Wallet::getUserId, userId);

        IPage<Wallet> result = walletService.page(new Page<>(page, pageSize), wrapper);
        return Result.success(result);
    }

    @GetMapping("/{id}")
    public Result<Wallet> getById(@PathVariable Integer id) {
        Wallet wallet = walletService.getById(id);
        return wallet != null ? Result.success(wallet) : Result.error("Wallet not found");
    }

    @PostMapping
    public Result<?> save(@RequestBody Wallet wallet) {
        walletService.save(wallet);
        return Result.success("Created successfully", wallet);
    }

    @PutMapping
    public Result<?> update(@RequestBody Wallet wallet) {
        walletService.updateById(wallet);
        return Result.success("Updated successfully", wallet);
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Integer id) {
        walletService.removeById(id);
        return Result.success("Deleted successfully", null);
    }
}
