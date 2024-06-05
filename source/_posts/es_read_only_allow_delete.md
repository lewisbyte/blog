---
title: 记一次es索引数据写入异常排查
---

## 目录

- [环境信息](#环境信息)
- [现象](#现象)
- [分析](#分析)
- [源码解析](#源码解析)

### 环境信息

- elasticsearch 6.8.2
- jdk-8
- cpu-24核心、64gb内存
- 数据量：943GB

### 现象

- 在进行对索引写入数据的时候，报出异常：`forbidden/12/index read-only / allow delete (api) status 403`

### 分析

### 源码解析
