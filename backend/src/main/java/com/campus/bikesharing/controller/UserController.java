package com.campus.bikesharing.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.bikesharing.common.Result;
import com.campus.bikesharing.entity.User;
import com.campus.bikesharing.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/list")
    public Result<IPage<User>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String realName,
            @RequestParam(required = false) String phone) {

        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.hasText(username), User::getUsername, username)
               .like(StringUtils.hasText(realName), User::getRealName, realName)
               .like(StringUtils.hasText(phone), User::getPhone, phone)
               .orderByDesc(User::getCreateTime);

        IPage<User> result = userService.page(new Page<>(page, pageSize), wrapper);
        return Result.success(result);
    }

    @GetMapping("/{id}")
    public Result<User> getById(@PathVariable Integer id) {
        User user = userService.getById(id);
        return user != null ? Result.success(user) : Result.error("User not found");
    }

    @PostMapping
    public Result<?> save(@RequestBody User user) {
        userService.save(user);
        return Result.success("Created successfully", user);
    }

    @PutMapping
    public Result<?> update(@RequestBody User user) {
        userService.updateById(user);
        return Result.success("Updated successfully", user);
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Integer id) {
        userService.removeById(id);
        return Result.success("Deleted successfully", null);
    }

    @DeleteMapping("/batch")
    public Result<?> batchDelete(@RequestBody List<Integer> ids) {
        userService.removeByIds(ids);
        return Result.success("批量删除成功", null);
    }
}
