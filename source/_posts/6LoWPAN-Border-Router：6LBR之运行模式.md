---
title: 6LoWPAN Border Router：6LBR之运行模式
tags: '［IoT,6LBR,6LoWPAN］'
categories:
  - IoT
  - 6LoWPAN
abbrlink: 12975
date: 2017-03-16 23:22:10
---


　　　　6LBR 系列博文之（一） - 6LBR 运行模式。

<!--more-->

#### 概述

　　6LBR可以在三种类别的模式中运行：网桥，路由器和透明网桥。这三个类别又被细分为以下模式：

- Bridge

    - SmartBridge

- Router

    - Router

    - NDP-Router

    - 6LR

    - RPL-Root

- Transparent Bridge

    - RPL-Replay

    - FullTransparentBridge

#### 网桥

　　在网桥模式中，只是实现了 802.15.4 接口和以太网接口的桥接，即根据链路层的地址进行网络数据包的转发。在网桥模式中，6LBR 又可分为智能网桥模式和透明网桥模式。

![bridge](https://github.com/cetic/6lbr/wiki/images/bridge-mode-highlevel-large.png)

#### 路由器

　　路由器模式能够实现 IPv6 网络和 6LoWPAN 网络之间真正的路由功能，它将无线传感器网络当作一个独立的子网，因此以太网和无线网的 IPv6 地址前缀不相同，以 6LBR 作为根节点的 RPL 实例管理整个无线传感器网络。

![router](https://github.com/cetic/6lbr/wiki/images/router-mode-highlevel-large.png)

#### 模式的详细介绍

##### 智能网桥模式

　　在这种模式下，6LBR充当智能桥，允许将标准的基于IPv6的网络与基于RPL的WSN Mesh网格互连。智能网桥在以太网端充当NDP代理并且使用NDP参数配置WSN Mesh网络。源和目地MAC地址被转换，系统能够解析数据包的源 MAC 地址和目的 MAC 地址，ICMPv6 包所包含的地址也会被解析出来。智能网桥模式允许你：

- 将WSN Mesh网络无缝集成到现有的基于NDP的IPv6网络中，智能网桥将使用NDP提供的配置来相应地设置WSN网格。

- 将多个WSN Mesh网络与自己DODAG聚合到一个虚拟的IPv6子网。支持节点移动性，在两个WSN重叠的情况下，如果一个节点获得更好的链路，它可以从一个WSN切换到另一个，如从虚拟IPv6子网看到的，由于NDP代理，该交换机将几乎不可见。

![smartbridge](https://github.com/cetic/6lbr/wiki/images/smartbridge-mode-details-large.png)

##### 路由模式

　　在这种模式下，6LBR作为一个完全成熟的IPv6路由器，互连两个IPv6子网。WSN子网由RPL协议管理，以太网子网由IPv6 NDP管理。在这种模式下，6LBR通过包过滤器模块为Contiki提供了一个虚拟的第二接口。此模式更像是以太网和6Lowpan RPL之间的网关。来自RPL侧的传出报文的源地址将更新为eth_ip_local_addr。

在路由模式你可以：

- 将WSN网格隔离到其自己的子网中，因此可以清楚地标识WSN节点。

- ...

**注意：前缀切换能力支持跨不同WSN子网的节点移动性，在这种情况下，节点将根据新WSN的前缀获得新地址。**

![router](https://github.com/cetic/6lbr/wiki/images/router-mode-details-large.png)

##### 透明网桥模式

　　在这些模式下，6LBR充当独立网桥，提供基本的交换功能。所有在以太网接口上定位到802.15.4接口的传入包或者传入的组播包被转发到WSN段。相反的，所有针对以太网接口的传入数据包或802.15.4接口上的传入组播数据包都将转发到以太网段。6LBR有自己的地址并作为主机。源和目标MAC地址被转换，ICMPv6数据包中存在的地址也被转换。

在透明桥接模式下你可以：

- 聚合子WSN网格合并为一个全局DODAG，由外部RPL根节点管理（使用RPL中继时）。

- 使用NDP桥接一个IPv6网络的一跳网格（当使用FullTransparentBridge时）。

- 使用IPv6网络桥接静态路由网格（使用FullTransparentBridge时）。

- ...

![transparentbridge](https://github.com/cetic/6lbr/wiki/images/transparentbridge-mode-details-large.png)


**注意，我们故意省略标记控制流量的类型，因为RPL和NDP都在可能的用例中提及。**

#### 其他模式

　　以下三种模式在6lbr的官方文档中也未做出说明，有待进一步的工作。

- NDP-Router

- RPL-Root

- 6LR


　　本文翻译自 6LBR 官方文档：[https://github.com/cetic/6lbr/wiki/6LBR-Modes](https://github.com/cetic/6lbr/wiki/6LBR-Modes)，向优秀的 CETIC-6LBR 项目致敬！
