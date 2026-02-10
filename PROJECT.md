# 高校共享单车管理系统

## 📋 项目概述

本项目是一个基于 **Spring Boot 3 + Vue 3** 的高校共享单车管理系统，实现了用户管理、站点管理、单车管理、订单管理、维修记录、钱包管理、充值记录和费用规则等功能的完整 CRUD 操作，支持模糊查询、分页、批量删除，并提供用户登录注册功能。

## 🛠️ 技术栈

### 后端

| 技术 | 版本 | 说明 |
|------|------|------|
| Spring Boot | 3.2.5 | Web 应用框架 |
| MyBatis-Plus | 3.5.5 | ORM 框架（LambdaQueryWrapper） |
| MySQL | 8.x | 关系型数据库 |
| Java | 17 | 开发语言 |
| Maven | 3.x | 项目构建工具 |
| Lombok | - | 简化代码 |
| BCrypt | - | 密码加密 |

### 前端

| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 3.5.x | 渐进式 JavaScript 框架 |
| Vite | 7.x | 下一代前端构建工具 |
| TypeScript | 5.x | JavaScript 超集 |
| Element Plus | 2.13.x | Vue 3 UI 组件库 |
| Pinia | 3.x | 状态管理库 |
| Vue Router | 4.x | 路由管理器 |
| Axios | 1.x | HTTP 客户端 |
| ECharts | 6.x | 图表库 |

---

## 🚀 快速开始

### 环境要求

- **JDK 17+**
- **Maven 3.6+**
- **Node.js 18+**（推荐 20+）
- **npm 9+**
- **MySQL 8.0+**

### 1. 数据库初始化

```bash
# 登录 MySQL
mysql -u root -p

# 执行初始化脚本（包含建表和测试数据）
source backend/src/main/resources/db/schema.sql
```

> ⚠️ 脚本会自动创建 `bike_sharing` 数据库，并插入测试数据。

### 2. 后端启动

```bash
cd backend

# 修改数据库连接信息（可选，默认 root/root）
# 编辑 src/main/resources/application.yml 或设置环境变量：
# export DB_USERNAME=root
# export DB_PASSWORD=your_password

# 编译打包
mvn clean package -DskipTests

# 运行
java -jar target/bike-sharing-0.0.1-SNAPSHOT.jar
```

后端将在 **http://localhost:8080** 启动。

### 3. 前端启动

```bash
cd frontend

# 安装依赖
npm install

# 开发模式启动
npm run dev
```

前端将在 **http://localhost:5173** 启动。

### 4. 测试账号

| 用户名 | 密码 | 角色 | 说明 |
|--------|------|------|------|
| admin | password123 | 管理员 | 系统管理员 |
| zhangsan | password123 | 学生 | 张三 |
| lisi | password123 | 学生 | 李四 |
| teacher01 | password123 | 教职工 | 刘老师 |
| repair01 | password123 | 维修员 | 维修工小赵 |

---

## 📁 项目结构

```
├── backend/                          # 后端 Spring Boot 项目
│   ├── pom.xml                       # Maven 依赖配置
│   └── src/main/
│       ├── java/com/campus/bikesharing/
│       │   ├── BikeSharingApplication.java   # 启动类
│       │   ├── common/
│       │   │   └── Result.java               # 统一响应封装
│       │   ├── config/
│       │   │   ├── CorsConfig.java           # 跨域配置
│       │   │   └── MybatisPlusConfig.java    # MyBatis-Plus 分页插件
│       │   ├── entity/                       # 实体类（8个）
│       │   ├── mapper/                       # Mapper 接口（8个）
│       │   ├── service/                      # Service 接口（8个）
│       │   │   └── impl/                     # Service 实现（8个）
│       │   └── controller/                   # 控制器（9个）
│       └── resources/
│           ├── application.yml               # 应用配置
│           └── db/schema.sql                 # 数据库脚本 + 测试数据
│
├── frontend/                         # 前端 Vue 3 项目
│   ├── package.json                  # npm 依赖配置
│   ├── vite.config.ts                # Vite 配置
│   └── src/
│       ├── main.ts                   # 入口文件（含中文国际化）
│       ├── App.vue                   # 根组件
│       ├── api/                      # API 请求层（10个模块）
│       ├── router/index.ts           # 路由配置
│       ├── stores/user.ts            # Pinia 用户状态管理
│       ├── styles/global.css         # 全局样式
│       └── views/                    # 页面组件（12个）
│           ├── Login.vue             # 登录页
│           ├── Register.vue          # 注册页
│           ├── Layout.vue            # 管理后台布局
│           ├── Dashboard.vue         # 首页仪表盘（含柱状图）
│           ├── UserManage.vue        # 用户管理
│           ├── StationManage.vue     # 站点管理
│           ├── BicycleManage.vue     # 单车管理
│           ├── OrderManage.vue       # 订单管理
│           ├── MaintenanceManage.vue # 维修记录
│           ├── WalletManage.vue      # 钱包管理
│           ├── RechargeManage.vue    # 充值记录
│           └── PricingManage.vue     # 费用规则
│
└── PROJECT.md                        # 本文档
```

