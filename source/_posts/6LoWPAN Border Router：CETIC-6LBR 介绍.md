---
title: 6LoWPAN Border Router：CETIC-6LBR 介绍
tags:
  - 6LoWPAN
  - 6LBR
categories:
  - IoT
  - Protocol
abbrlink: 48880
date: 2017-03-12 20:14:52
---

　　CETIC-6LBR 是目前国际上较为优秀的基于 Contiki 系统的 6LoWPAN 边界路由器解决方案。和现有的其他边界路由器方案相比，6LBR 是唯一一个不需要 Linux 主机的独立边界路由器，并且能够提供 IPv6/NDP 和 RPL 之间的智能互联。

<!--more-->

#### 6LBR简介

　　6LBR 的目标是连接基于 802.15.4 和 6LoWPAN 的无线传感器网络和基于以太网的现有 IPv6 有线网络。这种连接可以在网络协议栈的多个层面上实现，首先可以在数据链路层（第二层）实现，此时 6LBR 可看作成通常所说的网桥或交换机设备；其次，也可以在网络层（第三层）实现，此时 6LBR 可看作成通常所说的路由器；最后，还可以自应用层（第七层）实现，此时 6LBR 可看作成通常所说的网关设备。

![image](https://github.com/cetic/6lbr/wiki/images/6lbr-top-medium.png)

　　6LBR 方案是在 Contiki 系统之上模拟出第二个接口，不需要对 uIP 协议栈进行大量修改，当 Contiki 系统升级时，6LBR 可以直接替换系统文件实现立即升级。而且它还实现了基于 RPL的多跳网络管理，是目前边界路由器方案中功能最强大的。

　　6LBR 搭建好之后就像我们平常使用的路由器那样会有一个 Web 界面，可以用来配置我们的边界路由器以及管理我们的 6LoWPAN 无线传感网络，功能十分强大。

　　项目地址：[https://github.com/cetic/6lbr](https://github.com/cetic/6lbr)

　　下载地址：[https://github.com/cetic/6lbr/wiki/Releases](https://github.com/cetic/6lbr/wiki/Releases)

#### 支持的硬件平台

- OpenMote
- Zolertia Ethernet IoT Gateway
- The Redwire IO
- The Redwire Econotag
- TI CC2538DK
- TI CC2650DK
- Linux hosts
- RaspberryPi
- BeagleBone

#### 开发教程

　　本人目前正在研究 6LoWPAN，将 6oWPAN 无线传感网络接入 Internet 需要实现边界路由器，而 6LBR 正好是一个不错的边界路由器方案，所以我采用 CETIC-6LBR 在 Raspberry Pi 上实现了边界路由器功能。目前，国内关于 6LBR 的资料实在是比较稀缺，特别是对于英语不太好的人来说，遇到问题也比较难找到参考资料，接下来我将会写系列博客介绍 6LBR 以及如何使用 6LBR 搭建边界路由器，也欢迎喜欢的小伙伴多多交流！
