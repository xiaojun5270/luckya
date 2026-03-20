# Lucky Remote Panel

Lucky 后台的 iOS 远程管理面板项目。

## 当前状态
当前已进入 **第三阶段：可联调验收**。

已完成：
- Lucky 真实登录协议接线
- `Lucky-Admin-Token` 请求头对齐
- 真实接口接入：
  - `/api/status`
  - `/api/logs`
  - `/api/modules/list`
  - `/api/info`
- SwiftUI 页面联通：
  - Dashboard
  - Services
  - Activity
  - Settings
  - Login
- `SessionStore` 登录态注入与切换
- 登录失败 / token 失效 / 退出登录后的旧数据清理
- 最终联调文档补齐
- GitHub Actions 无证书构建方案（Simulator Build）

## 当前仓库结构
- `Docs/` 产品与接口分析文档
- `DesignSystem/` 设计资源与设计令牌
- `Sources/` SwiftUI 源码
- `project.yml` XcodeGen 工程定义
- `.github/workflows/ios-simulator-build.yml` GitHub Actions 构建流程

## GitHub Actions 构建说明
当前仓库使用 **XcodeGen** 在 GitHub macOS runner 上动态生成 `.xcodeproj`，然后执行无证书构建。

### 当前产物
GitHub Actions 目前输出：
- iOS Simulator 版 `LuckyRemotePanel.app`（zip artifact）
- DerivedData / build 日志

### 触发方式
- push 到 `main` 或 `master`
- 手动触发 `workflow_dispatch`

### 说明
当前是 **无证书构建**，因此目标是：
- 验证项目可在 GitHub macOS 环境编译
- 产出 simulator 构建产物

不是：
- 真机可安装签名 IPA

如需真机 IPA，后续还需补：
- Apple 证书
- Provisioning Profile
- GitHub Secrets
- Archive / Export 流程

## 联调文档
- `XCODE-联调验收清单.md`
- `最后联调关注点.md`
- `最终验收执行顺序.md`

## 下一步
1. 将仓库推送到 GitHub
2. 触发 GitHub Actions 无证书构建
3. 下载 simulator 构建产物验证
4. 如需真机安装，再补签名与 IPA 导出链路