---

## 📡 API 接口文档

### 基础信息

- **Base URL**: `http://localhost:8080`
- **响应格式**: JSON
- **统一响应结构**:

```json
{
  "code": 200,
  "message": "success",
  "data": { ... }
}
```

### 认证接口 `/api/auth`

| 方法 | 路径 | 说明 | 请求体 |
|------|------|------|--------|
| POST | `/api/auth/login` | 用户登录 | `{ "username": "", "password": "" }` |
| POST | `/api/auth/register` | 用户注册 | User 对象 |

### 用户管理 `/api/users`

| 方法 | 路径 | 说明 | 参数 |
|------|------|------|------|
| GET | `/api/users/list` | 分页查询用户 | `page`, `pageSize`, `username`, `realName`, `phone` |
| GET | `/api/users/{id}` | 根据ID查询 | 路径参数 `id` |
| POST | `/api/users` | 新增用户 | User JSON |
| PUT | `/api/users` | 更新用户 | User JSON (含 id) |
| DELETE | `/api/users/{id}` | 删除用户 | 路径参数 `id` |
| DELETE | `/api/users/batch` | 批量删除 | `[1, 2, 3]` ID 数组 |

### 站点管理 `/api/stations`

| 方法 | 路径 | 说明 | 参数 |
|------|------|------|------|
| GET | `/api/stations/list` | 分页查询站点 | `page`, `pageSize`, `name`, `address` |
| GET | `/api/stations/{id}` | 根据ID查询 | 路径参数 `id` |
| POST | `/api/stations` | 新增站点 | Station JSON |
| PUT | `/api/stations` | 更新站点 | Station JSON (含 id) |
| DELETE | `/api/stations/{id}` | 删除站点 | 路径参数 `id` |
| DELETE | `/api/stations/batch` | 批量删除 | `[1, 2, 3]` ID 数组 |

### 单车管理 `/api/bicycles`

| 方法 | 路径 | 说明 | 参数 |
|------|------|------|------|
| GET | `/api/bicycles/list` | 分页查询单车 | `page`, `pageSize`, `bikeNo`, `type`, `status` |
| GET | `/api/bicycles/{id}` | 根据ID查询 | 路径参数 `id` |
| GET | `/api/bicycles/count-by-station` | 各站点单车数量统计 | 无 |
| POST | `/api/bicycles` | 新增单车 | Bicycle JSON |
| PUT | `/api/bicycles` | 更新单车 | Bicycle JSON (含 id) |
| DELETE | `/api/bicycles/{id}` | 删除单车 | 路径参数 `id` |
| DELETE | `/api/bicycles/batch` | 批量删除 | `[1, 2, 3]` ID 数组 |

### 订单管理 `/api/orders`

| 方法 | 路径 | 说明 | 参数 |
|------|------|------|------|
| GET | `/api/orders/list` | 分页查询订单 | `page`, `pageSize`, `userId`, `bikeId`, `status` |
| GET | `/api/orders/{id}` | 根据ID查询 | 路径参数 `id` |
| POST | `/api/orders` | 新增订单 | Order JSON |
| PUT | `/api/orders` | 更新订单 | Order JSON (含 id) |
| DELETE | `/api/orders/{id}` | 删除订单 | 路径参数 `id` |
| DELETE | `/api/orders/batch` | 批量删除 | `[1, 2, 3]` ID 数组 |

### 维修记录 `/api/maintenance-records`

| 方法 | 路径 | 说明 | 参数 |
|------|------|------|------|
| GET | `/api/maintenance-records/list` | 分页查询维修记录 | `page`, `pageSize`, `bikeId`, `status` |
| GET | `/api/maintenance-records/{id}` | 根据ID查询 | 路径参数 `id` |
| POST | `/api/maintenance-records` | 新增维修记录 | MaintenanceRecord JSON |
| PUT | `/api/maintenance-records` | 更新维修记录 | MaintenanceRecord JSON (含 id) |
| DELETE | `/api/maintenance-records/{id}` | 删除维修记录 | 路径参数 `id` |
| DELETE | `/api/maintenance-records/batch` | 批量删除 | `[1, 2, 3]` ID 数组 |

### 钱包管理 `/api/wallets`

