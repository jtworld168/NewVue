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
    avatar VARCHAR(255) COMMENT 'avatar URL',
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
    image_url VARCHAR(255) COMMENT 'bicycle image URL',
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

-- ================================================
-- Test Data
-- ================================================

-- Insert test users (passwords are BCrypt encoded for 'password123')
INSERT INTO users (username, password, real_name, identity_number, phone, email, avatar, user_type, status) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '系统管理员', 'A001', '13800000001', 'admin@campus.edu', 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin', 2, 0),
('zhangsan', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '张三', '2021001', '13800000002', 'zhangsan@campus.edu', 'https://api.dicebear.com/7.x/avataaars/svg?seed=zhangsan', 0, 0),
('lisi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '李四', '2021002', '13800000003', 'lisi@campus.edu', 'https://api.dicebear.com/7.x/avataaars/svg?seed=lisi', 0, 0),
('wangwu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '王五', '2021003', '13800000004', 'wangwu@campus.edu', 'https://api.dicebear.com/7.x/avataaars/svg?seed=wangwu', 0, 0),
('teacher01', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '刘老师', 'T001', '13800000005', 'teacher01@campus.edu', 'https://api.dicebear.com/7.x/avataaars/svg?seed=teacher', 1, 0),
('repair01', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '维修工小赵', 'R001', '13800000006', 'repair01@campus.edu', 'https://api.dicebear.com/7.x/avataaars/svg?seed=repair', 3, 0),
('zhaoliu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '赵六', '2021004', '13800000007', 'zhaoliu@campus.edu', 'https://api.dicebear.com/7.x/avataaars/svg?seed=zhaoliu', 0, 0),
('sunqi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '孙七', '2021005', '13800000008', 'sunqi@campus.edu', 'https://api.dicebear.com/7.x/avataaars/svg?seed=sunqi', 0, 1),
('zhouba', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '周八', '2021006', '13800000009', 'zhouba@campus.edu', 'https://api.dicebear.com/7.x/avataaars/svg?seed=zhouba', 0, 0),
('wujiu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '吴九', '2021007', '13800000010', 'wujiu@campus.edu', 'https://api.dicebear.com/7.x/avataaars/svg?seed=wujiu', 0, 0);

-- Insert test stations
INSERT INTO stations (name, address, latitude, longitude, capacity, status) VALUES
('图书馆东门', '校园东区图书馆入口处', 39.99120000, 116.32680000, 30, 0),
('教学楼A区', '教学楼A区南侧停车点', 39.99230000, 116.32790000, 25, 0),
('学生宿舍1号楼', '宿舍区1号楼门口', 39.98980000, 116.32550000, 20, 0),
('食堂广场', '第一食堂前广场', 39.99050000, 116.32700000, 35, 0),
('体育馆西门', '校体育馆西侧入口', 39.99300000, 116.32450000, 15, 0),
('行政楼', '学校行政办公楼前', 39.99180000, 116.32880000, 20, 1),
('实验楼B区', '实验楼B区东侧', 39.99100000, 116.32950000, 18, 0),
('校医院', '校医院门诊楼前', 39.98900000, 116.32650000, 12, 0);

-- Insert test bicycles
INSERT INTO bicycles (bike_no, image_url, type, status, current_station_id, battery_level, purchase_date, last_maintenance_time) VALUES
('BIKE2024001', 'https://img.icons8.com/color/200/bicycle.png', 0, 0, 1, 100.00, '2024-01-15', '2024-06-01 10:00:00'),
('BIKE2024002', 'https://img.icons8.com/color/200/bicycle.png', 0, 0, 1, 100.00, '2024-01-15', '2024-06-01 10:00:00'),
('BIKE2024003', 'https://img.icons8.com/color/200/bicycle.png', 1, 0, 1, 85.50, '2024-02-20', '2024-07-15 14:30:00'),
('BIKE2024004', 'https://img.icons8.com/color/200/bicycle.png', 0, 1, NULL, 100.00, '2024-01-20', '2024-05-10 09:00:00'),
('BIKE2024005', 'https://img.icons8.com/color/200/bicycle.png', 1, 0, 2, 60.00, '2024-03-01', '2024-08-01 11:00:00'),
('BIKE2024006', 'https://img.icons8.com/color/200/bicycle.png', 0, 0, 2, 100.00, '2024-03-10', NULL),
('BIKE2024007', 'https://img.icons8.com/color/200/bicycle.png', 0, 2, NULL, 100.00, '2024-01-15', '2024-04-20 16:00:00'),
('BIKE2024008', 'https://img.icons8.com/color/200/bicycle.png', 1, 0, 3, 92.30, '2024-04-05', '2024-09-01 08:30:00'),
('BIKE2024009', 'https://img.icons8.com/color/200/bicycle.png', 0, 0, 3, 100.00, '2024-04-10', NULL),
('BIKE2024010', 'https://img.icons8.com/color/200/bicycle.png', 0, 0, 4, 100.00, '2024-05-01', NULL),
('BIKE2024011', 'https://img.icons8.com/color/200/bicycle.png', 1, 0, 4, 78.80, '2024-05-15', '2024-09-10 10:00:00'),
('BIKE2024012', 'https://img.icons8.com/color/200/bicycle.png', 0, 0, 4, 100.00, '2024-06-01', NULL),
('BIKE2024013', 'https://img.icons8.com/color/200/bicycle.png', 0, 0, 4, 100.00, '2024-06-10', NULL),
('BIKE2024014', 'https://img.icons8.com/color/200/bicycle.png', 0, 0, 5, 100.00, '2024-06-15', NULL),
('BIKE2024015', 'https://img.icons8.com/color/200/bicycle.png', 1, 0, 5, 45.20, '2024-07-01', '2024-09-20 14:00:00'),
('BIKE2024016', 'https://img.icons8.com/color/200/bicycle.png', 0, 3, NULL, 100.00, '2023-06-01', '2024-01-15 09:00:00'),
('BIKE2024017', 'https://img.icons8.com/color/200/bicycle.png', 0, 0, 7, 100.00, '2024-07-15', NULL),
('BIKE2024018', 'https://img.icons8.com/color/200/bicycle.png', 1, 0, 7, 55.60, '2024-08-01', NULL),
('BIKE2024019', 'https://img.icons8.com/color/200/bicycle.png', 0, 0, 8, 100.00, '2024-08-10', NULL),
('BIKE2024020', 'https://img.icons8.com/color/200/bicycle.png', 0, 0, 8, 100.00, '2024-08-20', NULL);

-- Insert test orders
INSERT INTO orders (user_id, bike_id, start_station_id, end_station_id, start_time, end_time, duration, amount, status) VALUES
(2, 1, 1, 2, '2024-09-01 08:00:00', '2024-09-01 08:30:00', 30, 1.50, 1),
(3, 5, 2, 3, '2024-09-01 09:00:00', '2024-09-01 09:45:00', 45, 2.50, 1),
(4, 3, 1, 4, '2024-09-02 10:00:00', '2024-09-02 10:20:00', 20, 1.00, 1),
(2, 8, 3, 1, '2024-09-03 14:00:00', '2024-09-03 14:50:00', 50, 3.00, 1),
(7, 10, 4, 5, '2024-09-04 07:30:00', '2024-09-04 08:00:00', 30, 1.50, 1),
(9, 14, 5, 2, '2024-09-05 16:00:00', '2024-09-05 16:40:00', 40, 2.00, 1),
(2, 4, 1, NULL, '2024-09-10 08:00:00', NULL, NULL, 0.00, 0),
(3, 6, 2, NULL, '2024-09-10 09:15:00', NULL, NULL, 0.00, 0),
(10, 12, 4, 1, '2024-09-06 11:00:00', '2024-09-06 11:15:00', 15, 0.00, 1),
(4, 9, 3, 4, '2024-09-07 13:00:00', '2024-09-07 13:35:00', 35, 2.00, 1);

-- Insert test maintenance records
INSERT INTO maintenance_records (bike_id, reporter_id, handler_id, report_time, handle_time, description, status) VALUES
(7, 2, 6, '2024-08-15 10:00:00', '2024-08-16 15:00:00', '链条断裂，无法骑行', 2),
(16, 3, 6, '2024-09-01 14:00:00', '2024-09-02 10:00:00', '轮胎爆胎，需要更换', 2),
(4, 4, NULL, '2024-09-10 09:00:00', NULL, '刹车失灵，紧急报修', 0),
(11, 5, 6, '2024-09-05 11:00:00', NULL, '电动车电池充电异常', 1),
(15, 7, NULL, '2024-09-08 16:30:00', NULL, '车把手松动，骑行不稳', 0);

-- Insert test wallets
INSERT INTO wallets (user_id, balance, freeze_amount, update_time) VALUES
(1, 100.00, 0.00, '2024-09-01 00:00:00'),
(2, 50.50, 3.00, '2024-09-10 08:00:00'),
(3, 25.00, 3.00, '2024-09-10 09:15:00'),
(4, 80.00, 0.00, '2024-09-07 13:35:00'),
(5, 200.00, 0.00, '2024-09-01 00:00:00'),
(6, 30.00, 0.00, '2024-09-01 00:00:00'),
(7, 15.50, 0.00, '2024-09-04 08:00:00'),
(8, 0.00, 0.00, '2024-09-01 00:00:00'),
(9, 45.00, 0.00, '2024-09-05 16:40:00'),
(10, 60.00, 0.00, '2024-09-06 11:15:00');

-- Insert test recharge records
INSERT INTO recharge_records (user_id, amount, recharge_time, status, transaction_id) VALUES
(2, 100.00, '2024-08-01 10:00:00', 0, 'TXN20240801001'),
(3, 50.00, '2024-08-05 14:30:00', 0, 'TXN20240805001'),
(4, 100.00, '2024-08-10 09:00:00', 0, 'TXN20240810001'),
(7, 30.00, '2024-08-15 16:00:00', 0, 'TXN20240815001'),
(9, 50.00, '2024-08-20 11:00:00', 0, 'TXN20240820001'),
(10, 80.00, '2024-08-25 08:30:00', 0, 'TXN20240825001'),
(2, 50.00, '2024-09-01 10:00:00', 0, 'TXN20240901001'),
(3, 20.00, '2024-09-05 14:00:00', 1, 'TXN20240905001');

-- Insert test pricing rules
INSERT INTO pricing_rules (rule_name, base_price, unit_price, free_duration, max_daily_price, effective_date, status) VALUES
('校园基础计费', 0.00, 0.05, 15, 10.00, '2024-01-01', 0),
('校园优惠计费', 0.00, 0.03, 30, 5.00, '2024-06-01', 0),
('夜间特惠', 0.00, 0.02, 20, 3.00, '2024-09-01', 0),
('旧版计费方案', 1.00, 0.10, 0, 15.00, '2023-01-01', 1);
