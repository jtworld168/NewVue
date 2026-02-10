package com.campus.bikesharing.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.campus.bikesharing.entity.Bicycle;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BicycleMapper extends BaseMapper<Bicycle> {
}
