---
title: RIOT-OS开发环境搭建与样例解析
date: 2017-11-24 21:22:32
tags: [RIOT,操作系统]
categories:
- IoT
- RIOT
---

　　正式开始折腾友好的RIOT操作系统。

<!--more-->

#### 开发环境搭建

##### 源码下载与编译

　　以Ubuntu系统中搭建RIOT-OS开发环境为例，下载源码：

```
$ git clone git://github.com/RIOT-OS/RIOT.git
```

　　主分支一般是稳定版，如需最新版可切换到最新的分支：

```
$ cd RIOT
$ checkout <LATEST_RELEASE>
```

　　编译：

```
$ sudo ./dist/tools/tapsetup/tapsetup  # 创建虚拟以太网接口，连接多个RIOT实例        
$ cd examples/default/
$ make all
$ make term
```

　　亲测，32位ubuntu系统可以正确执行编译，但是64位ubuntu在使用make all编译时会出错，如图：

![13-1](http://ohe7ixo05.bkt.clouddn.com/2017/6/13-1.png)

　　可使用如下方法解决：

```
sudo apt-get install libc6-dev-i386
```

　　完成后再编译即可。

　　使用make term进行本地调试时，也会出错，如图：

![13-2](http://ohe7ixo05.bkt.clouddn.com/2017/6/13-2.png)

　　此时需加上sudo提升下权限：

```
sudo make term
```

![13-3](http://ohe7ixo05.bkt.clouddn.com/2017/6/13-3.png)

　　如果要编译到指定的平台，可在make时使用BOARD指定，例如：

```
$ sudo make BOARD=cc2538dk
```

　　然后，使用make进行编译，会发现如下错误。

![13-4](http://ohe7ixo05.bkt.clouddn.com/2017/6/13-4.png)

　　编译到cc2538dk等平台时需要下载交叉编译工具，否则会报错。根据RIOT的官方文档：

https://github.com/RIOT-OS/RIOT/wiki/Family%3A-ARM

　　ARM系列需要下载gcc-arm-embedded toolchain，地址如下：https://developer.arm.com/open-source/gnu-toolchain/gnu-rm

　　下载Linux64位版本，然后将其解压：

```
$ tar -xjvf 下载工具包名称.tar.bz2 -C /usr/bin
```

　　将其添加到环境变量：

```
$ nano ~/.bashrc
```

　　在最后添加如下一行：

```
$ export PATH=/usr/bin/下载工具包名称/bin:$PATH
```

　　然后执行：

```
$ source ~/.bashrc
```

　　这样即可执行编译。但是注意编译一定不要使用sudo，这样的话还是会出错，直接make就好了：

```
$ make BOARD=cc2538dk
```

##### 基本操作


　　以cc2538dk硬件平台为例：

- 编译生成指定硬件平台的可执行文件

```
$ make BOARD=cc2538dk
or
$ make all BOARD=cc2538dk
```

- 将程序烧录到指定硬件平台

```
$ make flash BOARD=cc2538dk
```

- 通过串口连接到硬件平台进行调试

```
$ make term BOARD=cc2538dk
or
$ make term BOARD=cc2538dk PORT=/dev/ttyACM1
```


#### 例程解析

##### main.c

```
#include <stdio.h>
#include "shell.h"
#include "shell_commands.h"

int main(void)
{
    puts("Hello World!");

    printf("You are running RIOT on a(n) %s board.\n", RIOT_BOARD);
    printf("This board features a(n) %s MCU.\n", RIOT_MCU);

    char line_buf[SHELL_DEFAULT_BUFSIZE];
    shell_run(NULL, line_buf, SHELL_DEFAULT_BUFSIZE);

    return 0;
}
```

　　代码风格与我们平时使用的C基本没有区别，节点启动后，RIOT会启动两个线程：

- idle 线程，具有最低优先级，只要没有其他线程准备运行，它将运行。它将自动使用设备的最低可能的电源模式。
- main 线程，配置的默认优先级位于最低和最高可用优先级之间的中间-是运行并调用main()函数的第一个线程。

　　另外，它这里使用到了RIOT的shell，程序运行后可通过shell命令与程序进行交互，当然，我们这里并没有定义命令，所以如下图的运行结果中并没有命令。

![13-5](http://ohe7ixo05.bkt.clouddn.com/2017/6/13-5.png)

##### Makefile

　　应用程序的 Makefile 至少需要定义以下宏：

- APPLICATION：应该包含应用程序的名称
- RIOTBASE：指定RIOT存储库副本的路径

　　BOARD 宏也是需要的并且默认被建议设置为native，但是建议使用？=操作符来覆盖。另外，需要从 RIOTBASE 中包含Makefile.include。

```
# 应用程序的名称
APPLICATION = hello-world

# 定义开发板，默认是native平台，可在bashrc文件中添加，也可以在编译之前使用export BOARD=cc2538cb定义
BOARD ?= native

# 指定根路径，用于加载模块、驱动等，这必须是RIOT基本目录的绝对路径
RIOTBASE ?= $(CURDIR)/../../RIOT
include $(RIOTBASE)/Makefile.include

# 添加模块
USEMODULE += shell
USEMODULE += shell_commands
```

　　包含模块：

　　默认情况下，RIOT应用程序仅包含应用程序的代码本身，内核和平台特定的代码。为了使用其他模块，如特定的设备驱动程序或系统库（包括网络功能），你必须将模块的名称附加到USEMODULE变量。

```
USEMODULE += sht11
USEMODULE += gnrc_ipv6_default
USEMODULE += gnrc_udp
```
