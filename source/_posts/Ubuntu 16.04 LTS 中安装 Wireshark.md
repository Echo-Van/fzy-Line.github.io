---
title: Ubuntu 16.04 LTS 中安装 Wireshark
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

　　虽然 Linux 也有像 tcpdump 这样的工具来实现抓包，但是与难以操作的命令行网络协议分析工具不同的是，Wireshark 拥有非常简洁易用的图形界面，使用 Wireshark 可以很容易地查看有线和无线网络的实时信息。

#### 安装

　　打开一个终端：

```shell
$ sudo apt-get install wireshark
```

#### 运行与配置

　　安装完成后使用非 root 直接运行 wireshark 的话，由于权限不足，所以无法识别网卡，只能打开 pcap 的文件，所以我们需要使用 sudo 提升权限。

　　默认情况下，访问网络端口需要 root 权限，而 wireshark 的只是 /usr/share/dumpcap 的一个 UI，/usr/share/dumpcap 需要 root 权限，所以没法 non-root 用户无法读取网卡列表。

##### root运行

　　打开一个终端：

```shell
$ sudo wireshark
```

　　但是，这样如果使用 root 运行则可能会报错：

![2-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/12/2-1.png)

　　要对 init.lua 进行修改，终端运行：

```shell
$ sudo gedit /usr/share/wireshark/init.lua
```

　　将倒数第二行改为：

```
--dofile(DATA_DIR.."console.lua")
```

　　再启动软件就 OK 啦。

```shell
$ sudo wireshark
```

##### 非 root 运行

　　虽然可以使用 root 成功运行 wireshark，但是 wireshark 官方不推荐这么做：

```
Running as user "root" and group "root".
This could be dangerous.
```

　　另外，这样做也不是很方便，特别是在使用桌面版时，如果要通过放置在侧边栏的图标打开 wireshark 时，默认是不会使用 root 用户打开的，所以我们需要设置 wireshark 为非 root 用户也能执行。

- 添加 wireshark 用户组

```shell
$ sudo groupadd  wireshark
```

- 将 dumpcap 更改为 wireshark 用户组

```shell
$ sudo chgrp wireshark /usr/bin/dumpcap
```

- 让 wireshark 用户组有 root 权限使用 dumpcap

```shell
$ sudo chmod 4755 /usr/bin/dumpcap
```

- 将需要使用的普通用户名加入 wireshark 用户组，例如我的用户是“fzy”，则需要使用命令：

```shell
$ sudo gpasswd -a fzy wireshark
```
