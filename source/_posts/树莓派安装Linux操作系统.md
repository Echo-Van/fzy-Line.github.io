---
title: 树莓派安装Linux操作系统
date: 2016-05-18 10:32:49
tags: ［树莓派,Linux］
categories: 树莓派
---

#### 树莓派上可安装的操作系统

（1）Linux：Raspbian,Arch Linux ARM

（2）Unix：FreeBSD,NetBSD

（3）Windows: Windows 10 for Raspberry Pi 2

<!--more-->

其中：

- 使用最广泛：Raspbian——基于Debian，为树莓派优化

- 强调定制性：Arch Linux ARM——为轻量，简洁，定制而生

- Raspbmc——用Kodi（XBMC/Xbox Media Center）打造多媒体中心

- Chromium OS——云端操作系统，中国大陆用户不方便使用

- Windows 10 loT物联网版本


#### Linux操作系统安装方法


##### 使用NOOBS来安装系统

（1）将TF卡格式化为FAT32格式

注意：TF（micro SD）卡需要大于等于4GB，而且并不是所有TF卡都能兼容树莓派，需百度查询兼容性列表

（2） 到[树莓派官网](www.raspberrypi.org)下载NOOBS（进入主页后点击DOWNLOAD就可以看到NOOBS了）

（3）将NOOBS解压后的所有文件拷贝到TF卡的根目录下

（4）连接显示器，并给树莓派上电（5V，2A电源，也可直接使用电脑的USB插口）

（5）初始化完成以后，你会进入NOOBS助手界面

（6）选择你需要安装的操作系统，然后点击上方的install OS即可进入安装

（7）完成后点击确认，然后Raspberry Pi会重启，至此系统安装完成

##### 直接安装Linux系统到SD卡

（1）到[树莓派官网](www.raspberrypi.org)下载你需要的官方系统镜像

（2）下载安装镜像的工具win32diskimager 

（3）运行Win32DiskImager，在软件中选择系统镜像（img文件），然后device(设备）下选择TF卡盘符，
点击write，等待写入完全，等到出现对话框write successful就说明成功了。

注意：写入完成后，win系统下看到SD只有几十MB了，这是正常现象，因为linux下的分区win下是看不到的！  

（4）连接显示器，并给树莓派上电，至此系统安装完成