package com.campus.bikesharing.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.campus.bikesharing.entity.Order;
import com.campus.bikesharing.mapper.OrderMapper;
import com.campus.bikesharing.service.OrderService;
import org.springframework.stereotype.Service;

@Service
public class OrderServiceImpl extends ServiceImpl<OrderMapper, Order> implements OrderService {
}
