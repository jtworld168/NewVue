package com.campus.bikesharing.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.campus.bikesharing.entity.PricingRule;
import com.campus.bikesharing.mapper.PricingRuleMapper;
import com.campus.bikesharing.service.PricingRuleService;
import org.springframework.stereotype.Service;

@Service
public class PricingRuleServiceImpl extends ServiceImpl<PricingRuleMapper, PricingRule> implements PricingRuleService {
}
