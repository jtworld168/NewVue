# Vue 3 后台管理系统

一个基于 Vue 3 + Vite + TypeScript + Element Plus 构建的现代化后台管理系统。

## 技术栈

- **Vue 3** - 渐进式 JavaScript 框架
- **Vite** - 下一代前端构建工具
- **TypeScript** - JavaScript 的超集，提供类型支持
- **Pinia** - Vue 3 官方推荐的状态管理库
- **Vue Router** - Vue.js 官方路由管理器
- **Axios** - 基于 Promise 的 HTTP 客户端
- **Element Plus** - 基于 Vue 3 的组件库

## 功能特性

- ✅ 用户认证和授权
- ✅ 响应式侧边栏导航
- ✅ 仪表盘数据展示
- ✅ 用户管理（CRUD）
- ✅ 系统设置
- ✅ TypeScript 类型支持
- ✅ 路由权限控制

## 项目结构

```
src/
├── api/              # API 接口
├── assets/           # 静态资源
├── components/       # 公共组件
├── layouts/          # 布局组件
├── router/           # 路由配置
├── stores/           # Pinia 状态管理
├── utils/            # 工具函数
├── views/            # 页面视图
│   ├── dashboard/    # 仪表盘
│   ├── login/        # 登录页
│   ├── users/        # 用户管理
│   └── settings/     # 系统设置
├── App.vue           # 根组件
└── main.ts           # 入口文件
```

## 快速开始

### 安装依赖

```bash
npm install
```

### 开发模式

```bash
npm run dev
```

访问 http://localhost:5173

### 构建生产版本

```bash
npm run build
```

### 预览生产构建

```bash
npm run preview
```

## 登录信息

演示账号：
- 用户名：`admin`
- 密码：`admin123`

## 环境配置

复制 `.env.example` 到 `.env` 并根据需要修改配置：

```bash
cp .env.example .env
```

## 浏览器支持

现代浏览器和 IE11+

## 许可证

MIT License

