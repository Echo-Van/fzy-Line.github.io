---
title: Contiki Cooja 仿真
tags:
  - IoT
  - Contiki
categories:
  - IoT
  - OS
abbrlink: 38896
date: 2017-02-14 22:53:25
---

　　Cooja 是 Contiki 操作系统中的网络模拟器，Contiki 设备经常组成大型无线网络，Cooja 提供一个仿真环境，使开发人员能够看到他们的应用程序运行在大型网络，使得开发和调试变得更简单。

<!--more-->

#### 运行cooja

##### 进入cooja目录

```shell
$ cd contiki/tools/cooja
```

##### 启动cooja

```shell
$ ant run
```

　　如果启动失败：

```shell
BUILD FAILED
/home/user/contiki/tools/cooja/build.xml:199: The following error occurred while executing this line:
/home/user/contiki/tools/cooja/apps/mspsim/build.xml:29: -
----------------
Could not find the MSPSim build file. Did you run "git submodule update --init"?
----------------
```

　　按提示输入以下命令：

```shell
git submodule update --init
```

　　如果再次出错：

```shell
fatal: Not a git repository (or any of the parent directories): .git
```

　　则需要：

```shell
git init
git submodule update --init
```

　　再次输入启动命令进行启动：

```shell
ant run
```

　　如图，Cooja 已经运行起来，使用 Ctrl + C 可结束 Cooja。

![14-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/14-1.png)



　　**另外，如果你使用 contiki-3.0/tools/cooja 目录下的 Cooja 时很有可能出现上面所说的错误，并且无法解决！所以请使用 contiki/tools/cooja 目录下的 Cooja 进行仿真。**

#### 仿真实验

##### 创建仿真

　　点击 File 菜单然后点击 New simulation 。

##### 设置模拟选项

![14-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/14-2.png)

- Simulation name 仿真名字。

- Radio medium 无线介质，下拉选项：
  - UDGM:Distance Loss 单位圆盘图：距离损失

  - UDGM:Constant Loss 单位圆盘图：常量损失

  - DGRM：有向图通信   

  - No radio traffic 无无线信道

- Mote startup delay 节点启动延时

- Random seed 随机种子生成

##### 仿真窗口

![14-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/14-3.png)

- Network window 网络窗口：显示在模拟网络中的所有节点

- Timeline window 时间轴窗口：显示在模拟中的所有通信事件随着时间的推移-非常方便了解什么在网络上进行

- Mote output window 节点输出窗口：显示所有节点的串口打印输出

- Notes window 注释窗口：为仿真编写注释的地方

- Simulation control window 仿真控制窗口：启动，暂停和重新加载我们的仿真

##### 添加节点

　　Motes -> Add motes -> Create new mote type -> Sky mote。


![14-4](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/14-4.png)

##### 创建节点类型

　　添加描述，然后点击 Browse 选择我们的 Contiki 应用。国际惯例我们运行一个最简单的程序，进入到 /home/user/contiki-3.0/examples/hello-world 目录。加载里面的 hello-world.c，点击编译，等待编译完。

![14-5](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/14-5.png)

　　然后点击 create 创建，在弹出的窗口填写节点基本信息：

![14-6](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/14-6.png)


##### 运行程序

　　我们可以看到在 Network window 已经有了一个节点，我们再点击控制 Simulation control window 的 start 按钮，在 Mote output 窗口可以看到打印出来的 Hello world。

![14-7](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/2/14-7.png)


　　至此，我们初步了解了 Cooja 仿真器的用法，有了这个神器，我们就可以进行各种各样的模拟仿真实验，在复杂的网络中验证我们编写的程序。
