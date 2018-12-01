---
title: Contiki RPL-border-router Cooja 仿真
tags:
  - IoT
  - Contiki
categories:
  - IoT
  - OS
abbrlink: 60741
date: 2017-02-21 09:28:35
---


　　记录一次由于 Instant Contiki 版本差异造成的艰难调试。谨记善于变通，不要只会按照教程的步骤进行实验。

<!--more-->

#### 写在前面的话

　　此仿真参考了网上的很多教程，但是由于教程基本都是基于 Instant Contiki 2.7 及以前版本，所以有些例程是存在差异的，而正是因为这些差异导致实验出错了。

　　主要参考教程：http://anrg.usc.edu/contiki/index.php/RPL_Border_Router

　　但是此教程基于 Contiki 2.7，我是用的是 Contiki 3.0，按照教程使用 udp-server.c 程序就行仿真，结果出现子节点与边界路由器没有组建网络，导致在 Linux 主机只能 ping 通边界路由器，但是不能 ping 通网络内部节点。找了很多的办法，最后还是找到了答案。

　　解决所遇到问题的关键：https://sourceforge.net/p/contiki/mailman/message/34413098/

　　也就是我们需要使用 udp-client.c 来进行仿真实验，因为每个 udp-server 节点都想成为 RPL 根节点并且创建一个新的 RPL 有向无环图，这样的话就无法组建我们需要的网络完成我们的仿真。

　　边界路由器是指将局域网汇接到广域互联网的一种路由设备。在这个例子中，我们将测试边界路由器用于在无线传感器网络之间路由数据。

　　此次仿真基于 Contiki 的 Instant Contiki 开发平台，需要用到的文件在 /home/contiki/examples/ipv6 目录下的 rpl-border-router 和 rpl-udp 文件夹内：

- border-router.c

- slip-bridge.c

- httpd-simple.c

- udp-client.c

#### 编译代码

　　代码位于 /contiki/examples/ipv6/rpl-border-router 目录下，使用如下命令进行编译：

```shell
$ cd /contiki/examples/ipv6/rpl-border-router
$ make TARGET=sky
```

　　我们假设使用 TMote Sky 硬件平台进行仿真，所以 TARGET=sky，编译完成将生成 border-router.sky 文件，这，文件将在 Cooja 仿真中用到。

　　为了演示边界路由器的功能，我们将创建一个以边界路由器为根节点的网络。建立这样一个网络需要使用到 /contiki/examples/ipv6/rpl-udp 目录下的 udp-server.c 代码，使用下面的命令来编译代码：

```shell
$ cd /contiki/examples/ipv6/rpl-udp
$ make TARGET=sky
```

　　编译完成将生成 udp-client.sky，这个文件将在 Cooja 仿真中作为网络的子节点，这些节点与 RPL 边界路由根节点组成一个有向无环图。

#### 进行仿真

##### 启动 Cooja

```shell
$ cd /contiki/tools/cooja
$ ant run
```

　　Cooja 模拟器打开后请不要关闭此命令行窗口，因为 Cooja 是通过命令打开的，进程还在运行，一旦关闭将会结束 Cooja。

##### 创建仿真

　　点击 File -> New Simulation，然后填写相关信息，仿真的名字，选择 UDGM，然后点击创建。

![20-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/20-1.png)

##### 添加边界路由节点

　　填写名字，然后选择之前编译生成的sky文件，目录为：/home/user/contiki/examples/ipv6/rpl-border-router/border-router.sky，创建 1 个 border-router 节点

![20-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/20-2.png)

##### 添加udp-rpl节点

　　填写名字，然后选择之前编译生成的sky文件，目录为：/home/user/contiki/examples/ipv6/rpl-udp/udp-client.sky

![20-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/20-3.png)

　　创建 4 个 udp-client 节点：

![20-4](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/20-4.png)

##### 调整显示信息

![20-5](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/20-5.png)

##### 建立本地与 RPL 网络之间的连接

　　选中创建的 border-router 节点，然后点击右键选择 More tools for border router -> Serial Socket(SERVER) 。

![20-6](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/20-6.png)

　　弹出窗口点击 start 开始监听，显示：Listening on port 60001，然后点击开始仿真，在 Mote output 窗口可以看到局域网已经组建，udp-client 节点已经开始向 border-router 节点发送消息。

![20-7](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/20-7.png)

![20-12](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/20-12.png)

##### 启用 tunslip6

　　另外打开一个命令行窗口，编译 tunslip6.c

```shell
$ cd /contiki/tools
$ make tunslip6
```

　　使RPL网络和本地计算机之间的连接。

```shell
$ sudo ./tunslip6 -a 127.0.0.1 aaaa::1/64
```

　　命令执行后将会打印如下信息，请不要关闭此窗口：


![20-8](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/20-8.png)

　　打开 Cooja 仿真器可以看到，监听窗口已经显示连接到 127.0.0.1:39346

![20-9](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/20-9.png)

##### ping6 测试网络

　　另外打开一个命令行窗口，进行 ping6 测试：

```shell
#测试边界路由器
$ ping6 aaaa::212:7401:1:101
#测试udp-client节点4
$ ping6 aaaa::212:7404:4:404
```

![20-10](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/20-10.png)

##### 浏览器访问测试

![20-11](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/20-11.png)
