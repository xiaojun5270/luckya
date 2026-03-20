# Lucky iOS Panel · Xcode 联调验收清单

## 目标
验证 Lucky iOS 面板当前第三阶段成果是否闭环：
- 真实登录协议
- 真实认证头 `Lucky-Admin-Token`
- 真实 `/api/status`
- 真实 `/api/logs`
- 真实 `/api/modules/list`
- 页面层 `SessionStore` 注入与刷新

---

## 0. 启动前确认
### 环境
- Xcode 可正常打开 `lucky-ios-panel`
- iOS Simulator 或真机可联网访问：`http://192.168.9.102:16601`
- Lucky 后台当前可访问

### 当前代码关键提交
建议至少包含以下提交：
- `bf5880a` — `Align Lucky auth header and runtime status parsing`
- `1753b14` — `Use environment session store in panel views`
- `e473904` — `Polish dashboard and activity presentation`

---

## 1. 登录页验收
文件：
- `Sources/LuckyRemotePanel/Features/Auth/LoginView.swift`
- `Sources/LuckyRemotePanel/Features/Auth/LoginViewModel.swift`

### 检查项
- [ ] 默认服务器地址为：`http://192.168.9.102:16601`
- [ ] 输入正确账号密码后可以登录成功
- [ ] 登录成功后 `SessionStore.isLoggedIn == true`
- [ ] `SessionStore.authToken?.token` 非空
- [ ] 登录失败时能显示错误信息，而不是静默失败

### 期望结果
- 成功登录后自动进入主界面
- 不再依赖 cookie / Bearer 才能继续访问 API
- 登录返回 token 被保存到 `SessionStore`

---

## 2. Dashboard 页验收
文件：
- `Sources/LuckyRemotePanel/Features/Dashboard/DashboardView.swift`
- `Sources/LuckyRemotePanel/Features/Dashboard/DashboardViewModel.swift`

### 检查项
- [ ] 头部显示在线/异常状态
- [ ] 头部显示当前服务器地址
- [ ] 登录后显示 `Token 已载入 · xxxx...`
- [ ] 状态卡片有真实数据，不是空白占位
- [ ] 至少能看到以下卡片中的若干项：
  - [ ] 系统
  - [ ] CPU
  - [ ] 内存
  - [ ] 模块数
  - [ ] TCP
- [ ] `CPU` 状态颜色会跟随值变化（ok / warning / error）
- [ ] 最近动态区域能显示日志，不是静态假数据

### 期望结果
- Dashboard 数据来自真实接口：
  - `/api/status`
  - `/api/info`
  - `/api/modules/list`
  - `/api/logs`

---

## 3. Services 页验收
文件：
- `Sources/LuckyRemotePanel/Features/Services/ServicesView.swift`
- `Sources/LuckyRemotePanel/Features/Services/ServicesViewModel.swift`

### 检查项
- [ ] 页面顶部显示服务汇总：
  - [ ] 总数
  - [ ] 主模块
  - [ ] 扩展
- [ ] 主模块分组能显示 `running` 映射后的模块
- [ ] 扩展模块分组能显示 `available` 映射后的模块
- [ ] 每个服务项都有：
  - [ ] 状态圆点
  - [ ] 名称
  - [ ] 状态标签
  - [ ] 描述信息
- [ ] 无数据时能显示 `暂无服务数据`
- [ ] 出错时能显示错误提示

### 期望结果
- Services 数据来自真实 `/api/modules/list`
- 不再使用本地静态假模块列表

---

## 4. Activity 页验收
文件：
- `Sources/LuckyRemotePanel/Features/Dashboard/ActivityView.swift`

### 检查项
- [ ] 能看到真实日志列表
- [ ] 每条日志包含：
  - [ ] 标题
  - [ ] 正文
  - [ ] 时间
- [ ] 日志正文可以复制（文本可选中）
- [ ] 空数据时显示 `暂无动态数据`
- [ ] 请求失败时显示错误提示

### 期望结果
- Activity 数据来自真实 `/api/logs?pre=20`
- 页面样式呈现为可读日志流，而不是原始 JSON 文本堆叠

---

## 5. Settings 页验收
文件：
- `Sources/LuckyRemotePanel/Features/Settings/SettingsView.swift`

### 检查项
- [ ] 能看到当前服务器地址
- [ ] 能看到当前用户名
- [ ] 能看到登录状态
- [ ] 登录后能看到 token 前缀展示
- [ ] 点击“退出登录”后会话被清掉

### 期望结果
- `logout()` 后回到未登录状态
- 页面不残留旧 token

---

## 6. 登录态切换验收
### 检查项
- [ ] 登录成功后 Dashboard / Services / Activity 自动刷新
- [ ] 退出登录后页面状态同步变化
- [ ] 再次登录后各页面重新加载真实数据

### 期望结果
- 页面使用环境注入的真实 `SessionStore`
- 页面刷新触发依赖：`sessionStore.authToken?.token`
- 不应再出现“页面绑定的是假 SessionStore”问题

---

## 7. 失败场景验收
### 建议测试
- [ ] 服务器地址改错
- [ ] 用户名/密码输错
- [ ] Lucky 后台断开
- [ ] token 失效后重新登录

### 期望结果
- 有明确错误提示
- 不应出现页面假装成功但实际无数据
- 不应继续沿用旧会话偷偷请求

---

## 8. 已知未闭环项
- 当前宿主机未装 `swift`，本轮主要依赖静态校验与代码收口，需在 Xcode 内做真实编译验证
- `Services` 页的 `running / available` 仍是前端展示层映射，不一定等价于 Lucky 后端真实运行态
- Dashboard 展示仍可继续增强，例如：
  - 运行时长
  - 网络速率
  - 启动时间
- 如后续发现 `/api/logs` 真实结构还有更多层次，仍可再补模型

---

## 当前阶段判断
当前 Lucky iOS 面板已接近可联调验收状态，整体可按 **约 88% 完成度** 评估。
