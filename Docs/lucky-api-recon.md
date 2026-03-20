# Lucky API 勘察记录（v0.1）

## 目标
- Host: `http://192.168.9.102:16601`
- Version: `Lucky 2.27.2`

## 登录态
- Cookie: `fnos-token=<token>`
- 当前页面 localStorage 关键键：
  - `host`
  - `appName`
  - `version`
  - `theme`
  - `lucky`

## 已发现 API 痕迹
- `/api/status`
- `/api/logs`
- `/api/baseconfigure`
- `/api/login`
- `/api/oauth/login`
- `/api/reboot_program`
- `/api/modules/list`
- `/api/logout`
- `/api/netinterfaces`
- `/api/ipregtest`
- `/api/twofapassword`
- `/api/info`
- `/api/restoreconfigureconfirm`
- `/api/lucky/service`
- `/api/update/comfire`
- `/api/update/cancel`
- `/api/v2l`
- `/api/oauth/tmpcode`
- `/api/oauth/userinfo`

## 当前映射策略
1. 优先接：login / status / logs / modules
2. 再接：info / baseconfigure / lucky/service
3. 最后按菜单模块逐项扩展

## 后续动作
- 抓 login 请求体与响应结构
- 抓 status / modules/list / logs 的真实 JSON
- 建立 Codable 模型
- 替换当前占位实现
