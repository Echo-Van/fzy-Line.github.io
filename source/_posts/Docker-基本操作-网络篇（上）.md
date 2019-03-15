---
title: Docker 基本操作-网络篇（上）
tags:
  - Docker
categories:
  - Cloud Computing
abbrlink: 31298
date: 2019-03-09 10:24:39
---



<center>Docker 网络基本操作介绍。</center>

<!--more-->

#### 网络命名空间

　　Docker 使用了 Linux 的 Namespaces 技术来进行资源隔离，如 PID Namespace 隔离进程，Mount Namespace 隔离文件系统，Network Namespace 隔离网络等。一个 Network Namespace 提供了一份独立的网络环境，包括网卡、路由、Iptable 规则等都与其他的 Network Namespace 隔离。默认情况下，一个 Docker 容器一般会分配一个独立的 Network Namespace。

#### 4 种基本的网络模式

##### Bridge 模式

　　Bridge 模式是 Docker 默认的网络设置，此模式会为每一个容器分配 Network Namespace、设置 IP 等，并将一个主机上的 Docker 容器连接到一个名为 docker0 的虚拟网桥上。在使用 docker run 命令启动容器时，也可以使用 –net=bridge 选项进行指定。

　　在该模式中，Docker 守护进程创建了一个虚拟网桥 docker0，附加在其上的任何网卡之间都能自动转发数据包。虚拟网桥的工作方式和物理交换机类似，这样主机上的所有容器就通过交换机连在了一个二层网络中。默认情况下，Docker 守护进程会创建一对对等接口，将其中一个接口设置为容器的 eth0 接口，另一个接口放置在宿主机的命名空间中，从而将宿主机上的所有容器都连接到这个内部网络上。同时，守护进程还会从网桥的私有地址空间中分配一个  IP地址和子网给该容器。

　　Docker 会从 RFC1918 所定义的私有IP网段中，选择一个和宿主机不同的IP地址和子网分配给 docker0，连接到网桥 docker0 的容器就从这个子网中选择一个未占用的 IP 使用。一般 Docker 会使用 172.17.0.0/16 这个网段，并将 172.17.0.1/16 分配给 docker0 网桥。

![9-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/3/9-1.png)

　　Bridge 模式可以解决同一主机启动多个容器容易引起端口冲突的问题，但是 iptable 的配置比较繁琐，性能也在数据包虚拟网卡与物理网卡的转发中散失，同时 NAT 机制导致无法使用容器 IP 进行跨服务器通讯。因此，Bridge 模式可以去掉 NAT，即把宿主机的 IP 从物理网卡上移除，直接配置到网桥上去，并且使用静态的 IP 分配策略。



![9-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/3/9-2.png)

　　该改进的好处是 Docker 的 IP 可以直接暴露到交换机上，其中去 NAT 的 Bridge 模式需要在宿主机上禁用 iptables 和 ip_forward，以及禁用相关的内核模块，以避免网络流量毛刺风暴问题。

##### Host 模式

　　如前所述，Docker 使用了 Linux 的 Namespaces 技术来进行资源隔离，一个 Docker 容器一般会分配一个独立的 Network Namespace。但如果启动容器的时候使用 host 模式，那么这个容器将不会获得一个独立的 Network Namespace，而是和宿主机共用一个 Network Namespace。容器将不会虚拟出自己的网卡，配置自己的 IP 等，而是使用宿主机的 IP 和端口。

![9-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/3/9-3.png)

　　在启动容器时加入 `--net=host` 参数就可以启用 Host 模式。Host 模式存在的主要缺点时：因为它是使用宿主机的 IP 和端口，如果在一台机器启动了多个相同的容器，这样极有可能产生端口冲突。这种场景下，Host 模式就不适用了。

##### Container 模式

　　Container 模式指定新创建的容器和已经存在的一个容器共享一个Network Namespace，而不是和宿主机共享。新创建的容器不会创建自己的网卡，配置自己的 IP，而是和一个指定的容器共享 IP、端口范围等。同样，两个容器除了网络方面，其他的如文件系统、进程列表等还是隔离的。两个容器除了网络方面，其他的如文件系统、进程列表等还是隔离的。两个容器的进程可以通过 lo 网卡设备通信。在启动容器时加入 `--net=container` 参数就可以启用 Host 模式。

##### None 模式

　　不为容器配置任何网络功能，容器只能使用127.0.0.1的本机网络。在启动容器时加入 `--net=none` 参数就可以启用 Host 模式。在该模式下，Docker容器仅有lo环回接口，在容器启动后仍然可以手动配置网络。

　　该模式下容器是封闭的，封闭意味着隔离，一些对安全性要求高并且不需要联网的应用可以使用该模式。比如某个容器的唯一用途是生成随机密码，就可以使用该模式，避免密码被窃取。

#### 自定义网络

　　Docker 允许我们创建 3 种类型的自定义网络，Bridge，Overlay，Macvlan。这里只对这几种网络进行简单介绍，后续再进行详细介绍。

- Bridge网络模式，可以根据需要定制自己的虚拟网桥。

- Overlay 网络模式，在多个 Docker daemon 主机之间穿件一个分布式的网络，该网络（overlay）位于docker 主机层次之上，允许容器（同一集群服务的容器）之间加密通讯，因此，Docker 需要处理每一个主机（docker daemon）和每个分布的容器之间的包路由。
- Macvlan 本身是 Linxu 的内核模块，本质上是一种网卡虚拟化技术。其功能是允许在同一个物理网卡上虚拟出多个网卡，通过不同的 MAC 地址在数据链路层进行网络数据的转发，一块网卡上配置多个 MAC 地址（即多个 interface），每个 interface 可以配置自己的 IP，Docker 的 Macvlan 网络实际上就是使用了 Linux 提供的 Macvlan 驱动。