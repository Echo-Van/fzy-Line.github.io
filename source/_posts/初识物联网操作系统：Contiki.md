---
title: 初识物联网操作系统：Contiki
tags: '［IoT,Contiki］'
categories:
  - IoT
  - Contiki
abbrlink: 41588
date: 2017-02-13 23:34:59
---

　　Contiki：面向物联网的开源操作系统。

<!--more-->

#### Contiki简介

![12-3](http://ohe7ixo05.bkt.clouddn.com/2017/2/13-3.jpg)

Contiki是一个开源的、高度可移植的、支持网络的多任务操作系统，由瑞典计算机科学学院的Adam Dunkels博士开发。

Contiki完全采用C语言开发，对硬件的要求极低，典型的配置下Contiki只占用约2Kbytes的RAM以及40Kbytes的Flash存储器，目前已经移植到8051单片机MSP430, AVR, ARM, PC机等硬件平台上。

Contiki支持IPv4/IPv6通信，提供了uIPv6协议栈、IPv4协议栈（uIP），支持TCP/UDP，还提供了线程、定时器、文件系统等功能。

Contiki操作系统是基于事件驱动的操作系统，在此内核上，应用程序可以在运行时动态加载，非常灵活。

Contiki实现了一种轻量级的名为protothread的线程模型，形式上类似于传统线程的编程风格，该模型中多个线程共享同一个任务栈，线程切换只有2个字节的开销。由于protothread线程模型和事件驱动机制是整个Contiki系统的运行核心。

官网：[http://www.contiki-os.org/index.html](http://www.contiki-os.org/index.html)

Github地址：[https://github.com/contiki-os/contiki](https://github.com/contiki-os/contiki)

#### Contiki配置准备

##### 下载instant Contiki

Instant Contiki是基于Ubuntu的Contiki开发环境。它包含Contiki需要的所有工具和编译器。

[https://sourceforge.net/projects/contiki/files/Instant%20Contiki/](https://sourceforge.net/projects/contiki/files/Instant%20Contiki/)


##### 安装VMWare

可以安装VMWare workstation也可以打开VMware player.

[如何安装VMware player虚拟机教程 超级详细](http://jingyan.baidu.com/article/4d58d54129e1cb9dd4e9c09f.html)

[vmware workstation 12 pro 虚拟机安装系统教程](http://jingyan.baidu.com/article/86fae346ce751b3c48121a6d.html)

##### 打开instant Contiki

使用VMWare Player打开instant Contiki，然后登录到该系统，密码为：user。

![12-1](http://ohe7ixo05.bkt.clouddn.com/2017/2/13-1.png)

#### Contiki系统目录结构

![12-2](http://ohe7ixo05.bkt.clouddn.com/2017/2/13-2.png)

apps: 放置contiki提供的应用，例如ftp、shell、http server等等，在项目程序开发过程中可以直接使用。使用这些应用程序的方式为，在项目的Makefile中，定义APPS = [应用程序名称]。在以后的示例中会具体看到如何使用apps。

core: 放置contiki的核心内容，调度(sys)，网络协议栈(net)，文件系统(cfs)，驱动的抽象层(dev)等等。

cpu：cpu目录下是Contiki目前支持的微处理器，例如arm、avr、msp430等等。如果需要支持新的微处理器，可以在这里添加相应的源代码。

platform：platform目录下是Contiki支持的硬件平台，例如mx231cc、micaz、sky、win32等等。Contiki的平台移植主要在这个目录下完成。这一部分的代码与相应的硬件平台相关。

examples：放置对应平台开发的示例程序。

doc: doc目录是Contiki帮助文档目录，对Contiki应用程序开发很有参考价值。使用前需要先用Doxygen进行编译。

tools: tools目录下是开发过程中常用的一些工具，例如CFS相关的makefsdata、网络相关的tunslip、模拟器cooja和mspsim等等。

**其中移植主要修改的是三个目录：**

cpu: 添加芯片

platform: 添加平台

examples: 添加应用

#### 示例分析

国际惯例：Hello World程序

Contiki程序开发是以进程的方式实现，创建一个进程需要进行声明和定义。PROCESS(process_name, "process description")宏用于声明一个进程；PROCESS_THREAD(process_name, event, data)宏用于定义进程执行主体。

进程执行主体代码中，必须以PROCESS_BEGIN()宏开始，以PROCESS_END()宏结束。此外，在进程中不能使用switch语句，慎重使用局部变量。

如果进程需要在系统启动时被自动执行，则可以使用AUTOSTART_PROCESSES(&process_name)宏。该宏可以指定多个进程，如AUTOSTART_PROCESSES(&process_1, &process_2)，表示process_1和process_2都会在系统启动时被启动。

打开/contiki-3.0/examples/hello-world/目录下的hello-world.c：

```
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

打开/contiki-3.0/examples/hello-world/目录下的Makefile文件。

```
/* 项目名称（主文件名称） */
CONTIKI_PROJECT = hello-world
all: $(CONTIKI_PROJECT)
/* Contiki源文件根目录，根据您的实际情况修改 */
CONTIKI = ../..
/* 包含Contiki的Makefile，以实现整个Contiki系统的编译 */
include $(CONTIKI)/Makefile.include
```

#### 编译项目

在控制台/Shell中进入helloworld项目目录，运行如下命令：

```
make TARGET=native
```

编译成功后，项目目录下就会生成hello-world.[目标平台]的目标文件，如hello-world.native。如果您使用的是Linux操作系统，可以运行如下命令查看Contiki程序运行结果：

```
./hello-world.native
```

运行结果如下所示：

```
Starting Contiki
Hello world :)
```
