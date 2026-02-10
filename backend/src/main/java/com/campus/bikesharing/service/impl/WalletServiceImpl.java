package com.campus.bikesharing.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.campus.bikesharing.entity.Wallet;
import com.campus.bikesharing.mapper.WalletMapper;
import com.campus.bikesharing.service.WalletService;
import org.springframework.stereotype.Service;

@Service
public class WalletServiceImpl extends ServiceImpl<WalletMapper, Wallet> implements WalletService {
}
