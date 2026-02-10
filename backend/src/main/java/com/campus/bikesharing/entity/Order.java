package com.campus.bikesharing.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("orders")
public class Order {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Integer userId;

    private Integer bikeId;

    private Integer startStationId;

    private Integer endStationId;

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    private Integer duration;

    private BigDecimal amount;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
