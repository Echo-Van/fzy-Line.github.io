---
title: Raspberry Pi 虚拟内存配置
tags:
  - Raspberry Pi
categories:
  - IoT
  - Raspberry Pi
abbrlink: 8873
date: 2018-11-12 19:55:40
---

　　解决 Raspberry Pi 编译项目时提示虚拟内存不足的问题。

<!--more-->

##### 虚拟内存不足

　　在 Raspberry Pi model 3B 上编译C++项目时，得到以下错误提示：

```
Virtual memory exhausted: Cannot allocate memory
```

　　相比于单片机等嵌入式设备，Raspberry Pi 已经拥有足够强大的处理能力。Raspberry Pi 从 model A 的 256MB 内存到 model 3B+ 的 1G 内存，这对于大多数应用程序来说，这个内存量实际上是足够的。但是，面对二进制文件编译，这样的内存空间往往是不够的，因此，无法编译很多项目。

　　Raspbian 发行版附带一个 100MB 的 swapfile，这其实就时虚拟内存。但是，默认的设置实际上有点偏小。一般的经验是虚拟内存大小应该是机器上可用内存的两倍。

##### 解决办法

　　修改配置文件中 swapfile 的大小：

```bash
$ sudo nano /etc/dphys-swapfile
```

　　默认是 100MB：

```bash
CONF_SWAPSIZE=100
```

　　使用以下命令可以查看内存与虚拟内存：

```bash
$ free -m
```

![12-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/11/12-1.png)

　　我们把它修改成：

```bash
CONF_SWAPSIZE=1024
```

　　然后，先停止再启动管理 swapfile  的 Rasbian 服务：

```bash
$ sudo /etc/init.d/dphys-swapfile stop
$ sudo /etc/init.d/dphys-swapfile start
```

　　再次查看内存与虚拟内存，验证是否设置成功：

![12-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/11/12-2.png)
