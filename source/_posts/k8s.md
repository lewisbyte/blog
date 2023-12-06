---
title: K8S 自学总结
---

## 部署

### 模板类型

- deployment：无状态服务（在线）
- stateful：有状态服务（在线）
- batch：离线计算服务
  - CronJob：定时离线任务
  - Job：普通离线任务
- Ingress：代理不同后端 Service 而设置的负载均衡服务
