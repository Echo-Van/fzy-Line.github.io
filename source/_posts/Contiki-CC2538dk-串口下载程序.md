---
title: Contiki CC2538dk 串口下载程序
date: 2017-02-18 17:05:32
tags: ［IoT,Contiki,CC2538dk］
categories: IoT
---

　　本以为自己再也不会接触嵌入式开发这一方面的东西，没想到，毕业设计就开始重拾开发板，以后也要朝着物联网方向发展了。一块从没用过的开发板，一款之前完全不了解的物联网操作系统，一直不太熟悉的C语言，以至于下载程序就折腾了很久，在这里总结下，希望接下来能够顺利一些。

<!--more-->

#### 硬件连接准备

##### 连接开发板和USB转TTL模块

开发板:3.3V----USB转TTL:3.3V

开发板:TX‐‐‐‐USB转TTL:RX

开发板:RX‐‐‐‐USB转TTL:TX

开发板:GND‐‐‐‐USB转TTL:GND

##### 安装驱动

根据USB转TTL模块的芯片安装对应的驱动，常见的有PL2303和CH340，在网上找到对应驱动下载安装即可。

打开设备管理器查看端口，如果未安装成功则显示黄色感叹号。

#### Linux系统下烧写程序

注意：本文采用Contiki官网推荐的开发工具：Instant Contiki，即为Ubuntu 14.04操作系统

##### 将USB模块连接到虚拟机

插上USB转TTL模块后，一般会默认将其挂载到windwos操作系统，这里需要点击虚拟机右下角的U盘图标再点连接将其与虚拟机连接起来。

##### 查看/dev/ttyUSB0设备信息

```
$ cd /dev
$ ls ttyUSB* -l
```

##### 修改ttyUSB0设备使用权限

```
$ sudo chmod 777 ttyUSB0
```

也可以在其他位置编写shell脚本：

```
#!/bin/bash
sudo chmod 777 /dev/ttyUSB0
```

此处较为麻烦，我使用的是虚拟机，每次拔出USB再次插入后ttyUSB0的权限就又还原了，所以每次都得修改权限。然后，不知道什么原因，下载一次之后就无法下载，得拔出再插入，所以比较麻烦，这也是我为什么后来改用 windows 下载的原因。

##### 切换到bootloader模式

开发板需进入bootloader才能进行串口下载程序。

开发板按键的作用：

Reset：复位重启系统

Down/Up/Select/Right/Left：配合例程作事件输入

Reset+Select：配合进入 bootloader 模式

**Bootloader模式：按住select按键同时，按下Reset按键，led没有任何动静，证明现在处于bootloader 模式。**

##### 下载程序

我们以 /home/user/contiki/examples/cc2538dk/cc2538-demo.c 为例进行烧写程序。

初次接触 contiki 的程序，demo 的代码复杂了点，为了便于理解以及方便查看效果，我们把程序修改成如下：

使用etimer模块间隔5s读取系统运行时间，然后每次打印系统时间以及Hello, world方便观察。

```
#include "contiki.h"

#include <stdio.h> /* For printf() */

static struct etimer et;  //定义etimer变量
unsigned long sec;  //用于记录系统运行时间的变量

/*---------------------------------------------------------------------------*/
PROCESS(hello_world_process, "Hello world process");
AUTOSTART_PROCESSES(&hello_world_process);
/*---------------------------------------------------------------------------*/
PROCESS_THREAD(hello_world_process, ev, data)
{
  PROCESS_BEGIN();

  while(1){
     etimer_set(&et, 5 * CLOCK_SECOND);  // 设置为每隔5s etimer溢出一次
     PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));   // 等待定时器溢出
     sec = clock_seconds();  // 记录系统运行时间 单位s  
     printf("%lu Seconds\n", sec);   
     printf("Hello, world\n");
  }
  
  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
```

先编译后下载：

```
$ make TARGET=cc2538dk
$ make cc2538-demo.upload
```

![18-1](http://ohe7ixo05.bkt.clouddn.com/2017/2/18-1.png)

下载出错的情况，遇到以下情况需要重新拔出USB再次插入，反正经常出现下面的情况，所以我最后还是转到Windows上进行下载了。

```
ERROR: Can't connect to target. Ensure boot loader is started. (no answer on synch sequence)
make: *** [cc2538-demo.upload] Error 1
```

```
ERROR: [Errno 5] Input/output error
make: *** [cc2538-demo.upload] Error 1
```

##### 使用 minicom 查看输出信息

minicom 是一个串口通信工具，就像Windows下的超级终端。可用来与串口设备通信，如调试交换机和Modem等。

**安装 minicom**

```
$ sudo apt-get install minicom
```

**配置 minicom**

```
$ sudo minicom -s
```

进入了minicom的配置界面，使用上下键选择Serial port setup，回车，然后输入A，回车，修改 Serial Device 为 /dev/ttyUSB0，然后保存退出。

![18-2](http://ohe7ixo05.bkt.clouddn.com/2017/2/18-2.png)

**使用 minicom**

```
$ sudo minicom
```
![18-3](http://ohe7ixo05.bkt.clouddn.com/2017/2/18-3.png)

#### Windows 系统下烧写程序

##### 下载安装烧写工具

TI Flash Programmer2 工具主要用于CC25xx，CC26xx等系列芯片的程序烧录，大家可以从TI官网下载：http://www.ti.com.cn/tool/cn/flash-programmer?keyMatch=flash%20programmer&tisearch=Search-CN-Everything

由于访问可能出现问题，这里给出一个CSDN提供的下载地址：http://download.csdn.net/detail/zzfenglin/9626337

##### 编译程序

这里编译程序还是在Instant contiki上进行，因为如果要在 Windows 下编译的话还得使用IAR等开发工具，然后进行 contiki 的移植，所以我们还是使用官网推荐的方式使用 Instant contiki 吧。如上：

```
$ cd /home/user/contiki/examples/cc2538dk
$ make TARGET=cc2538dk
```

将得到的bin文件或者hex文件复制到Windwos，从虚拟机中复制文件到 Windous 需要使用 VMware 的 VMware tools 工具，可以点击菜单栏虚拟机->安装 VMware Tools，安装好之后即可像在同一个系统中复制粘贴了。

##### 烧写程序

将USB转TTL模块连接到电脑，然后打开TI Flash Programmer2。

![18-4](http://ohe7ixo05.bkt.clouddn.com/2017/2/18-4.png)

点击左侧Refresh，找到USB设备，在左下方选择芯片型号：cc2538，中间Flash Images选择bin文件所在路径，下方 Action 勾选 Erase、Program、Verify。

按住开发板的Reset + Select：配合进入 bootloader 模式

点击TI Flash Programmer2下方播放按钮进行程序烧录，烧录成功会显示Success！

##### 打开串口助手查看效果

![18-5](http://ohe7ixo05.bkt.clouddn.com/2017/2/18-5.png)