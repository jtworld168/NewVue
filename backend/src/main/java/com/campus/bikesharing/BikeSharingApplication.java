package com.campus.bikesharing;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.campus.bikesharing.mapper")
public class BikeSharingApplication {

    public static void main(String[] args) {
        SpringApplication.run(BikeSharingApplication.class, args);
    }
}