| 方法 | 路径 | 说明 | 参数 |
|------|------|------|------|
| GET | `/api/wallets/list` | 分页查询钱包 | `page`, `pageSize`, `userId` |
| GET | `/api/wallets/{id}` | 根据ID查询 | 路径参数 `id` |
| POST | `/api/wallets` | 新增钱包 | Wallet JSON |
| PUT | `/api/wallets` | 更新钱包 | Wallet JSON (含 id) |
| DELETE | `/api/wallets/{id}` | 删除钱包 | 路径参数 `id` |
| DELETE | `/api/wallets/batch` | 批量删除 | `[1, 2, 3]` ID 数组 |

### 充值记录 `/api/recharge-records`

| 方法 | 路径 | 说明 | 参数 |
|------|------|------|------|
| GET | `/api/recharge-records/list` | 分页查询充值记录 | `page`, `pageSize`, `userId`, `status` |
| GET | `/api/recharge-records/{id}` | 根据ID查询 | 路径参数 `id` |
| POST | `/api/recharge-records` | 新增充值记录 | RechargeRecord JSON |
| PUT | `/api/recharge-records` | 更新充值记录 | RechargeRecord JSON (含 id) |
| DELETE | `/api/recharge-records/{id}` | 删除充值记录 | 路径参数 `id` |
| DELETE | `/api/recharge-records/batch` | 批量删除 | `[1, 2, 3]` ID 数组 |

### 费用规则 `/api/pricing-rules`

| 方法 | 路径 | 说明 | 参数 |
|------|------|------|------|
| GET | `/api/pricing-rules/list` | 分页查询费用规则 | `page`, `pageSize`, `ruleName`, `status` |
| GET | `/api/pricing-rules/{id}` | 根据ID查询 | 路径参数 `id` |
| POST | `/api/pricing-rules` | 新增费用规则 | PricingRule JSON |
| PUT | `/api/pricing-rules` | 更新费用规则 | PricingRule JSON (含 id) |
| DELETE | `/api/pricing-rules/{id}` | 删除费用规则 | 路径参数 `id` |
| DELETE | `/api/pricing-rules/batch` | 批量删除 | `[1, 2, 3]` ID 数组 |

---

## 🗄️ 数据库设计

### 数据库名：`bike_sharing`

### 表结构概览

| 表名 | 说明 | 主键类型 |
|------|------|----------|
| users | 用户表 | INT |
| stations | 站点表 | INT |
| bicycles | 单车表 | INT |
| orders | 订单表 | BIGINT |
| maintenance_records | 维修记录表 | BIGINT |
| wallets | 钱包表 | INT |
| recharge_records | 充值记录表 | BIGINT |
| pricing_rules | 费用规则表 | INT |

### 外键关系

```
bicycles.current_station_id  →  stations.id         （单车归属站点）
orders.user_id               →  users.id             （骑行用户）
orders.bike_id               →  bicycles.id          （使用单车）
orders.start_station_id      →  stations.id          （借车站点）
orders.end_station_id        →  stations.id          （还车站点）
maintenance_records.bike_id  →  bicycles.id          （故障单车）
maintenance_records.reporter_id → users.id           （报修人）
maintenance_records.handler_id  → users.id           （维修员）
wallets.user_id              →  users.id             （用户钱包，一对一）
recharge_records.user_id     →  users.id             （充值用户）
```

### 各表字段详情

#### users（用户表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INT PK AUTO_INCREMENT | 用户ID |
| username | VARCHAR(50) UNIQUE NOT NULL | 登录账号 |
| password | VARCHAR(100) NOT NULL | BCrypt 加密密码 |
| real_name | VARCHAR(50) NOT NULL | 真实姓名 |
| identity_number | VARCHAR(50) UNIQUE | 学号/工号 |
| phone | VARCHAR(20) NOT NULL | 手机号 |
| email | VARCHAR(100) | 邮箱 |
| avatar | VARCHAR(255) | 头像 URL |
| user_type | TINYINT DEFAULT 0 | 0-学生,1-教职工,2-管理员,3-维修员 |
| status | TINYINT DEFAULT 0 | 0-正常,1-冻结 |
| create_time | DATETIME | 注册时间 |

#### stations（站点表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INT PK AUTO_INCREMENT | 站点ID |
| name | VARCHAR(100) NOT NULL | 站点名称 |
| address | VARCHAR(255) | 详细地址 |
| latitude | DECIMAL(10,8) | 纬度 |
| longitude | DECIMAL(11,8) | 经度 |
| capacity | INT DEFAULT 20 | 可停放数量 |
| status | TINYINT DEFAULT 0 | 0-启用,1-维修中,2-停用 |
| create_time | DATETIME | 创建时间 |

#### bicycles（单车表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INT PK AUTO_INCREMENT | 单车ID |
| bike_no | VARCHAR(50) UNIQUE NOT NULL | 单车编号 |
| image_url | VARCHAR(255) | 单车图片 URL |
| type | TINYINT DEFAULT 0 | 0-普通单车,1-电动单车 |
| status | TINYINT DEFAULT 0 | 0-可用,1-使用中,2-维修中,3-报废 |
| current_station_id | INT FK→stations.id | 当前站点 |
| battery_level | DECIMAL(5,2) | 电量百分比 |
| purchase_date | DATE | 购入日期 |
| last_maintenance_time | DATETIME | 上次维护时间 |
| create_time | DATETIME | 入库时间 |

