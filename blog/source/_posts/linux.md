# linux 性能调优篇

- 主要总结、收集 linux 与系统应用调优相关的技巧与知识

## 命令技巧

## 系统信息

### /etc/proc

- wiki百科: 在许多类 Unix 计算机系统中， procfs 是 进程 文件系统 (file system) 的缩写，包含一个伪文件系统（启动时动态生成的文件系统），用于通过内核访问进程信息。这个文件系统通常被挂载到 /proc 目录。由于 /proc 不是一个真正的文件系统，它也就不占用存储空间，只是占用有限的内存。

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
  - /proc/crypto, 可利用的加密模块列表
  - /proc/devices, 字符设备与块设备列表，按照设备ID排序，但给出了/dev名字的主要部分
  - /proc/diskstats, 给出了每一块逻辑磁盘设备的一些信息
  - /proc/filesystems, 当前时刻内核支持的文件系统的列表
  - /proc/interrupts, /proc/iomem, /proc/ioports, /proc/irq, 设备的一些与中断、内存访问有  - 关的信息
  - /proc/kmsg, 用于跟踪读取内核消息 [8]
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
  - 其他文件依赖于不同的硬件，模块配置与内核改变

