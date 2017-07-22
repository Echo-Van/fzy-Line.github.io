---
title: Contiki RPL-border-router Cooja仿真
date: 2017-02-21 09:28:35
tags: ［IoT,Contiki,Cooja］
categories: IoT
---


　　记录一次由于Instant Contiki版本差异造成的艰难调试。谨记善于变通，不要只会按照教程的步骤进行实验。

<!--more-->

#### 写在前面的话

此仿真参考了网上的很多教程，但是由于教程基本都是基于Instant Contiki2.7及以前版本，所以有些例程是存在差异的，而正是因为这些差异导致实验出错了。

主要参考教程：http://anrg.usc.edu/contiki/index.php/RPL_Border_Router

但是此教程基于 Contiki 2.7，我是用的是 Contiki 3.0，按照教程使用udp-server.c程序就行仿真，结果出现子节点与边界路由器没有组建网络，导致在Linux主机只能ping通边界路由器，但是不能ping通网络内部节点。找了很多的办法，最后还是找到了答案。

解决所遇到问题的关键：
https://sourceforge.net/p/contiki/mailman/message/34413098/

也就是我们需要使用udp-client.c来进行仿真实验，因为每个udp-server节点都想成为RPL根节点并且创建一个新的RPL有向无环图，这样的话就无法组建我们需要的网络完成我们的仿真。

边界路由器是指将局域网汇接到广域互联网的一种路由设备。在这个例子中，我们将测试边界路由器用于在无线传感器网络之间路由数据。

此次仿真基于Contiki的Instant Contiki开发平台，需要用到的文件在/home/contiki/examples/ipv6目录下的rpl-border-router和rpl-udp文件夹内：

border-router.c

slip-bridge.c

httpd-simple.c

udp-client.c

#### 编译代码

代码位于/contiki/examples/ipv6/rpl-border-router目录下，使用如下命令进行编译：

```
$ cd /contiki/examples/ipv6/rpl-border-router
$ make TARGET=sky
```

我们假设使用TMote Sky硬件平台进行仿真，所以TARGET=sky，编译完成将生成border-router.sky文件，这，文件将在Cooja仿真中用到。

为了演示边界路由器的功能，我们将创建一个以边界路由器为根节点的网络。建立这样一个网络需要使用到/contiki/examples/ipv6/rpl-udp目录下的udp-server.c代码，使用下面的命令来编译代码：

```
$ cd /contiki/examples/ipv6/rpl-udp
$ make TARGET=sky
```

编译完成将生成udp-client.sky，这个文件将在Cooja仿真中作为网络的子节点，这些节点与rpl边界路由根节点组成一个有向无环图。

#### 进行仿真

##### 启动Cooja

```
$ cd /contiki/tools/cooja 
$ ant run
```

Cooja模拟器打开后请不要关闭此命令行窗口，因为Cooja是通过命令打开的，进程还在运行，一旦关闭将会结束Cooja。

##### 创建仿真

点击 File -> New Simulation，然后填写相关信息，仿真的名字，选择UDGM，然后点击创建。

![20-1](http://ohe7ixo05.bkt.clouddn.com/2017/2/20-1.png)

##### 添加边界路由节点

填写名字，然后选择之前编译生成的sky文件，目录为：
/home/user/contiki/examples/ipv6/rpl-border-router/border-router.sky，创建1个border-router节点

![20-2](http://ohe7ixo05.bkt.clouddn.com/2017/2/20-2.png)

##### 添加udp-rpl节点

填写名字，然后选择之前编译生成的sky文件，目录为：
/home/user/contiki/examples/ipv6/rpl-udp/udp-client.sky

![20-3](http://ohe7ixo05.bkt.clouddn.com/2017/2/20-3.png)

创建4个udp-client节点：

![20-4](http://ohe7ixo05.bkt.clouddn.com/2017/2/20-4.png)

##### 调整显示信息

![20-5](http://ohe7ixo05.bkt.clouddn.com/2017/2/20-5.png)

##### 建立本地与RPL网络之间的连接

选中创建的border-router节点，然后点击右键选择More tools for border router -> Serial Socket(SERVER) 。

![20-6](http://ohe7ixo05.bkt.clouddn.com/2017/2/20-6.png)

弹出窗口点击start开始监听，显示：Listening on port 60001，然后点击开始仿真，在Mote output窗口可以看到局域网已经组建，udp-client节点已经开始向border-router节点发送消息。

![20-7](http://ohe7ixo05.bkt.clouddn.com/2017/2/20-7.png)

![20-12](http://ohe7ixo05.bkt.clouddn.com/2017/2/20-12.png)

##### 启用tunslip6

另外打开一个命令行窗口，编译tunslip6.c

```
$ cd /contiki/tools
$ make tunslip6
```

使RPL网络和本地计算机之间的连接。

```
$ sudo ./tunslip6 -a 127.0.0.1 aaaa::1/64
```

命令执行后将会打印如下信息，请不要关闭此窗口：


![20-8](http://ohe7ixo05.bkt.clouddn.com/2017/2/20-8.png)

打开Cooja仿真器可以看到，监听窗口已经显示连接到127.0.0.1:39346

![20-9](http://ohe7ixo05.bkt.clouddn.com/2017/2/20-9.png)

##### ping6测试网络

另外打开一个命令行窗口，进行ping6测试：

```
#测试边界路由器
$ ping6 aaaa::212:7401:1:101
#测试udp-client节点4
$ ping6 aaaa::212:7404:4:404
```

![20-10](http://ohe7ixo05.bkt.clouddn.com/2017/2/20-10.png)

##### 浏览器访问测试

![20-11](http://ohe7ixo05.bkt.clouddn.com/2017/2/20-11.png)

