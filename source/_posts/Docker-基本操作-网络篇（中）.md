---
title: Docker-基本操作-网络篇（中）
tags:
  - Docker
categories:
  - Cloud Computing
abbrlink: 12879
date: 2019-03-12 10:59:17
---

<center>Docker 网络基本操作介绍。</center>

<!--more-->

#### IPtables

　　Linux 的防火墙由 Netfilter 和 Iptables 组成。用户空间的 Iptables 制定防火墙规则，内核空间的 Netfilter 实现防火墙功能。Netfilter （内核空间）位于Linux内核中的包过滤防火墙功能体系，称为 Linux 防火墙的“内核态”。 Iptables （用户空间）位于 /sbin/iptables，是用来管理防火墙的命令的工具，为防火墙体系提供过滤规则/策略，决定如何过滤或处理到达防火墙主机的数据包，称为 Linux 防火墙的“用户态”。

##### 白名单和黑名单

　　制作防火墙规则通常有两种基本策略。**一是黑名单策略；二是白名单策略。**

- 黑名单策略指没有被拒绝的流量都可以通过，这种策略下管理员必须针对每一种新出现的攻击，制定新的规则，因此不推荐。
- 白名单策略指没有被允许的流量都要拒绝，这种策略比较保守，根据需要逐渐开放，目前一般都采用白名单策略，推荐。

##### 四表五链

　　Iptables 有四表五链(其实有五表，是后来加进来的)，四表分别是下图的的 `raw，mangle，nat，filter` 表。五链分别是 `PREROUTING，INPUT，OUTPUT，FORWARD，POSTROUTING` 链。表决定了数据报文处理的方式，而链则决定了数据报文的流经哪些位置。

![12-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/3/12-1.png)

- **五链：**
  - PREROUTING：数据包进入路由表之前；
  - INPUT：通过路由表后目的地为本机；
  - FORWARD：通过路由表后，目的地不为本机；
  - OUTPUT：由本机产生，向外转发；
  - POSTROUTIONG：发送到网卡接口之前。

- **四表：**
  - filter 表：负责过滤功能，防火墙；内核模块：iptables_filter
  - nat 表：network address translation，网络地址转换功能；内核模块：iptable_nat
  - mangle 表：拆解报文，做出修改，并重新封装的功能；iptable_mangle
  - raw 表：关闭 nat 表上启用的连接追踪机制；iptable_raw

##### 处理流程

　　处理流程下图所示，例如，制定一个filter表的规则，filter表决定是否放行数据包通过，那如果通过，则必须经由INPUT链流入数据包，INPUT链是处理入站数据的，如果没问题，继续放行到用户空间，再经由OUTPUT链将数据包流出。而对于 NAT 表的规则，NAT 表主要实现转发功能，数据包先经由PREROUTING链进行路由选择，选择好路线后再经由FORWARD链转发数据，然后再进行一个路由选择，最后由POSTROUTING链流出数据。

![12-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/3/12-2.png)

##### Iptables 语法

　　语法格式如下：

```shell
$ iptables [-t 表名] 选项 [链名] [条件] [-j 控制类型]
```

　　参数说明：

