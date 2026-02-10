package com.campus.bikesharing.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("pricing_rules")
public class PricingRule {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private String ruleName;

    private BigDecimal basePrice;

    private BigDecimal unitPrice;

    private Integer freeDuration;

    private BigDecimal maxDailyPrice;

    private LocalDate effectiveDate;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
