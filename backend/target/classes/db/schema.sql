-- University Shared Bicycle Management System Schema

CREATE DATABASE IF NOT EXISTS bike_sharing DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE bike_sharing;

-- 1. users
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    real_name VARCHAR(50) NOT NULL,
    identity_number VARCHAR(50) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    user_type TINYINT DEFAULT 0 COMMENT '0-student,1-faculty,2-admin,3-maintenance',
    status TINYINT DEFAULT 0 COMMENT '0-normal,1-frozen',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. stations
CREATE TABLE IF NOT EXISTS stations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    capacity INT DEFAULT 20,
    status TINYINT DEFAULT 0 COMMENT '0-active,1-maintenance,2-disabled',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. bicycles
CREATE TABLE IF NOT EXISTS bicycles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    bike_no VARCHAR(50) UNIQUE NOT NULL,
    type TINYINT DEFAULT 0 COMMENT '0-normal,1-electric',
    status TINYINT DEFAULT 0 COMMENT '0-available,1-in-use,2-maintenance,3-scrapped',
    current_station_id INT,
    battery_level DECIMAL(5,2) DEFAULT 100.00,
    purchase_date DATE,
    last_maintenance_time DATETIME,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bicycle_station FOREIGN KEY (current_station_id) REFERENCES stations(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_bicycle_station ON bicycles(current_station_id);
CREATE INDEX idx_bicycle_status ON bicycles(status);

-- 4. orders
CREATE TABLE IF NOT EXISTS orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    bike_id INT NOT NULL,
    start_station_id INT NOT NULL,
    end_station_id INT,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    duration INT,
    amount DECIMAL(10,2) DEFAULT 0.00,
    status TINYINT DEFAULT 0 COMMENT '0-ongoing,1-completed,2-cancelled',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_order_bike FOREIGN KEY (bike_id) REFERENCES bicycles(id),
    CONSTRAINT fk_order_start_station FOREIGN KEY (start_station_id) REFERENCES stations(id),
    CONSTRAINT fk_order_end_station FOREIGN KEY (end_station_id) REFERENCES stations(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_order_user ON orders(user_id);
CREATE INDEX idx_order_bike ON orders(bike_id);
CREATE INDEX idx_order_status ON orders(status);

-- 5. maintenance_records
CREATE TABLE IF NOT EXISTS maintenance_records (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    bike_id INT NOT NULL,
    reporter_id INT NOT NULL,
    handler_id INT,
    report_time DATETIME NOT NULL,
    handle_time DATETIME,
    description TEXT NOT NULL,
    status TINYINT DEFAULT 0 COMMENT '0-pending,1-processing,2-completed,3-cancelled',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_maintenance_bike FOREIGN KEY (bike_id) REFERENCES bicycles(id),
    CONSTRAINT fk_maintenance_reporter FOREIGN KEY (reporter_id) REFERENCES users(id),
    CONSTRAINT fk_maintenance_handler FOREIGN KEY (handler_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_maintenance_bike ON maintenance_records(bike_id);
CREATE INDEX idx_maintenance_status ON maintenance_records(status);

-- 6. wallets
CREATE TABLE IF NOT EXISTS wallets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    balance DECIMAL(10,2) DEFAULT 0.00,
    freeze_amount DECIMAL(10,2) DEFAULT 0.00,
    update_time DATETIME ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_wallet_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. recharge_records
CREATE TABLE IF NOT EXISTS recharge_records (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    recharge_time DATETIME NOT NULL,
    status TINYINT DEFAULT 0 COMMENT '0-success,1-failed',
    transaction_id VARCHAR(100) UNIQUE,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_recharge_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_recharge_user ON recharge_records(user_id);

-- 8. pricing_rules
CREATE TABLE IF NOT EXISTS pricing_rules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rule_name VARCHAR(100) NOT NULL,
    base_price DECIMAL(10,2) DEFAULT 0.00,
    unit_price DECIMAL(10,2) DEFAULT 0.00,
    free_duration INT DEFAULT 0,
    max_daily_price DECIMAL(10,2) DEFAULT 0.00,
    effective_date DATE NOT NULL,
    status TINYINT DEFAULT 0 COMMENT '0-active,1-disabled',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
