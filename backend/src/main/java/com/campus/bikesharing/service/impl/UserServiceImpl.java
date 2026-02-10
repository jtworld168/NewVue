package com.campus.bikesharing.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.campus.bikesharing.entity.User;
import com.campus.bikesharing.mapper.UserMapper;
import com.campus.bikesharing.service.UserService;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {
}
