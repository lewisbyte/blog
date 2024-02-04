---
title: 编译原理相关
---

- 编译原理相关

## 目录

- [antlr4的本地配置安装](#antlr4的本地配置安装)
- [巴科斯范式](#巴科斯范式)

### antlr4的本地配置安装

- 1. 下载antlr到本地机器: `wget http://www.antlr.org/download/antlr-4.11.1-complete.jar`，将本地JDK版本调整至 JDK-11 或以上版本即可。
- 2. 在本地 `~/.bash_profile` 添加以下环境变量

```bash
#antlr4
export ANTLR_PATH=/Users/lewis/soft_repo/antlr/antlr-4.11.1-complete.jar
export CLASSPATH=.:$JAVA_HOME/lib:$ANTLR_PATH
alias antlr4='java org.antlr.v4.Tool'
alias grun='java org.antlr.v4.gui.TestRig'
```

- 3. 执行`source ~/.bash_profile`，刷新当前终端环境变量，输入：`antlr4` 验证是否成功，如果成功则出现以下信息输出：

```bash
➜  ~ antlr4
ANTLR Parser Generator  Version 4.11.1
 -o ___              specify output directory where all output is generated
 -lib ___            specify location of grammars, tokens files
 -atn                generate rule augmented transition network diagrams
 -encoding ___       specify grammar file encoding; e.g., euc-jp
 -message-format ___ specify output style for messages in antlr, gnu, vs2005
 -long-messages      show exception details when available for errors and warnings
 -listener           generate parse tree listener (default)
 -no-listener        don't generate parse tree listener
 -visitor            generate parse tree visitor
 -no-visitor         don't generate parse tree visitor (default)
 -package ___        specify a package/namespace for the generated code
 -depend             generate file dependencies
 -D<option>=value    set/override a grammar-level option
 -Werror             treat warnings as errors
 -XdbgST             launch StringTemplate visualizer on generated code
 -XdbgSTWait         wait for STViz to close before continuing
 -Xforce-atn         use the ATN simulator for all predictions
 -Xlog               dump lots of logging info to antlr-timestamp.log
 -Xexact-output-dir  all output goes into -o dir regardless of paths/package
```

### 巴科斯范式

“巴科斯范式”，简称 BNF。Antlr 和 Yacc 这两个工具都用这种写法。为了简化书写，我有时会在课程中把“::=”简化成一个冒号。你看到的时候，知道是什么意思就可以了。

你有时还会听到一个术语，叫做扩展巴科斯范式 (EBNF)。它跟普通的 BNF 表达式最大的区别，就是里面会用到类似正则表达式的一些写法。比如下面这个规则中运用了 * 号，来表示这个部分可以重复 0 到多次：