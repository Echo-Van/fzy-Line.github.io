---
title: 6LoWPAN Border Router：6LBR 接口配置
date: 2017-03-21 23:11:16
tags: ［IoT,6LBR,6LoWPAN］
categories:
- IoT
- 6LoWPAN
---

　　6LBR 系列博文之（二） - 6LBR 接口配置。

<!--more-->

　　注意：本文只与基于Linux的6LBR有关。

　　在Linux平台上，你需要将6LBR应用程序链接到你的LAN网络，为此，你有三种可能性。（为了使清晰起见，您可以假设6LBR是在Linux主机上运行的VM）

#### 以太网直连

　　这是最简单的方法，但也是最有限的一种，您的Linux主机将无法直接与6LBR和WSN通信。如名称所示，6LBR直接使用配置的以太网接口发送和接收数据包。

![raw-ethernet](https://github.com/cetic/6lbr/wiki/images/connection/raw-ethernet.png)

　　你需要在你的 /etc/6lbr/6lbr.conf 文件中进行如下配置（我们假设你的以太网接口是eth0）：

```
RAW_ETH=1
BRIDGE=0
DEV_ETH=eth0
```

#### 桥接模式

　　此模式需要更多配置，但是你将能够与Linux主机的6LBR通信。在这种模式下，6LBR将创建一个虚拟以太网接口，通常为tap0。您需要将其桥接到以太网接口，以提供连接。创建的桥接接口将替换您的以太网接口用于所有目标。

　　重要的提示：你的以太网驱动程序必须支持混杂模式，如果不能，桥将无法正常工作，你将与6LBR间歇性连接。 Beaglebone的以太网驱动程序不支持混杂模式！

![bridge](https://github.com/cetic/6lbr/wiki/images/connection/bridge.png)

　　你需要在你的 /etc/6lbr/6lbr.conf 文件中进行如下配置（我们假设你的以太网接口是eth0）：

```
RAW_ETH=0
BRIDGE=1
CREATE_BRIDGE=0
DEV_ETH=eth0
DEV_BRIDGE=br0
DEV_TAP=tap0
```

　　你还需要创建一个桥接接口br0，在 /etc/6lbr 目录下，我们提供了两个/etc/network/interfaces 文件的例子。例如，如果你使用DHCP，文件的内容应该是：

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

　　如你所见，以太网接口不再配置，它已被br0替换。

　　可以在6LBR启动时创建网桥，但是这样做的结果是，当以太网接口加入网桥时，你将丢失所有现有连接。如果你真的想要这种模式，你必须添加到你的6lbr.conf文件：

```
CREATE_BRIDGE=1
```

#### 路由模式

　　这种模式是最强大的，也是最复杂的。您不需要创建连接tap0接口和et0接口的网桥，而是依靠Linux主机栈来在两个接口之间进行路由，在IP级使用实际路由或以太网级使用ebtables。这只有在有多个接口或复杂路由时，或者当您的以太网驱动程序不支持混杂模式时才有用。

![router](https://github.com/cetic/6lbr/wiki/images/connection/routing.png)

　　6lbr.conf 文件的配置很简单：

```
RAW_ETH=0
BRIDGE=0
DEV_ETH=eth0
DEV_TAP=tap0
```

　　可以通过在/etc/sysctl.conf中添加以下两行来启用IP转发：

```
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding=1
```

　　为了避免在tap0和eth0接口之间有一个不必要的子网，最好使用没有前缀自动配置的SmartBridge模式。


#### 遇到的问题

　　使用桥接模式时，树莓派ip地址经常跳变，解决办法：

　　当接口添加到网桥时，其所有配置都将丢失。因此，当6LBR启动并将以太网接口添加到其网桥时，连接将丢失。解决方案是在系统引导时使用提供的接口示例文件（在/etc/6lbr/interfaces.*.example中）创建桥接，并在/etc/6lbr/6lbr.conf中设置CREATE_BRIDGE = 0。
