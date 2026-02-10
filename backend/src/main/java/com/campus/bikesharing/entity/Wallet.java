package com.campus.bikesharing.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("wallets")
public class Wallet {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private Integer userId;

    private BigDecimal balance;

    private BigDecimal freezeAmount;

    private LocalDateTime updateTime;
}
