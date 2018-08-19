---
title: Ubuntu16.04 LTS中安装wireshark
tags:
  - Linux
  - Ubuntu
  - wireshark
categories: Linux
abbrlink: 20533
date: 2017-12-02 21:54:41
---

　　经常分析不同的网络协议和研究数据包的人一定经常使用 Wireshark。

<!--more-->

　　虽然Linux也有像tcpdump这样的工具来实现抓包，但是与难以操作的命令行网络协议分析工具不同的是，Wireshark 拥有非常简洁易用的图形界面，使用 Wireshark 可以很容易地查看有线和无线网络的实时信息。

#### 安装

打开一个终端：

```
$ sudo apt-get install wireshark
```

#### 运行与配置

　　安装完成后使用非root直接运行wireshark的话，由于权限不足，所以无法识别网卡，只能打开pcap的文件，所以我们需要使用sudo提升权限。

　　默认情况下，访问网络端口需要root权限，而wireshark的只是/usr/share/dumpcap的一个UI，/usr/share/dumpcap需要root权限，所以没法non-root用户无法读取网卡列表。

##### root运行

打开一个终端：

```
$ sudo wireshark
```

但是，这样如果使用root运行则可能会报错：

![2-1](http://ohe7ixo05.bkt.clouddn.com/2017/12/2-1.png)

要对init.lua进行修改，终端运行：

```
$ sudo gedit /usr/share/wireshark/init.lua
```

将倒数第二行改为：

```
--dofile(DATA_DIR.."console.lua")
```

再启动软件就OK啦。

```
$ sudo wireshark
```

##### 非root运行

虽然可以使用root成功运行wireshark，但是wireshark官方不推荐这么做：

```
Running as user "root" and group "root".
This could be dangerous.
```

　　另外，这样做也不是很方便，特别是在使用桌面版时，如果要通过放置在侧边栏的图标打开wireshark时，默认是不会使用root用户打开的，所以我们需要设置wireshark为非root用户也能执行。

- 添加wireshark用户组

```
$ sudo groupadd  wireshark
```

- 将dumpcap更改为wireshark用户组

```
$ sudo chgrp wireshark /usr/bin/dumpcap
```

- 让wireshark用户组有root权限使用dumpcap

```
$ sudo chmod 4755 /usr/bin/dumpcap
```

- 将需要使用的普通用户名加入wireshark用户组，例如我的用户是“fzy”，则需要使用命令：

```
$ sudo gpasswd -a fzy wireshark
```
