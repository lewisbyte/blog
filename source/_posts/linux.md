---
title: Linux应用性能调优-LTS
categories: 
- 技术开发
tags:
- Linux
---

- 总结、收集 Linux 实用命令、系统应用调优相关的技巧
- 本文基于 Ubuntu-22.04、Centos-7 版本

## 场景

- [内存问题分析](#内存问题分析)
- [CPU问题分析](#CPU问题分析)
- [磁盘问题分析](#磁盘问题分析)
- [网络问题分析](#网络问题分析)

## 目录

- [系统信息](#系统信息)
  - [系统信息-top](#top)
  - [系统信息-sar](#sar)
  - [系统信息-watch](#watch)
  - [系统信息-pidstat](#pidstat)
  - [系统信息-mpstat](#mpstat)
  - [系统信息-vmstat](#vmstat)
  - [系统信息-dstat](#dstat)
  - [系统信息-cachestat](#cachestat)
  - [系统信息-cachetop](#cachetop)
  - [系统信息-slabtop](#slabtop)
  - [系统信息-strace](#strace)
  - [系统信息-perf](#perf)
  - [系统信息-pstree](#pstree)
  - [系统信息-valgrind](#valgrind)
  - [系统信息-procfs](#procfs)
- [文件磁盘](#文件磁盘)
  - [磁盘信息-iostat](#iostat)
  - [磁盘信息-iotop](#iotop)
  - [文件信息-lsof](#lsof)
-[系统测试](#系统测试)
  - [测试-cpu-stress](#stress)
  - [测试-系统-sysbench](#sysbench)
  - [测试-磁盘-dd](#dd)
  - [测试-磁盘-fio](#fio)
- [网络](#网络)
  - [网络调试-nslookup](#nslookup)
  - [网络调试-dig](#dig)
  - [网络测试-ping](#ping)
  - [网络测试-iperf](#iperf)
  - [网络信息-tcpdump](#tcpdump)

### CPU问题分析

![CPU问题分析图](image/002-cpu.png)

### 内存问题分析

![内存问题分析图](image/001-mem.png)

### 磁盘问题分析

![磁盘问题分析图](image/005-disk.png)

### 网络问题分析

![磁盘问题分析图](image/009.png)

## 系统信息

### top

- [简介]: top （table of processes）是一个任务管理器程序，它可运行于许多类Unix操作系统上，它用于显示有关CPU和内存利用率的信息。

- us: 用户态使用率
- sy: 内核态使用率
- id: 空闲率
- Mem: 物理内存使用量
- Swap: 虚拟内存分区使用量
- 进程关键指标: S 列（也就是 Status 列）含义
  - R 是 Running 或 Runnable 的缩写，表示进程在 CPU 的就绪队列中，正在运行或者正在等待运行。
  - D 是 Disk Sleep 的缩写，也就是不可中断状态睡眠（Uninterruptible Sleep），一般表示进程正在跟硬件交互，并且交互过程不允许被其他进程或中断打断。
  - Z 是 Zombie 的缩写，如果你玩过“植物大战僵尸”这款游戏，应该知道它的意思。它表示僵尸进程，也就是 进程实际上已经结束了，但是父进程还没有回收它的资源（比如进程的描述符、PID 等）。
  - I 是 Idle 的缩写，也就是空闲状态，用在不可中断睡眠的内核线程上。前面说了，硬件交互导致的不可中断进程用 D 表示，但对某些内核线程来说，它们有可能实际上并没有任何负载，用 Idle 正是为了区分这种情况。要注意，D 状态的进程会导致平均负载升高，I 状态的进程却不会。
- VIRT 是进程虚拟内存的大小，只要是进程申请过的内存，即便还没有真正分配物理内存，也会计算在内。
- RES 是常驻内存的大小，也就是进程实际使用的物理内存大小，但不包括 Swap 和共享内存。
- SHR 是共享内存的大小，比如与其他进程共同使用的共享内存、加载的动态链接库以及程序的代码段等。
- %MEM 是进程使用物理内存占系统总内存的百分比。

### sar

- [简介]:sar是System Activity Reporter（系统活动情况报告）的缩写。sar工具将对系统当前的状态进行取样，然后通过计算数据和比例来表达系统的当前运行状态。它的特点是可以连续对系统取样，获得大量的取样数据；取样数据和分析的结果都可以存入文件，所需的负载很小。sar是目前Linux上最为全面的系统性能分析工具之一，可以从14个大方面对系统的活动进行报告，包括文件的读写情况、系统调用的使用情况、串口、CPU效率、内存使用状况、进程活动及IPC有关的活动等，使用也是较为复杂。

- sar -u : 默认情况下显示的cpu使用率等信息就是sar -u；
  - %user 用户模式下消耗的CPU时间的比例；
  - %nice 通过nice改变了进程调度优先级的进程，在用户模式下消耗的CPU时间的比例
  - %system 系统模式下消耗的CPU时间的比例；
  - %iowait CPU等待磁盘I/O导致空闲状态消耗的时间比例；
  - %steal 利用Xen等操作系统虚拟化技术，等待其它虚拟CPU计算占用的时间比例；
  - %idle CPU空闲时间比例；

- sar -q: 查看平均负载
  - runq-sz：运行队列的长度（等待运行的进程数）
  - plist-sz：进程列表中进程（processes）和线程（threads）的数量
  - ldavg-1：最后1分钟的系统平均负载 ldavg-5：过去5分钟的系统平均负载
  - ldavg-15：过去15分钟的系统平均负载

- sar -r： 指定-r之后，可查看物理内存使用状况；
  - kbmemfree：这个值和free命令中的free值基本一致,所以它不包括buffer和cache的空间.
  - kbmemused：这个值和free命令中的used值基本一致,所以它包括buffer和cache的空间.
  - %memused：物理内存使用率，这个值是kbmemused和内存总量(不包括swap)的一个百分比.
  - kbbuffers和kbcached：这两个值就是free命令中的buffer和cache.
  - kbcommit：保证当前系统所需要的内存,即为了确保不溢出而需要的内存(RAM+swap).
  - %commit：这个值是kbcommit与内存总量(包括swap)的一个百分比.
- sar -W：查看页面交换发生状况
  - pswpin/s：每秒系统换入的交换页面（swap page）数量
  - pswpout/s：每秒系统换出的交换页面（swap page）数量
- 场景使用
  - 怀疑CPU存在瓶颈，可用 sar -u 和 sar -q 等来查看
  - 怀疑内存存在瓶颈，可用sar -B、sar -r 和 sar -W 等来查看
  - 怀疑I/O存在瓶颈，可用 sar -b、sar -u 和 sar -d 等来查看
- 参数含义解释
  - -A 汇总所有的报告
  - -a 报告文件读写使用情况
  - -B 报告附加的缓存的使用情况
  - -b 报告缓存的使用情况
  - -c 报告系统调用的使用情况
  - -d 报告磁盘的使用情况
  - -g 报告串口的使用情况
  - -h 报告关于buffer使用的统计数据
  - -m 报告IPC消息队列和信号量的使用情况
  - -n 报告命名cache的使用情况
  - -p 报告调页活动的使用情况
  - -q 报告运行队列和交换队列的平均长度
  - -R 报告进程的活动情况
  - -r 报告没有使用的内存页面和硬盘块
  - -u 报告CPU的利用率
  - -v 报告进程、i节点、文件和锁表状态
  - -w 报告系统交换活动状况
  - -y 报告TTY设备活动状况

### watch

- [简介]: Linux中的watch 命令提供了一种方式处理重复的任务。默认watch会每2秒重复执行命令。你一定也想到了,watch是一个很好的观察log文件的工具。下面是一个例子。
- 例如执行命令` watch -n 1 -d ps ` 每隔一秒高亮显示进程信息

### pidstat

- [简介]:
- 样例: 如监控进程pid`4344`]信息: `pidstat -d -p 4344 1 3`，-d 展示 I/O 统计数据，-p 指定进程号，间隔 1 秒输出 3 组数据
- 参数含义: kB_rd 表示每秒读的 KB 数， kB_wr 表示每秒写的 KB 数，iodelay 表示 I/O 的延迟（单位是时钟周期）

### dstat

- [简介] dstat 是一个新的性能工具，它吸收了 vmstat、iostat、ifstat 等几种工具的优点，可以同时观察系统的 CPU、磁盘 I/O、网络以及内存使用情况。
- 安装执行命令 `apt install dstat -y`

## 文件磁盘

### iostat

- [简介] iostat 是最常用的磁盘 I/O 性能观测工具，它提供了每个磁盘的使用率、IOPS、吞吐量等各种常见的性能指标，当然，这些指标实际上来自 /proc/diskstats。
- [样例] `iostat -d -x 1`
- [参数含义](image/004-iostat.png)
- %util ，就是我们前面提到的磁盘 I/O 使用率；
- r/s+ w/s ，就是 IOPS；
- rkB/s+wkB/s ，就是吞吐量；
- r_await+w_await ，就是响应时间。

### iotop

- [简介] 一个类似于 top 的工具，你可以按照 I/O 大小对进程排序，然后找到 I/O 较大的那些进程
- [样例] `iotop`

### lsof

- [简介] 用于查看你进程打开的文件，打开文件的进程，进程打开的端口(TCP、UDP)。 找回/恢复删除的文件
- [样例] `lsof -p $pid` 查看对应进程关联打开的 网络、文件、设备、socket链接 等。如果要查看某个pid的TCP类型文件，执行`lsof -p $pid | grep TCP` 即可查看到监听的TCP网络及端口相关信息
- [样例] `lsof -i $port` 查看对应端口的占用情况

### mpstat

- [简介] todo

### vmstat

- [简介] todo

### cachestat

- [简介] 缓存命中率
- [样例] `cachestat 1 3`
- [参数含义]
  - TOTAL ，表示总的 I/O 次数；
  - MISSES ，表示缓存未命中的次数；
  - HITS ，表示缓存命中的次数；
  - DIRTIES， 表示新增到缓存中的脏页数；
  - BUFFERS_MB 表示 Buffers 的大小，以 MB 为单位；
  - CACHED_MB 表示 Cache 的大小，以 MB 为单位

### cachetop

- [简介] 缓存命中率：输出跟 top 类似，默认按照缓存的命中次数（HITS）排序，展示了每个进程的缓存命中情况。具体到每一个指标，这里的 HITS、MISSES 和 DIRTIES ，跟 cachestat 里的含义一样，分别代表间隔时间内的缓存命中次数、未命中次数以及新增到缓存中的脏页数。
- [样例] `cachetop`

### slabtop

- [简介] 实时显示内核slab内存缓存信息，使用 slabtop ，来找到占用内存最多的缓存类型。内核的模块在分配资源的时候，为了提高效率和资源的利用率，都是透过slab来分配的。通过slab的信息，再配合源码能粗粗了解系统的运行情况，比如说什么资源有没有不正常的多，或者什么资源有没有泄漏。linux系统透过/proc/slabinfo来向用户暴露slab的使用情况。Linux 所使用的 slab 分配器的基础是 Jeff Bonwick 为 SunOS 操作系统首次引入的一种算法。Jeff 的分配器是围绕对象缓存进行的。在内核中，会为有限的对象集（例如文件描述符和其他常见结构）分配大量内存。Jeff 发现对内核中普通对象进行初始化所需的时间超过了对其进行分配和释放所需的时间。因此他的结论是不应该将内存释放回一个全局的内存池，而是将内存保持为针对特定目而初始化的状态。Linux slab 分配器使用了这种思想和其他一些思想来构建一个在空间和时间上都具有高效性的内存分配器。保存着监视系统中所有活动的 slab 缓存的信息的文件为/proc/slabinfo。
- [样例] `slabtop`

### strace

- [简介] 跟进程系统调用的工具,观察对应pid进程的系统调用
- [安装] `apt install strace`
- [样例]: 运行 strace 命令，并用 -p 参数指定 PID 号 `strace -p 6082`

### perf

- [简介] todo
- [安装] todo
- [样例]: 采样操作系统函数调用 `perf record -g`，获取调用报告 `perf report`

### pstree

- [简介]
- [样例] `pstree -aps 3084`; a 表示输出命令行选项 ; p 表 PID; s 表示指定进程的父进程

### valgrind

- [简介] 内存泄露检测工具，应用最广泛的工具，一个重量级的内存检查器，能够发现开发中绝大多数内存错误使用情况
- [内存检测王者之剑—valgrind](https://zhuanlan.zhihu.com/p/56538645)

- [简介]

## 系统测试

### stress

- [简介] cpu、io 压测测试

### iperf

- [简介] 网络性能测试

### sysbench

- [简介] sysbench是跨平台的基准测试工具

### dd

- [简介]Linux dd 命令用于读取、转换并输出数据。dd 可从标准输入或文件中读取数据，根据指定的格式来转换数据，再输出到文件、设备或标准输出。
- [使用场景]适用于测试磁盘的顺序读写场景
- [样例] 生成一个 512MB 的临时文件 `dd if=/dev/sda1 of=file bs=1M count=512`，
- [样例] 写入指定目录文件夹路径文件 `dd if=/dev/zero of=/Users/lewis/fx/test.file  bs=1M  count=10000K iflag=direct`

### fio

- [简介]: 测试磁盘的 IOPS、吞吐量以及响应时间等核心指标

## 内核

### procfs

- [简介]: 在许多类 Unix 计算机系统中， procfs 是 进程 文件系统 (file system) 的缩写，包含一个伪文件系统（启动时动态生成的文件系统），用于通过内核访问进程信息。这个文件系统通常被挂载到 /proc 目录。由于 /proc 不是一个真正的文件系统，它也就不占用存储空间，只是占用有限的内存。

- 执行命令 ` ls /etc/proc ` ，即可查阅系统进程的文件信息

- 进程相关
  - 每个正在运行的进程对应于/proc下的一个目录，目录名就是进程的PID，每个目录包含:
  - /proc/PID/cmdline, 启动该进程的命令行.
  - /proc/PID/cwd, 当前工作目录的符号链接.
  - /proc/PID/environ 影响进程的环境变量的名字和值.
  - /proc/PID/exe, 最初的可执行文件的符号链接, 如果它还存在的话。
  - /proc/PID/fd, 一个目录，包含每个打开的文件描述符的符号链接.
  - /proc/PID/fdinfo, 一个目录，包含每个打开的文件描述符的位置和标记
  - /proc/PID/maps, 一个文本文件包含内存映射文件与块的信息。
  - /proc/PID/mem, 一个二进制图像(image)表示进程的虚拟内存, 只能通过ptrace化进程访问.
  - /proc/PID/root, 该进程所能看到的根路径的符号链接。如果没有chroot监狱，那么进程的根路径是/.
  - /proc/PID/status包含了进程的基本信息，包括运行状态、内存使用。
  - /proc/PID/task, 一个目录包含了硬链接到该进程启动的任何任务

- 系统相关
  - /proc/softirqs 系统软中断
  - /proc/crypto, 可利用的加密模块列表
  - /proc/devices, 字符设备与块设备列表，按照设备ID排序，但给出了/dev名字的主要部分
  - /proc/diskstats, 给出了每一块逻辑磁盘设备的一些信息
  - /proc/filesystems, 当前时刻内核支持的文件系统的列表
  - /proc/interrupts, /proc/iomem, /proc/ioports, /proc/irq, 设备的一些与中断、内存访问有  - 关的信息
  - /proc/kmsg, 用于跟踪读取内核消息
  - /proc/meminfo, 包含内核管理内存的一些汇总信息
  - /proc/modules, 是/proc最重要的文件之一, 包含了当前加载的内核模块列表
  - /proc/mounts, 包含了当前安装设备及安装点的符号链接
  - /proc/net/, 一个目录包含了当前网络栈的信息，特别是/proc/net/nf_conntrack列出了存在的网络连  - 接(对跟踪路由特别有用，因为iptables转发被用于重定向网络连接)
  - /proc/partitions, 一个设备号、尺寸与/dev名的列表，内核用于辨别已存在的硬盘分区
  - /proc/scsi, 给出任何通过SCSI或RAID控制器挂接的设备的信息
  - /proc/self (即/proc/PID/其中进程ID是当前进程的) 为当前进程的符号链接
  - /proc/slabinfo, Linux内核频繁使用的对象的统计信息
  - /proc/swaps, 活动交换分区的信息，如尺寸、优先级等。
  - /proc/sys，动态可配置的内核选项. 其下的目录对应与内核区域，包含了可读与可写的虚拟文件  - （virtual file）.
  - /proc/sysvipc, 包括共享内存与进程间通信 (IPC)信息
  - /proc/tty, 包含当前终端信息; /proc/tty/driver是可利用的tty类型列表，其中的每一个是该类型的  - 可用设备列表。
  - /proc/uptime, 内核启动后经过的秒数与idle模式的秒数
  - /proc/version, 包含Linux内核版本，发布号（distribution number）, 编译内核的gcc版本，其他  - 相关的版本
  - /proc/{pid}/smaps，读取某个pid进程对应的虚拟内存区间到信息
  - 其他文件依赖于不同的硬件，模块配置与内核改变
  - /proc/sys/vm/swappiness，Linux 提供了一个 /proc/sys/vm/swappiness 选项，用来调整使用 Swap 的积极程度。swappiness 的范围是 0-100，数值越大，越积极使用 Swap，也就是更倾向于回收匿名页；数值越小，越消极使用 Swap，也就是更倾向于回收文件页。

## 网络

### nslookup

- [简介] 用于分析 DNS 的解析过程

### dig

- [简介] 用于分析 DNS 的解析过程

### ping

- [简介] 用于测试服务器延时

### tcpdump

- [简介] 用于网络抓包
- [输出格式] `时间戳 协议 源地址. 源端口 > 目的地址. 目的端口 网络包详细信息`
![tcpdump-选项](image/006-tcpdump.png)
![tcpdump-表达式过滤](image/007-tcpdump.png)