#### orders（订单表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT PK AUTO_INCREMENT | 订单ID |
| user_id | INT FK→users.id | 骑行用户 |
| bike_id | INT FK→bicycles.id | 使用单车 |
| start_station_id | INT FK→stations.id | 借车站点 |
| end_station_id | INT FK→stations.id | 还车站点 |
| start_time | DATETIME | 借车时间 |
| end_time | DATETIME | 还车时间 |
| duration | INT | 骑行时长(分钟) |
| amount | DECIMAL(10,2) | 计费金额 |
| status | TINYINT DEFAULT 0 | 0-进行中,1-已完成,2-已取消 |
| create_time | DATETIME | 创建时间 |

#### maintenance_records（维修记录表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT PK AUTO_INCREMENT | 记录ID |
| bike_id | INT FK→bicycles.id | 故障单车 |
| reporter_id | INT FK→users.id | 报修人 |
| handler_id | INT FK→users.id | 维修员 |
| report_time | DATETIME | 报修时间 |
| handle_time | DATETIME | 完成时间 |
| description | TEXT | 故障描述 |
| status | TINYINT DEFAULT 0 | 0-待处理,1-处理中,2-已完成,3-已取消 |
| create_time | DATETIME | 创建时间 |

#### wallets（钱包表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INT PK AUTO_INCREMENT | 钱包ID |
| user_id | INT FK→users.id UNIQUE | 关联用户 |
| balance | DECIMAL(10,2) | 可用余额 |
| freeze_amount | DECIMAL(10,2) | 冻结金额 |
| update_time | DATETIME | 余额更新时间 |

#### recharge_records（充值记录表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT PK AUTO_INCREMENT | 记录ID |
| user_id | INT FK→users.id | 充值用户 |
| amount | DECIMAL(10,2) | 充值金额 |
| recharge_time | DATETIME | 充值时间 |
| status | TINYINT DEFAULT 0 | 0-成功,1-失败 |
| transaction_id | VARCHAR(100) UNIQUE | 支付流水号 |
| create_time | DATETIME | 创建时间 |

#### pricing_rules（费用规则表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INT PK AUTO_INCREMENT | 规则ID |
| rule_name | VARCHAR(100) | 规则名称 |
| base_price | DECIMAL(10,2) | 起步价 |
| unit_price | DECIMAL(10,2) | 单价(元/分钟) |
| free_duration | INT | 免费时长(分钟) |
| max_daily_price | DECIMAL(10,2) | 单日封顶费用 |
| effective_date | DATE | 生效日期 |
| status | TINYINT DEFAULT 0 | 0-启用,1-停用 |
| create_time | DATETIME | 创建时间 |

---

## 📌 功能清单

| 功能 | 说明 |
|------|------|
| ✅ 用户登录/注册 | BCrypt 加密密码，支持登录态管理 |
| ✅ 分页查询 | 所有列表接口均支持分页（page/pageSize） |
| ✅ 模糊搜索 | 使用 LambdaQueryWrapper 的 like 方法 |
| ✅ CRUD 操作 | 所有实体均支持增删改查 |
| ✅ 批量删除 | 所有实体均支持按 ID 批量删除 |
| ✅ 用户头像 | 用户登录后在顶栏显示头像和姓名 |
| ✅ 单车图片 | 单车列表显示图片缩略图 |
| ✅ 数据图表 | 首页柱状图展示各站点单车数量对比 |
| ✅ 中文界面 | Element Plus 使用 zh-CN 中文国际化 |
| ✅ 路由守卫 | 未登录自动跳转登录页 |
| ✅ 测试数据 | 提供完整的测试数据（10用户+8站点+20单车+10订单等） |

---

## ⚠️ 注意事项

1. **数据库连接**：默认连接 `localhost:3306`，用户名/密码为 `root/root`。可通过环境变量 `DB_USERNAME` 和 `DB_PASSWORD` 自定义。

2. **跨域配置**：后端 CORS 允许 `http://localhost:5173`（前端开发服务器），生产环境需修改 `CorsConfig.java`。

3. **密码安全**：所有测试账号密码为 `password123`（BCrypt 加密存储）。

4. **外键约束**：删除数据时注意外键关系（如：不能删除有单车关联的站点）。

5. **前端代理**：前端 axios 的 `baseURL` 直接指向 `http://localhost:8080`，不使用 Vite proxy。

6. **图片字段**：用户头像（avatar）和单车图片（image_url）存储的是图片 URL，建议使用图床或 CDN 服务。
