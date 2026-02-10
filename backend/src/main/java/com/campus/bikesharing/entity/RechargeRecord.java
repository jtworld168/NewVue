package com.campus.bikesharing.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("recharge_records")
public class RechargeRecord {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Integer userId;

    private BigDecimal amount;

    private LocalDateTime rechargeTime;

    private Integer status;

    private String transactionId;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
