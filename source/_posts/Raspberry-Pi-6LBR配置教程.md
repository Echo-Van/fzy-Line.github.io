---
title: Raspberry Pi 6LBR配置教程
tags: '［IoT,6LBR,6LoWPAN］'
categories: IoT
abbrlink: 11221
date: 2017-03-31 17:21:49
---

　　6LBR 是目前国际上较为优秀的基于 Contiki 系统的 6LoWPAN 边界路由器解决方案。和现有的其他边界路由器方案相比，6LBR 是唯一一个不需要 Linux 主机的独立边界路由器，并且能够提供IPv6/NDP 和 RPL 之间的智能互联。

　　本文介绍了如何在Raspberry Pi上配置6LBR。

<!--more-->

#### 下载安装

##### 下载6LBR

```
$ git clone https://github.com/cetic/6lbr
$ cd 6lbr
$ git submodule update --init --recursive
$ cd examples/6lbr
$ git checkout develop-1.4.1 #根据6LBR项目的版本修改版本号，目前稳定版为1.4.1
```
##### 编译6LBR

```
$ make all    #如果要使用1.4以下版本，只要把命令改为make TARGET=native all即可
$ make plugins
$ make tools
```

##### 安装6LBR

```
$ make install
$ make plugins-install
$ update-rc.d 6lbr defaults
```

　　**注意：建议安装稳定版本，低于1.4的版本有些功能好像不支持，比如NAT64，而最新版本则亲测不稳定。**

#### 6LBR配置

　　默认情况下6LBR是没有配置文件的，只是在/etc/6lbr/目录下给了几个例子，我们需要自己新建conf.d文件。

##### 配置6LBR模式

　　配置为路由器模式，在/etc/6lbr/conf.d文件夹下：

```
MODE=ROUTER
```

##### 接口配置

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

#### SLIP-RADIO配置

##### 接线说明

　　使用USB转TTL模块，将Raspberry Pi与SLIP-Radio（即一个contiki节点，使用cc538dk）连接起来。


##### 编译程序


```
$ cd 6lbr/example/
$ make TARGET=cc2538dk
```

　　得到bin或者hex文件，用于下一步的烧录。

##### 烧写程序

　　cc2538dk程序烧写步骤请参考博客：[Contiki CC2538dk 串口下载程序](https://fzy-line.github.io/2017/02/18/Contiki-CC2538dk-%E4%B8%B2%E5%8F%A3%E4%B8%8B%E8%BD%BD%E7%A8%8B%E5%BA%8F/)

#### 启动6LBR

```
$ service 6lbr start
```

#### 节点配置

　　节点我们暂时采用6LBR提供的demo进行测试，该demo位于6lbr-develop/examples/6lbr-demo，后续博客在讲解如何进行移植。

##### 编译程序

```
$ cd examples/6lbr-demo
$ make TARGET=cc2538dk
```

　　得到bin或者hex文件，用于下一步的烧录。

##### 烧写程序

　　cc2538dk程序烧写步骤请参考博客：[Contiki CC2538dk 串口下载程序](https://fzy-line.github.io/2017/02/18/Contiki-CC2538dk-%E4%B8%B2%E5%8F%A3%E4%B8%8B%E8%BD%BD%E7%A8%8B%E5%BA%8F/)


#### 效果测试

　　你需要找一台与你的树莓派在同一个局域网的电脑，将其IPv6地址设定为bbbb::101，然后打开浏览器访问bbbb::100，即可看到6LBR的配置界面。可以在网页端对网络进行各种配置，具体教程后续博客会介绍，这里不展开了。6lbr提供的demo默认都是支持RPL的，所以我们可以使用几个节点，然后组成如下的传感网络。

![31-1](http://ohe7ixo05.bkt.clouddn.com/2017/3/31-1.png)