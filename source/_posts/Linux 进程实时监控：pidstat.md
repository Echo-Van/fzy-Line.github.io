---
title: Linux 进程实时监控：pidstat
tags:
  - Linux
  - pidstat
categories: Linux
abbrlink: 48302
date: 2017-10-26 09:54:23
---

　　pidstat 主要用于监控全部或指定进程占用系统资源的情况，如 CPU，内存、设备 IO、任务切换、线程等。

<!--more-->

#### pidstat安装

　　要使用 pidstat 需要安装 Sysstat，它是一个工具集，包括 sar、pidstat、iostat、mpstat、sadf、sadc。

```shell
$ sudo apt-get install sysstat
```

　　pidstat 首次运行时显示自系统启动开始的各项统计信息，之后运行 pidstat 将显示自上次运行该命令以后的统计信息。用户可以通过指定统计的次数和时间来获得所需的统计信息。

#### 基本命令

　　用户手册：[http://sebastien.godard.pagesperso-orange.fr/man_pidstat.html](http://sebastien.godard.pagesperso-orange.fr/man_pidstat.html)

```
Usage: pidstat [ options ] [ <interval> [ <count> ] ]
Options are:
[ -d ] [ -h ] [ -I ] [ -l ] [ -R ] [ -r ] [ -s ] [ -t ] [ -U [ <username> ] ]
[ -u ] [ -V ] [ -v ] [ -w ] [ -C <command> ] [ -G <process_name> ]
[ -p { <pid> [,...] | SELF | ALL } ] [ -T { TASK | CHILD | ALL } ]
```

##### 指定采样周期和采样次数

　　pidstat 命令指定采样周期和采样次数，例如以 2 秒为采样周期，输出 10 次 CPU 使用统计信息：

```shell
$ pidstat 2 10
```

##### -p 参数

```
-p { pid [,...] | SELF | ALL } #指定进程显示其报告
```

　　选择要报告统计信息的任务（进程）。pid 是进程标识号。 SELF 关键字表示要为 pidstat 进程本身报告统计信息，而 ALL 关键字表示要为系统管理的所有任务报告统计信息。SELF 和 ALL 可不指定，如下：

```shell
$ pidstat -p 进程号
```

　　可使用以下命令获得进程号，以下命令会列出所有进程的进程号：

```shell
$ ps -e
```

　　也可以通过 top 命令或者直接查看某个服务的状态得到该服务涉及的进程。

##### -u参数

　　使用 -u 选项，pidstat 将显示各活动进程的 CPU 使用统计，执行 ”pidstat -u” 与单独执行 ”pidstat” 的效果一样。

```shell
$ pidstat
or
$ pidstat -u
```

![26-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/10/26-1.png)

```
- UID   # 正在监视的任务的真实用户识别号
- USER  # 正在监视的任务的真实用户名
- PID   # 被监视任务的识别号
- %usr  # 在用户级（应用程序）执行任务时使用的CPU的百分比，有或没有优先级。请注意，此字段不包括运行虚拟处理器的时间
- %system   # 在系统级别（内核）执行任务时CPU占用的百分比
- %guest    # 虚拟机中任务占用的CPU的百分比（运行虚拟处理器）
- %CPU  # 该任务使用的CPU时间的总百分比
- CPU   # 处理器号，任务被哪个处理器处理
- Command   # 任务的命令名
```

##### -r参数

　　使用 -u 选项，pidstat 将显示各活动进程的页面故障和内存利用率。

```shell
$ pidstat -r
```

![26-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/10/26-2.png)

```
- UID   # 正在监视的任务的真实用户识别号
- USER  # 正在监视的任务的真实用户名
- PID   # 被监视任务的识别号
- minflt/s  # 每秒次缺页错误次数(minor page faults)，次缺页错误次数意即虚拟内存地址映射成物理内存地址产生的page fault次数
- majflt/s  # 每秒主缺页错误次数(major page faults)，当虚拟内存地址映射成物理内存地址时，相应的page在swap中，这样的page fault为major page fault，一般在内存使用紧张时产生
- VSZ   # 该进程使用的虚拟内存(以kB为单位)
- RSS   # 该进程使用的物理内存(以kB为单位)
- %MEM  # 当前任务使用的有效内存的百分比
- Command   # 任务的命令名
```


##### -d参数

　　使用 -d 选项，pidstat 将将显示各活动进程的 I/O 统计信息（内核 2.6.20 及更高版本）。

```shell
$ pidstat -d
```

![26-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/10/26-3.png)

```
- UID   # 正在监视的任务的真实用户识别号
- USER  # 正在监视的任务的真实用户名
- PID   # 被监视任务的识别号
- kB_rd/s   # 每秒此进程从磁盘读取的千字节数
- kB_wr/s   # 此进程已经或者将要写入磁盘的每秒千字节数
- kB_ccwr/s # 由任务取消的写入磁盘的千字节数
- iodelay   # 阻止正在监视的任务的I/O延迟，以时钟滴答测量
- Command   # 命令的名字
```

##### 其他参数

```
-h  # 显示所有的活动的任务
-I  # 在SMP环境，指出任务的CPU使用（等同于选项-u）应该被除于cpu的总数
-l  # 显示进程的命令名和它的参数
-T { TASK | CHILD | ALL }   # 指定必须监测的内容：TASK是默认的，单个任务的报告；CHILD：指定的进程和他们的子进程的全局报告，ALL：相当于TASK和CHILD
-s  # 堆栈的使用
-t  # 显示与所选任务相关的线程的统计数据
-w  # 报告任务切换情况
```
#### 使用示例

　　以 2 秒为采样周期，输出 5 次进程号为 1643 的页面故障和内存使用统计信息。

```shell
$ pidstat -r -p 1643 2 5
```

　　以 2 秒为采样周期，输出 5 次进程号为 1643 的页面故障和内存使用统计信息以及 CPU 使用率。

```shell
$ pidstat -u -r -p 1643 2 10
```

　　以 2 秒为采样周期，输出 10 次系统中所有任务的子进程的页面错误统计信息。只显示具有非零统计值的子进程。

```shell
$ pidstat -T CHILD -r 2 10
```

#### 保存数据

　　重定向输出即可，例如，每隔两秒记录 1 次，一共 10 次，并输出到 data.txt 文件。

```shell
$ pidstat 2 10 > data.txt
```
