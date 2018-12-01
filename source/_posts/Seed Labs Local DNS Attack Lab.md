---
title: 'Seed Labs: Local DNS Attack Lab'
tags:
  - Seed Labs
  - DNS
categories: 
  - Network
abbrlink: 35920
date: 2018-01-11 12:26:34
---

　　网络与计算机安全课程的实验，使用的是美国雪城大学的开放实验平台：Seed Project。

<!--more-->

#### 实验原理与目的

　　DNS（域名系统）是因特网上作为域名和 IP 地址相互映射的一个分布式数据库，能够使用户更方便地访问互联网，而不用去记住能够被机器直接读取的IP数串。本次实验涉及三种 DNS 攻击类型，分别是（1）修改用户机器中的 hosts 文件，从而实现 DNS 攻击（2）DNS欺骗，攻击者冒充域名服务器向发送 DNS 查询的机器发送欺骗 DNS 响应。（3）缓存污染，利用控制 DNS 缓存服务器，把原本准备访问某网站的用户在不知不觉中带到黑客指向的其他网站上。实验目的是了解上述 3 种 DNS 攻击的原理，以及 DNS 攻击是如何实现的，然后学会防范这样的攻击。

#### 实验配置

　　按照实验指导手册，从 SeedProject 的网站上下载 Ubuntu12.04 的镜像，它已经帮我们装好了实验必须的环境以及一些需要用到的软件。该系统默认的用户名是 seed，密码是 dees。

