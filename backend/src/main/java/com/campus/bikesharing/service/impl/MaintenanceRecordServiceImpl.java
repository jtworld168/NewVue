package com.campus.bikesharing.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.campus.bikesharing.entity.MaintenanceRecord;
import com.campus.bikesharing.mapper.MaintenanceRecordMapper;
import com.campus.bikesharing.service.MaintenanceRecordService;
import org.springframework.stereotype.Service;

@Service
public class MaintenanceRecordServiceImpl extends ServiceImpl<MaintenanceRecordMapper, MaintenanceRecord> implements MaintenanceRecordService {
}
