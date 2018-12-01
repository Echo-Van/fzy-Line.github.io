---
title: 6LoWPAN Border Router：6LBR 接口配置
tags:
  - 6LoWPAN
  - 6LBR
categories:
  - IoT
  - Protocol
abbrlink: 23552
date: 2017-03-21 23:11:16
---

　　6LBR 系列博文之（二） - 6LBR 接口配置。

<!--more-->

　　注意：本文只与基于 Linux 的 6LBR 有关。

　　在 Linux 平台上，你需要将 6LBR 应用程序链接到你的 LAN 网络，为此，你有三种可能性。（为了使清晰起见，您可以假设 6LBR 是在 Linux 主机上运行的 VM）

#### 以太网直连

　　这是最简单的方法，但也是最有限的一种，您的 Linux 主机将无法直接与 6LBR 和 WSN 通信。如名称所示， 6LBR 直接使用配置的以太网接口发送和接收数据包。

![raw-ethernet](https://github.com/cetic/6lbr/wiki/images/connection/raw-ethernet.png)

　　你需要在你的 /etc/6lbr/6lbr.conf 文件中进行如下配置（我们假设你的以太网接口是 eth0）：

```
RAW_ETH=1
BRIDGE=0
DEV_ETH=eth0
```

#### 桥接模式

　　此模式需要更多配置，但是你将能够与 Linux 主机的 6LBR 通信。在这种模式下，6LBR 将创建一个虚拟以太网接口，通常为 tap0。您需要将其桥接到以太网接口，以提供连接。创建的桥接接口将替换您的以太网接口用于所有目标。

　　重要的提示：你的以太网驱动程序必须支持混杂模式，如果不能，桥将无法正常工作，你将与 6LBR 间歇性连接。 Beaglebone 的以太网驱动程序不支持混杂模式！

![bridge](https://github.com/cetic/6lbr/wiki/images/connection/bridge.png)

　　你需要在你的 /etc/6lbr/6lbr.conf 文件中进行如下配置（我们假设你的以太网接口是 eth0）：

```
RAW_ETH=0
BRIDGE=1
CREATE_BRIDGE=0
DEV_ETH=eth0
DEV_BRIDGE=br0
DEV_TAP=tap0
```

　　你还需要创建一个桥接接口 br0，在 /etc/6lbr 目录下，我们提供了两个 /etc/network/interfaces 文件的例子。例如，如果你使用 DHCP，文件的内容应该是：

```
...

iface eth0 inet static
address 0.0.0.0

auto br0
iface br0 inet dhcp
    bridge_ports eth0
    bridge_stp off
    up echo 0 > /sys/devices/virtual/net/br0/bridge/multicast_snooping
    post-up ip link set br0 address `ip link show eth0 | grep ether | awk '{print $2}'`

...

```

　　如你所见，以太网接口不再配置，它已被 br0 替换。

　　可以在 6LBR 启动时创建网桥，但是这样做的结果是，当以太网接口加入网桥时，你将丢失所有现有连接。如果你真的想要这种模式，你必须添加到你的 6lbr.conf 文件：

```
CREATE_BRIDGE=1
```

#### 路由模式

　　这种模式是最强大的，也是最复杂的。您不需要创建连接 tap0 接口和 eth0 接口的网桥，而是依靠 Linux 主机栈来在两个接口之间进行路由，在IP级使用实际路由或以太网级使用 ebtables。这只有在有多个接口或复杂路由时，或者当您的以太网驱动程序不支持混杂模式时才有用。

![router](https://github.com/cetic/6lbr/wiki/images/connection/routing.png)

　　6lbr.conf 文件的配置很简单：

```
RAW_ETH=0
BRIDGE=0
DEV_ETH=eth0
DEV_TAP=tap0
```

　　可以通过在 /etc/sysctl.conf 中添加以下两行来启用 IP 转发：

```
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding=1
```

　　为了避免在 tap0 和 eth0 接口之间有一个不必要的子网，最好使用没有前缀自动配置的 SmartBridge 模式。


#### 遇到的问题

　　使用桥接模式时，树莓派ip地址经常跳变，解决办法：

　　当接口添加到网桥时，其所有配置都将丢失。因此，当 6LBR 启动并将以太网接口添加到其网桥时，连接将丢失。解决方案是在系统引导时使用提供的接口示例文件（在 /etc/6lbr/interfaces.*.example 中）创建桥接，并在 /etc/6lbr/6lbr.conf 中设置 CREATE_BRIDGE = 0。
