---
title: 物联网操作系统：Contiki
tags: 
  - IoT
  - Contiki
categories:
  - IoT
  - OS
abbrlink: 41588
date: 2017-02-13 23:34:59
---

　　Contiki：面向物联网的开源操作系统。

<!--more-->

#### Contiki 简介

![12-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/13-3.jpg)

　　Contiki 是一个开源的、高度可移植的、支持网络的多任务操作系统，由瑞典计算机科学学院的 Adam Dunkels 博士开发。Contiki 完全采用 C 语言开发，对硬件的要求极低，典型的配置下 Contiki 只占用约 2K bytes 的 RAM 以及 40K bytes 的 Flash 存储器，目前已经移植到 8051 单片机 MSP430，AVR，ARM，PC 机等硬件平台上。

　　Contiki 支持 IPv4/IPv6 通信，提供了 uIPv6 协议栈、IPv4 协议栈（uIP），支持 TCP/UDP，还提供了线程、定时器、文件系统等功能。Contiki 操作系统是基于事件驱动的操作系统，在此内核上，应用程序可以在运行时动态加载，非常灵活。

　　Contiki 实现了一种轻量级的名为 protothread 的线程模型，形式上类似于传统线程的编程风格，该模型中多个线程共享同一个任务栈，线程切换只有 2 个字节的开销。由于 protothread 线程模型和事件驱动机制是整个 Contiki 系统的运行核心。

　　官网：[http://www.contiki-os.org/index.html](http://www.contiki-os.org/index.html)

　　Github地址：[https://github.com/contiki-os/contiki](https://github.com/contiki-os/contiki)

#### Contiki 配置准备

##### 下载 Instant Contiki

　　Instant Contiki 是基于 Ubuntu 的 Contiki 开发环境。它包含 Contiki 需要的所有工具和编译器。下载地址：[https://sourceforge.net/projects/contiki/files/Instant%20Contiki/](https://sourceforge.net/projects/contiki/files/Instant%20Contiki/) 


##### 安装 VMWare

　　可以安装 VMWare workstation 也可以安装 VMware player。参考以下教程：

　　[如何安装VMware player虚拟机教程 超级详细](http://jingyan.baidu.com/article/4d58d54129e1cb9dd4e9c09f.html)

　　[vmware workstation 12 pro 虚拟机安装系统教程](http://jingyan.baidu.com/article/86fae346ce751b3c48121a6d.html)

##### 打开 Instant Contiki

　　使用 VMWare Player 打开 Instant Contiki，然后登录到该系统，密码为：user。

![12-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/13-1.png)

#### Contiki系统目录结构

![12-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/13-2.png)

- apps：放置 Contiki 提供的应用，例如 ftp、shell、http server 等等，在项目程序开发过程中可以直接使用。使用这些应用程序的方式为，在项目的 Makefile 中，定义 APPS = [应用程序名称]。在以后的示例中会具体看到如何使用 apps。

- core：放置 Contiki 的核心内容，调度(sys)，网络协议栈(net)，文件系统(cfs)，驱动的抽象层(dev)等等。

- cpu：cpu 目录下是 Contiki 目前支持的微处理器，例如 arm、avr、msp430 等等。如果需要支持新的微处理器，可以在这里添加相应的源代码。

- platform：platform 目录下是 Contiki 支持的硬件平台，例如 mx231cc、micaz、sky、win32 等等。Contiki 的平台移植主要在这个目录下完成。这一部分的代码与相应的硬件平台相关。

- examples：放置对应平台开发的示例程序。

- doc：doc 目录是 Contiki 帮助文档目录，对 Contiki 应用程序开发很有参考价值。使用前需要先用 Doxygen 进行编译。

- tools：tools 目录下是开发过程中常用的一些工具，例如 CFS 相关的 makefsdata、网络相关的 tunslip、模拟器 cooja 和 mspsim 等等。

　　**其中移植主要修改的是三个目录：**

- cpu：添加芯片。

- platform：添加平台。

- examples：添加应用。

#### 示例分析

　　先来一个国际惯例：Hello World 程序。

　　Contiki 程序开发是以进程的方式实现，创建一个进程需要进行声明和定义。PROCESS(process_name, "process description") 宏用于声明一个进程；PROCESS_THREAD(process_name, event, data) 宏用于定义进程执行主体。

　　进程执行主体代码中，必须以 PROCESS_BEGIN() 宏开始，以 PROCESS_END() 宏结束。此外，在进程中不能使用 switch 语句，慎重使用局部变量。

　　如果进程需要在系统启动时被自动执行，则可以使用 AUTOSTART_PROCESSES(&process_name) 宏。该宏可以指定多个进程，如 AUTOSTART_PROCESSES(&process_1, &process_2)，表示 process_1 和 process_2 都会在系统启动时被启动。

　　打开 /contiki-3.0/examples/hello-world/ 目录下的 hello-world.c：

```c
#include "contiki.h"

#include <stdio.h> /* For printf() */
/*---------------------------------------------------------------------------*/
/* 声明一个名为hello_world_process进程 */
PROCESS(hello_world_process, "Hello world process");
/* 这个进程需要自动启动，即当节点启动时启动本进程 */
AUTOSTART_PROCESSES(&hello_world_process);
/*---------------------------------------------------------------------------*/
/* hello_world_process进程的主体部分 */
PROCESS_THREAD(hello_world_process, ev, data)
{
  /* 所有的进程开始执行前都必须要有这条语句 */
  PROCESS_BEGIN();

  printf("Hello, world\n");

  /* 所有的进程结束时都必须要有这条语句 */
  PROCESS_END();
}

```

　　打开 /contiki-3.0/examples/hello-world/ 目录下的 Makefile 文件。

```c
/* 项目名称（主文件名称） */
CONTIKI_PROJECT = hello-world
all: $(CONTIKI_PROJECT)
/* Contiki源文件根目录，根据您的实际情况修改 */
CONTIKI = ../..
/* 包含Contiki的Makefile，以实现整个Contiki系统的编译 */
include $(CONTIKI)/Makefile.include
```

#### 编译项目

　　在控制台 /Shell 中进入 helloworld 项目目录，运行如下命令：

```shell
$ make TARGET=native
```

　　编译成功后，项目目录下就会生成 hello-world.[目标平台] 的目标文件，如 hello-world.native。如果您使用的是 Linux 操作系统，可以运行如下命令查看 Contiki 程序运行结果：

```shell
$ ./hello-world.native
```

　　运行结果如下所示：

```
Starting Contiki
Hello world :)
```
