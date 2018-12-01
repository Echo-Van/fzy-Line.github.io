---
title: 开源物联网操作系统：RIOT-OS
tags:
  - RIOT
categories:
  - IoT
  - OS
abbrlink: 7468
date: 2017-11-18 11:24:40
---

　　RIOT 是一个开源的物联网操作系统，它针对物联网场景的低功耗、资源受限等特殊要求而设计，前景很不错。

<!--more-->

#### 简介

![18-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/11/18-1.png)

　　RIOT 操作系统针对物联网场景的特殊要求而设计。这些要求包括低内存占用，高能效，实时功能，模块化和可配置的通信堆栈，并支持各种低功耗设备。

　　RIOT 基于微内核架构，这意味着它针对非常低的资源需求进行了优化，并且支持实时和多线程处理。它兼容 16/32 位 MCU 架构，还有一个本机端口可用于在 Linux 或 MacOS 上作为进程运行，从而可以使用标准开发工具，如 GNU 编译器集合，GNU 调试器，Valgrind 或 Wireshark 。

　　RIOT 具有多种功能集成，支持 C/C++ 语言，并提供 shell，加密库，各种数据结构等功能。操作系统集成了对 IPv6 或 6LoWPAN 等网络堆栈的支持，以及 UDP，TCP，RPL 和 CoAP 网络协议。操作系统还具有各种硬件的驱动程序，如传感器，无线电收发器和 MCU。

##### 支持的平台

　　RIOT 支持 ARM Cortex-M0，M3，M4 和 ARM7 架构，从而支持各种开发板，如 Arduino Due，基于 Atmel ATmega2560 MCU（例如Arduino Mega 2560）或蓝牙设备如北欧 nRF51822 SoC。

![18-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/11/18-3.png)

##### 支持的网络协议栈

　　RIOT 不仅仅支持 TCP/IP 网络协议栈，还支持 IPv6，6lowpan 等，另外，它还通过 CCN Lite 提供了对 CCN 协议的支持。

![18-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/11/18-2.png)

##### 操作系统对比

　　对比 TinyOS、Contiki、Linux，RIOT 的优势十分明显。

![18-4](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/11/18-3.png)

#### 相关资料

RIOT-OS官网：[http://www.riot-os.org/](http://www.riot-os.org/)

Github repository: [https://github.com/RIOT-OS/RIOT](https://github.com/RIOT-OS/RIOT)

CSDN博客： [http://blog.csdn.net/mx1252111/article/category/6423778](http://blog.csdn.net/mx1252111/article/category/6423778)


论文1：Will H, Schleiser K, Schiller J. A real-time kernel for wireless sensor networks employed in rescue scenarios[C]// Local Computer Networks, 2009. LCN 2009. IEEE, Conference on. IEEE, 2009:834-841. [http://ieeexplore.ieee.org/document/5355049/](http://ieeexplore.ieee.org/document/5355049/)

论文2：Baccelli E, Hahm O, Wählisch M, et al. RIOT: One OS to Rule Them All in the IoT[J]. HAL - INRIA, 2013. [https://hal.inria.fr/hal-00768685/](https://hal.inria.fr/hal-00768685/)

论文3：Baccelli E, Hahm O, GüNes M, et al. RIOT OS: Towards an OS for the Internet of Things[C]// Computer Communications Workshops. IEEE, 2013:79-80. [http://www.riot-os.org/docs/riot-infocom2013-abstract.pdf](http://www.riot-os.org/docs/riot-infocom2013-abstract.pdf)

#### 系统框架

![18-5](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/11/18-5.png)

　　RIOT 的代码库分为五组。

- 内核 (core)
- 平台特定的代码 (cpu; boards)
- 设备驱动 (drivers)
- 库和网络代码 (sys; pkg)
- 演示功能和测试的应用程序 (examples; tests)

　　此外，RIOT 还包括各种任务的脚本集合(dist)以及用于生成文档(soc)的预定义环境。

##### core

　　core 文件夹包含了 RIOT 的内核文件，包括线程管理，消息管理，关键数据结构，一些格式定义等。其中最关键的是，它包含了 RIOT 中主线程和空闲线程的创建。

##### board

　　board 文件夹中包含了 RIOT 支持的硬件平台的所有定义和实现，其中包括 ARM、TI 等公司的产品。通常，硬件平台由控制器的固定配置和一些外部设备（如传感器或无线电）组成。该文件夹的主要作用是把硬件平台编译需要的文件联系起来，这样硬件平台才能够编译，它包含有关 GPIO 引脚，MCU 时钟和器件驱动程序配置的所有方面。

##### cpu

　　cpu 文件夹包含所有特定于 CPU 的源文件。在多个 CPU 共享相同架构的情况下，实现被分为几个 CPU 特定的部分和架构部分（例如 arm7_common 和 lpc2387）。cpu 这个文件夹非常重要，前期的编程会频繁的使用到这个文件夹内的文件。

##### drivers

　　drivers 文件夹包含特定设备的所有类型的驱动程序，比如 enc28j60，dht11 等，同时它还包含了硬件平台底层驱动的头文件。

##### sys

　　sys 是一个非常重要的文件夹，里面包含了 RIOT 的精华部分，我们就很少去直接使用 cpu 文件夹的内容，而是直接使用 sys 中的一些函数，因为 cpu 文件夹中的东西是底层的，而 sys 中的应用是高层的。

　　而sys文件夹下的 net 文件夹更是重中之重，这里面包含了 RIOT 网络部分的文件，其中包括数据链路层、网络层、传输层和应用层的。因此，我们可以找到 sixlowpan，udp，rpl，border routers 等功能。RIOT 提供了强大的 gnrc 模块，在无线传输方面十分方便。

##### examples

　　examples 文件夹里面提供了几个经典的例程，这几个例程非常非常的重要，可以说只要掌握了这几个例程的功能，RIOT 的大部分功能就学会了。只要明白了 shell 命令去调试之后就可以很简单的去解析这些程序了。

##### tests

　　tests 文件夹提供了各个功能的详细测试程序。RIOT 里面包含的功能几乎都可以在这里面找到测试的实例。而且这些功能机会支持所有的硬件平台。只要按照自己选择的硬件平台去编译就能根据测试结果去辅助学习了。

##### pkg

　　pkg 文件夹提供了一些外部库驱动，比如 libcoap、openwsn 等库驱动。

##### dist、doc

　　dist 文件夹提供了一些工具，doc 文件夹提供了一些文档。
