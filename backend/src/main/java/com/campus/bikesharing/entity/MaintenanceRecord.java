package com.campus.bikesharing.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("maintenance_records")
public class MaintenanceRecord {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Integer bikeId;

    private Integer reporterId;

    private Integer handlerId;

    private LocalDateTime reportTime;

    private LocalDateTime handleTime;

    private String description;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