　　实验资料下载地址：
　　[http://www.cis.syr.edu/~wedu/seed/Labs_12.04/Networking/DNS_Local/](http://www.cis.syr.edu/~wedu/seed/Labs_12.04/Networking/DNS_Local/)

　　然后，配置 3 台虚拟机，1 台作为 DNS 服务器，1 台作为用户机，另 1 台作为攻击者，3 台机器通过设置 NAT 网络来实现网络互访。一般情况下，可直接复制虚拟机镜像生成三台虚拟机，不过有可能会出错。另外，3 台虚拟机同时打开需要较大的内存，主机内存 4G 的会很卡，8G 的完全没问题。实验示意图如下：

![11-0](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/11-0.png)

##### Vmware配置

　　SeedProject 提供的是 VirtualBox，但是在这里不建议使用，开源的还是会遇到一些莫名其妙的问题，浪费很多时间在虚拟机环境的配置上不划算。我们应该聚焦实验，所以选择更方便更简单的 VMware。

　　点击菜单栏-》编辑-》编辑虚拟网络，将下面的子网 IP 修改成 192.168.0.0，子网掩码设置成 255.255.255.0，找到 VMnet8 NAT，编辑它，将网关修改成 192.168.0.2，保存即可。

　　为方便操作经常需要在虚拟机和主机之间复制内容，所以需要安装 Wmvare Tools。点击顶部菜单栏的虚拟机，选择重新安装 VMware Tools，将打开的 VMware 文件复制到桌面上并解压，然后打开终端，使用命令进行安装：

```shell
$ cd /home/你的用户名/Desktop/VMwareTools版本号.../
$ ./vmware-install.pl
```
　　然后一步步安装说明进行操作即可，安装完成后可能需要重启虚拟机。

##### DNS服务器配置

　　IP 和 DNS 基本配置：

- IP 地址：192.168.0.10
- 子网掩码：255.255.255.0
- 网关：192.168.0.2
- DNS 服务器：114.114.114.114

（1）在 DNS 服务器上安装 BIND9，BIND 是一个开源的 DNS 服务器程序。

```shell
$ sudo apt-get update
$ sudo apt-get install bind9
```

（2）创建 named.conf.options 文件。DNS 服务器需要读取 /etc/bind/named.conf 配置文件才能启动。这个配置文件通常包含一个叫 /etc/bind/named.conf.options 的选项文件，我们添加以下内容用于后续的 DNS 缓存污染实验：

```
options {
dump-file "/var/cache/bind/dump.db";
};
```

文件 /var/cache/bind/dump.db 用于转储 DNS 服务器的缓存。假定我们在服务器中拥有一个域名： example.com，因此我们需要配置关于该域名的一些信息。为避免输入所带来的错误，它建议我们从 SeedProject 网站下载相应的文件放置到 /etc/bind/ 目录下。

- Zone file for domain example.com: [/var/cache/bind/example.com.db](http://www.cis.syr.edu/~wedu/seed/Labs_12.04/Networking/DNS_Local/example.com.db)
- Zone file for DNS reverse lookup: [/var/cache/bind/192.168.0](http://www.cis.syr.edu/~wedu/seed/Labs_12.04/Networking/DNS_Local/192.168.0)

（3）启动 DNS 服务器。

　　上述步骤完成后，我们的 DNS 服务器基本就配置完成了，然后我们使用如下命令将其启动：

```shell
$ sudo /etc/init.d/bind9 restart
or
$ sudo service bind9 restart
```

##### 用户机配置

　　IP 和 DNS 基本配置：

- IP 地址：192.168.0.100
- 子网掩码：255.255.255.0
- 网关：192.168.0.2
- DNS 服务器：192.168.0.10

##### 攻击者配置 

　　IP 和 DNS 基本配置：

- IP 地址：192.168.0.200
- 子网掩码：255.255.255.0
- 网关：192.168.0.2
- DNS 服务器：114.114.114.114

#### 实验过程
##### 修改 host 文件的攻击

　　该攻击实验假定我们已经获取了受害者机器的账号密码，因此，我们在攻击者机器上通过 ssh 连接到用户机器，然后修改其 /etc/hosts 文件，添加如下一行：

```
1.2.3.4  www.example.com
```

　　然后使用 ping 得到如下图的结果，可以看到该域名对应的 IP 地址已经变更为 1.2.3.4。因为如果用户机器中的 hosts 文件中存在该域名的条目，那么将直接解析该域名为条目中对应的 IP 地址，而不询问任何 DNS 服务器。攻击完成后，用户再使用 ping 时即可看到 www。Example 的地址已经变成1.2.3.4，如下图：

![11-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/11-1.png)

　　注意，这里使用 nslookup 进行查看时是不能看到攻击效果的，因为 nslookup 不会先查本地的 hosts 文件，而是直接向 DNS 服务器发送一个 DNS 查询请求。

##### 欺骗DNS响应

　　当用户在 Web 浏览器中输入网站域名时，用户计算机将向 DNS 服务器发出 DNS 请求以解析 IP 地址的主机名称。位于同一局域网的攻击者可以监听到这个 DNS 请求，然后在 DNS 服务器返回 DNS 响应之前伪造一个虚假的 DNS 响应发送给 DNS 请求者。当然，DNS 响应需要满足以下要求才会被 DNS 请求者接受：

1. 源 IP 地址必须与 DNS 服务器的 IP 地址相匹配。
2. 目标 IP 地址必须与用户机器的 IP 地址相匹配。
3. 源端口号（UDP端口）必须与 DNS 请求发送到的端口号（通常为端口53）相匹配。
4. 目标端口号必须与发送 DNS 请求的端口号相匹配。
5. UDP 校验和必须正确计算。
6. 交易 ID 必须与 DNS 请求中的交易 ID 匹配。
7. 响应的问题部分中的域名必须与请求的问题部分中的域名相匹配。
8. 响应部分中的域名必须与 DNS 请求的问题部分中的域名匹配。
9. 用户的计算机必须收到攻击者的 DNS 答复，才能收到合法的 DNS 响应。

　　Netwox 工具 105 提供了一个实用程序来进行这样的嗅探和响应。攻击者使用 Netwox 工具来监听来自用户机的数据包，并生成一个虚假的 DNS 响应包给 DNS 请求者，即用户机。实验原理示意图如下：

![11-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/11-2.png)

　　Netwox 命令如下：

```shell
$ sudo netwox 105 --hostname "www.example.com" --hostnameip 192.168.0.200 --authns "ns.example.com" --authnsip 192.168.0.200 --filter "src host 192.168.0.100"
```

　　配置好以后开始监听，同时，打开 wireshark 以便后续分析攻击结果，当监听到 DNS 请求时，可以在窗口看到生成的 DNS 响应信息，如下图：

![11-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/11-3.png)

　　同时，在客户机也可以看到查到的地址已经变成了攻击者的 IP 地址，证明攻击成功。如下图：

![11-4](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/11-4.png)

　　查看 wireshark 的抓包信息，可以看到我们通过生成的欺骗 DNS 响应的内容如下，完全符合要求，所以会被 DNS 请求者接收，从而实现 DNS 欺骗。

![11-5](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/11-5.png)

##### DNS服务器缓存污染

　　上面的 DNS 欺骗攻击在每次用户的机器发出www.example.com的 DNS 查询，攻击者的机器都必须发出一个欺骗性的 DNS 响应，这样效率很低，为了达到持久的效果，我们可以进行针对 DNS 服务器进行攻击。

　　当一个 DNS 服务器接收到一个查询时，如果它可以解析则直接解析并响应，当主机名不在它的域中，它将要求其他的 DNS 服务器去解析主机名。当其他的 DNS 服务器将解析结果返回给该服务器后，它将把解析结果存储在缓存中，所以下一次不需要询问其他的 DNS 服务器。如果攻击者可以伪造来自其他 DNS 服务器的响应，那么该 DNS 服务器会接手伪造的 DNS 响应，并在一定时间内将欺骗响应保留在其缓存中。下一次，当用户的机器想要解析相同的主机名时，该 DNS 服务器会使用缓存中的欺骗性响应来回复。这样，攻击者只需要欺骗一次，并且影响将持续到缓存的信息到期。攻击示意图如下：

![11-6](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/11-6.png)

　　为避免我们要攻击的 DNS 服务器已经有缓存，攻击之前，我们要确保 DNS 服务器的缓存为空，可以使用以下命令刷新缓存：

```shell
$ sudo rndc flush
```

　　攻击者使用 Netwox 工具来监听来自 DNS 服务器机的数据包，然后生成一个假的 DNS 响应给我们的 DNS 服务器。Netwox 的命令如下：

```shell
sudo netwox 105 --hostname "www.fanzhenyu.me" --hostnameip 192.168.0.200 --authns "ns.fanzhenyu.me" --authnsip 192.168.0.200 --ttl 600 --filter "src host 192.168.0.10" --spoofip "raw"
```

![11-7](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/11-7.png)

　　然后，在用户机使用如下命令发起 DNS 查询请求：

```shell
$ nslookup www.fanzhenyu.me
```

　　攻击结果如下图，与没有攻击对比，缓存污染后 DNS 请求的响应已经是被污染的 IP 地址：

![11-8](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/11-8.png)

　　同时，可以使用如下命令转储和查看 DNS 服务器的缓存：

```shell
$ sudo rndc dumpdb -cache 
$ sudo cat /var/cache/bind/dump.db
```

　　结果如下图，可以看到缓存已被污染。

![11-9](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/1/11-9.png)
