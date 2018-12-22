---
title: Linux rz 和 sz 命令
tags:
  - Linux
  - rz/sz
categories: Linux
abbrlink: 25092
date: 2018-11-20 20:43:48
---

　　使用 rz 和 sz 工具实现客户端与 Linux 服务器端的文件交互。

<!--more-->

　　以 Windows 客户端和 Ubuntu 服务器之间的文件交互为例来进行说明。

#### 安装

##### apt 安装

```bash
$ sudo apt-get install lrzsz
```

##### 源码安装

1. 下载

```bash
$ wget https://www.ohse.de/uwe/releases/lrzsz-0.12.20.tar.gz
```

2. 解压

```bash
$ tar -xzf lrzsz-0.12.20.tar.gz
```

3. 编译安装

```bash
$ cd lrzsz-0.12.20
$ ./configure --prefix=/usr/local/lrzsz
$ sudo make
$ sudo make install
```

4. 创建连接

```bash
$ cd /usr/bin
$ sudo ln -s /usr/local/lrzsz/bin/lrz rz
$ sudo ln -s /usr/local/lrzsz/bin/lsz sz
```

#### 使用

##### sz（下载）

　　sz 命令发送文件到本地：

```bash
$ sz filename
```

##### rz（上传）

```bash
$ rz
```

　　执行该命令后，在弹出框中选择要上传的文件即可。

　　在 SecureCRT 软件中，可以设置上传下载的目录。点击Options -> session options -> X/Y/Zmodem 即可。