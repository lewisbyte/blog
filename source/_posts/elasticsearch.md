---
title: elasticsearch源码学习
---

- 用于个人学习总结elasticsearch
- 包括基础使用、运行机制、源码解析等
- 源码基于 6.1 分支: [elasticsearch-6.1分支代码](https://github.com/elastic/elasticsearch/tree/6.1)
## 目录

- [如何调试](#如何调试)

### 如何调试
- 1. 编译构建elasticsearch工程: `./gradlew assemble`
- 2. 将工程集成到IDEA: `./gradlew idea`，用IDEA打开elasticsearch工程
- 3. 执行 `./gradlew :run --debug-jvm`，启动调试模式. 
- 4. debug启动之后，观察日志：`[elasticsearch] Listening for transport dt_socket at address: 8000 `发现debug端口为`8000`. 
- 5. 添加远程JVM调试，主机填`localhost`,端口配置为`8000`,JDK选择 `5-8`，点击确定启动debug
- ![debug 配置](image/003-debug.png)
- 6. 可以观察日志，服务已经正常启动 
```log
[elasticsearch] [2023-07-26T16:19:14,233][INFO ][o.e.t.TransportService   ] [node-0] publish_address {127.0.0.1:9300}, bound_addresses {[::1]:9300}, {127.0.0.1:9300}
[elasticsearch] [2023-07-26T16:19:17,300][INFO ][o.e.c.s.MasterService    ] [node-0] zen-disco-elected-as-master ([0] nodes joined), reason: new_master {node-0}{48qziOzRTdOSQo0nQhQ_PQ}{udw-kDLxTNCvBvup2R2Nqw}{127.0.0.1}{127.0.0.1:9300}{testattr=test}
[elasticsearch] [2023-07-26T16:19:17,304][INFO ][o.e.c.s.ClusterApplierService] [node-0] new_master {node-0}{48qziOzRTdOSQo0nQhQ_PQ}{udw-kDLxTNCvBvup2R2Nqw}{127.0.0.1}{127.0.0.1:9300}{testattr=test}, reason: apply cluster state (from master [master {node-0}{48qziOzRTdOSQo0nQhQ_PQ}{udw-kDLxTNCvBvup2R2Nqw}{127.0.0.1}{127.0.0.1:9300}{testattr=test} committed version [1] source [zen-disco-elected-as-master ([0] nodes joined)]])
[elasticsearch] [2023-07-26T16:19:17,329][INFO ][o.e.g.GatewayService     ] [node-0] recovered [0] indices into cluster_state
[elasticsearch] [2023-07-26T16:19:17,331][INFO ][o.e.h.n.Netty4HttpServerTransport] [node-0] publish_address {127.0.0.1:9200}, bound_addresses {[::1]:9200}, {127.0.0.1:9200}
[elasticsearch] [2023-07-26T16:19:17,333][INFO ][o.e.n.Node               ] [node-0] started
<============-> 96% EXECUTING [11m 35s]
> :distribution:run#start
> IDLE
```
- 7. 在浏览器访问: `http://127.0.0.1:9200/`
```json
{
  "name" : "node-0",
  "cluster_name" : "distribution_run",
  "cluster_uuid" : "otLdQ8YGRDuaRDHHW2ly9w",
  "version" : {
    "number" : "6.1.5",
    "build_hash" : "c975590",
    "build_date" : "2023-07-13T06:34:36.143Z",
    "build_snapshot" : true,
    "lucene_version" : "7.1.0",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```


