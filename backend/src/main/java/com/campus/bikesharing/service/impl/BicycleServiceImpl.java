package com.campus.bikesharing.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.campus.bikesharing.entity.Bicycle;
import com.campus.bikesharing.mapper.BicycleMapper;
import com.campus.bikesharing.service.BicycleService;
import org.springframework.stereotype.Service;

@Service
public class BicycleServiceImpl extends ServiceImpl<BicycleMapper, Bicycle> implements BicycleService {
}
