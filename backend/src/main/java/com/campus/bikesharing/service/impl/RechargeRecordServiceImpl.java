package com.campus.bikesharing.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.campus.bikesharing.entity.RechargeRecord;
import com.campus.bikesharing.mapper.RechargeRecordMapper;
import com.campus.bikesharing.service.RechargeRecordService;
import org.springframework.stereotype.Service;

@Service
public class RechargeRecordServiceImpl extends ServiceImpl<RechargeRecordMapper, RechargeRecord> implements RechargeRecordService {
}