- `-P`：设置默认策略：iptables；
- `-P`：INPUT (DROP|ACCEPT)；
- `-F`：清空规则链；
- `-L`：查看规则链；
- `-A：在规则链的末尾加入新规则；
- `-I num`：在规则链的头部加入新规则；
- `-D num`：删除某一条规则；
- `-s`：匹配来源地址 IP/MASK，加叹号 "!" 表示除这个 IP 外；
- `-d`：匹配目标地址；
- `-i`：网卡名称 匹配从这块网卡流入的数据；
- `-o`：网卡名称 匹配从这块网卡流出的数据；
- `-p`：匹配协议,如tcp，udp，icmp；
- `--dport num`：匹配目标端口号；
- `--sport num`：匹配来源端口号。

##### SNAT、DNAT 与 MASQUERADE

- **SNAT（source network address translation，源地址目标转换）**

　　局域网内的主机都配置了内网 IP，在访问外部网络的时候，路由器将数据包的报头中的源地址替换成路由器的 IP 。当外部网络的服务器比如网站 Web 服务器接到访问请求的时候，他的日志记录下来的是路由器的 IP 地址，而不是 主机的内网 IP 。因为，服务器收到的数据包的报头的“源地址”部分已经被替换。

- **DNAT（destination network address translation，目标网络地址转换）**

　　当 Web 服务器放在内网，配置内网 IP ，前端有个防火墙，配置公网 IP，客户端使用公网 IP 来访问这个网站。当访问的时候，客户端发出一个数据包，这个数据包的报头里边，目标地址写的是防火墙的公网 IP 。防火墙会把这个数据包的报头改写一次，将目标地址改写成 Web 服务器的内网 IP ，然后再把这个数据包发送到内网的Web 服务器上这样，数据包就可以穿透防火墙，并从公网 IP 变成了一个对内网地址的访问。

- **MASQUERADE（地址伪装）**

　　MASQUERADE 是 SNAT 的一个特例，因为它在 Iptables 中有着和 SNAT 相近的效果。SNAT 是指在数据包从网卡发送出去的时候，把数据包中的源地址部分替换为指定的 IP，这样，接收方就认为数据包的来源是被替换的那个 IP 的主机。MASQUERADE是用发送数据的网卡上的IP来替换源IP，因此，对于那些IP不固定的场合，比如拨号网络或者通过 dhcp 分配 IP 的情况下，就得用 MASQUERADE。

#### 容器访问控制

##### 容器访问外部网络 

　　容器要想访问外部网络，需要本地系统的转发支持。在 Linux 系统中，检查转发是否打开，即`net.ipv4.ip_forward` 是否等于 0。如果为 0，说明没有开启转发，则需要手动打开。

```shell
$sysctl net.ipv4.ip_forward
net.ipv4.ip_forward = 1
```

　　也可以在启动 Docker 服务的时候设定 `--ip-forward=true` , Docker 就会自动设定系统的 ip_forward 参数为 1。 

##### 容器之间访问 

　　容器之间相互访问，需要两方面的支持：

- 容器的网络拓扑是否已经互联。默认情况下，所有容器都会被连接到 docker0 网桥上。
- 本地系统的防火墙软件 -- iptables 是否允许通过。 

　　在同一宿主机下，Docker 的容器是通过虚拟网桥来进行连接的。默认情况下，在同一宿主机中运行的不同容器之间是允许网络互通的。因为，当启动 Docker 服务时候，默认会添加一条转发策略到 iptables 的 FORWARD 链上。策略为通过（ACCEPT ） 还是禁止（DROP ） 取决于配置 `--icc=true`  还是 `--icc=false` 。因为缺省值为  `--icc=true`  ，所以默认是允许容器间互通的。

　　如果为了安全考虑，修改 `vim /etc/default/docker`，在末尾添加配置 `DOCKER_OPTS="--icc=false"` 来禁止它。需要重启 Docker 的服务 `sudo service docker restart`。这样就会拒绝所有容器间互联。

　　另外，也可以允许特定容器间的连接。在 Docker 守护进程的启动选项中设置 `--icc=false` 和 `--iptables=true` ，然后在容器启动时使用 `--link ` 选项来与特定容器进行连接。Docker 利用 iptables 中的机制，在 `--icc=false` 时，阻断所有的 Docker 容器间的访问，仅仅运行利用 link 选项配置的容器进行相互的访问。

#### 端口映射

　　默认情况下，容器可以主动访问到外部网络的连接，但是外部网络无法访问到容器。 

##### 容器访问外部

　　容器所有到外部网络的连接，源地址都会被 NAT 成本地系统的 IP 地址。这是使用 iptables 的源地址伪装操作实现的。 例如：

```shell
root@iZwz96uyro861qckgz89ljZ:~# iptables -t nat -nL
......
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0     
```

　　上述规则将所有源地址在 `172.17.0.0/16` 网段，目标地址为其他网段（外部网络） 的流量动态伪装为从系统网卡发出。如前一节所述，这里使用的是 MASQUERADE（地址伪装），MASQUERADE 跟传统 SNAT 的好处是它能动态从网卡获取地址。

##### 外部访问容器

　　容器允许外部访问，可以在 `docker run` 时候通过 `-p` 或 `-P` 参数来启用。但是，不管用那种办法，其实也是在本地的 iptables 的 nat 表中添加相应的规则。例如：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker run -p 80:80 --name=web -d nginx
bbe79958143a510ef5aca1b37770e5e19549d7f0a5fd441db092723fca6c1159
root@iZwz96uyro861qckgz89ljZ:~# iptables -t nat -nL
......
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0           
MASQUERADE  tcp  --  172.17.0.2           172.17.0.2           tcp dpt:80
```

#### 网络配置命令

　　只有在 Docker 服务启动的时候才能配置，而且不能马上生效的命令：

- `-b BRIDGE` 或 `--bridge=BRIDGE` ：指定容器挂载的网桥；
- `--bip=CIDR` ：定制 docker0 的掩码；
- `-H SOCKET...` 或 `--host=SOCKET...` ：Docker 服务端接收命令的通道；
- `--icc=true|false` ：是否支持容器之间进行通信；
- `--ip-forward=true|false` ：请看下文容器之间的通信；
- `--iptables=true|false` ：是否允许 Docker 添加 iptables 规则；
- `--mtu=BYTES` ：容器网络中的 MTU。

　　示例：

```shell
# 编辑docker默认配置：DOCKER_OPTS="--icc=false --iptables=true "
$ sudo vim /etc/default/docker
# 重启docker服务
$ sudo service docker restart
```

　　既可以在启动服务时指定，也可以在启动容器时指定的命令选项：

- `--dns=IP_ADDRESS...` 使用指定的DNS服务器；
- `--dns-search=DOMAIN...` 指定DNS搜索域。

　　 只能在容器启动时使用的命令选项，`docker run` 命令与网络相关的选项：

- `-h HOSTNAME` 或 `--hostname=HOSTNAME` ：配置容器主机名；
- `--link=CONTAINER_NAME:ALIAS` ：添加到另一个容器的连接；
- `--net=bridge|none|container:NAME_or_ID|host` ：配置容器的桥接模式；
- `-p SPEC 或 --publish=SPEC` ：映射容器端口到宿主主机；
- `-P or --publish-all=true|false` ：映射容器所有端口到宿主主机 。