package com.campus.bikesharing.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("bicycles")
public class Bicycle {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private String bikeNo;

    private Integer type;

    private Integer status;

    private Integer currentStationId;

    private BigDecimal batteryLevel;

    private LocalDate purchaseDate;

    private LocalDateTime lastMaintenanceTime;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
