package com.campus.bikesharing.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("stations")
public class Station {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private String name;

    private String address;

    private BigDecimal latitude;

    private BigDecimal longitude;

    private Integer capacity;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
