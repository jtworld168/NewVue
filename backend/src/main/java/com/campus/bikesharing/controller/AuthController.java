package com.campus.bikesharing.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.campus.bikesharing.common.Result;
import com.campus.bikesharing.entity.User;
import com.campus.bikesharing.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.DigestUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public Result<?> login(@RequestBody Map<String, String> loginForm) {
        String username = loginForm.get("username");
        String password = loginForm.get("password");

        if (!StringUtils.hasText(username) || !StringUtils.hasText(password)) {
            return Result.error("Username and password are required");
        }

        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, username);
        User user = userService.getOne(wrapper);

        if (user == null) {
            return Result.error("User not found");
        }

        String encrypted = DigestUtils.md5DigestAsHex(password.getBytes());
        if (!encrypted.equals(user.getPassword())) {
            return Result.error("Incorrect password");
        }

        if (user.getStatus() != null && user.getStatus() == 1) {
            return Result.error("Account is frozen");
        }

        user.setPassword(null);
        return Result.success("Login successful", user);
    }

    @PostMapping("/register")
    public Result<?> register(@RequestBody User user) {
        if (!StringUtils.hasText(user.getUsername()) || !StringUtils.hasText(user.getPassword())) {
            return Result.error("Username and password are required");
        }

        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, user.getUsername());
        if (userService.count(wrapper) > 0) {
            return Result.error("Username already exists");
        }

        user.setPassword(DigestUtils.md5DigestAsHex(user.getPassword().getBytes()));
        userService.save(user);
        user.setPassword(null);
        return Result.success("Registration successful", user);
    }
}
