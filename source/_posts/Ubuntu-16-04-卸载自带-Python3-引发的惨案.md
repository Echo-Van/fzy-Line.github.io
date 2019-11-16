---
title: Ubuntu 16.04 卸载自带 Python3 引发的惨案
tags:
  - Ubuntu
  - Mysql
categories: Linux
abbrlink: 25595
date: 2019-11-14 10:53:52
---

<center>由于无知，卸载 Ubuntu 自带的 python3 引发惨案，谨记，深刻反思。</center>

<!--more-->

#### 惨案

　　由于实验需要使用 Python3.6 以上版本，于是决定卸载 Python3.5。

```shell
# 卸载 python3.5
$ sudo apt-get remove python3.5
```

　　没用，终端输入 python3 还是可以使用。于是，网上查找卸载python3.5的方法：

```shell
# 卸载 python3.5 及其依赖
$ sudo apt-get remove --auto-remove python3.5
# 清除 python3.5
$ sudo apt-get purge python3.5
or
$ sudo apt-get purge --auto-remove python3.5
```

　　接下来，终端输入 python3 依然还是可以使用。

```shell
# 删除链接
sudo rm /usr/bin/python3
```

　　然后，突然发现侧边菜单栏变灰，感觉不对劲，重启。然后，侧边菜单栏不见了，右键连打开终端的选项都没有了。

![14-1](https://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/11/14-1.jpg)

　　于是，查找解决方案：

```shell
# 切换到命令行模式
ctrl+alt+t
# 失败，再次尝试
ctrl+alt+F1
# 成功
$ sudo apt install -f
# 重新安装桌面
$ sudo apt-get -f install ubuntu-minimal ubuntu-standard ubuntu-desktop
# 重启
$ sudo reboot
```

　　重启后，菜单栏又出现了。但是，终端依然没有。可以在  xterm 或者 中尝试安装：

```shell
$ sudo apt install gnome-terminal
```

　　但是，一般是不起作用的，还是打不开。由于系统中很多软件都是依赖 python3，所以卸载了 python3 导致了系统崩溃。即使安装了 python3.6+ 并设置了 python3 的软连接，依然不行。

　　可以尝试重装 python3.5，然后设置 python3 软连接。也可以尝试以下方法：

- https://blog.csdn.net/tao_627/article/details/91042809
- https://blog.csdn.net/qs521/article/details/98945938

　　惨案发生后，即使菜单栏回来了，终端或许也能打开了，但是使用 apt 安装软件一直报 dpkg 的错误，找了很多方法也没有解决，所以还是决定重新装系统了。

#### 正确安装 Python 3.6+

　　正确的方式就是不要轻易删除 python3 及其依赖。特别是不要删除依赖。在 Ubuntu16.04 中修改 python3 指向 3.6+ 版本以后，某些软件会无法使用，比如终端，需要使用上面连接的方法进行相应的处理。

　　安装 Python3.6+ 以上版本的正确姿势：

```shell
# 从官网下载对应版本的源码
https://www.python.org/downloads/source/
# 解压
$ tar -zxvf xxxxx
$ cd xxxx
# 创建安装目录
$ sudo mkdir -p /usr/local/python3
# 配置、编译、安装
$ ./configure --preifx=/usr/local/python3 --enable-optimizations
$ make
$ sudo make install
```

　　安装以后，不修改 python3 的指向，可以为 python3.6+ 版本指定不同的链接名：

```shell
# 添加 python37 的软链接
$ ln -s /usr/local/python3/bin/python3.7 /usr/bin/python37
# 添加 pip3 的软链接（这样pip3就是python3.7专用的，也可以起名为 pip37，不影响python3.5的pip3）
$ ln -s /usr/local/python3/bin/pip3.7 /usr/bin/pip3
```

　　检测版本，查看是否成功：

```shell
$ python37 -V
$ pip3 -V
```

![14-2](https://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/11/14-2.jpg)

　　重新安装系统、软件、搭建实验环境，真的是心累啊。谨记，以后不要随便卸载系统自带软件，特别是不要相信某些博客写的彻底清除xxx及其依赖的操作。