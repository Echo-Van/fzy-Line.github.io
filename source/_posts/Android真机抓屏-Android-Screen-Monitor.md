---
title: Android真机抓屏- Android Screen Monitor
tags: '［Android,Screen Monitor］'
categories: Android
abbrlink: 49670
date: 2016-07-21 08:59:11
---


　　最近遇到一个比较尴尬的问题，博客需要做一个Android手机网络状态检测的操作演示gif动图，虽然找到一款可以在电脑上录屏并自动生成gif文件的软件，但是eclipse自带的模拟器又不能切换到GPRS网络，于是，想着将真机的屏幕分享到电脑再进行录屏操作，试了华为助手和360助手，但是他们都需要全屏演示，不能很好的结合我的录屏软件，于是又百度找了找，最后还真有个小工具可以实现真机抓屏，反应还挺快，这就是Android Screen Monitor。

<!--more-->

#### ASM简介

Android Screen Monitor，简称为ASM，它是一个监视设备或模拟器屏幕的工具，ASM是 ADB调试桥的客户端应用程序，当ASM开始监控屏幕的时候，它通过5037端口连接至ADB，不断地把所监控设备的屏幕数据保存在帧缓存中并且把图像数据转换成用户可观测的内容。

#### ASM使用方法

1、确保你的手机可以进行真机调试

一般我们只要将手机通过USB连接上电脑，并打开USB调试，允许电脑控制我们的手机，然后将项目运行看是否能够运行在我们的真机。


2、ASM下载

最新版本是2.5，下载地址：

[https://code.google.com/p/android-screen-monitor/downloads/list](https://code.google.com/p/android-screen-monitor/downloads/list)

貌似要翻墙才能下载，不想翻墙单的话可以私聊我。

3、解压后文件夹中的asm.jar复制到Android SDK的platform-tools目录下

4、打开ASM

方法一：打开cmd，进入到Android SDK的platform-tools目录，然后输入如下命令

```
java -jar asm.jar
```
方法二：直接双击Android SDK的platform-tools目录下的asm.jar文件


5、进入选择界面，选择我们的手机

![20-1](http://ohe7ixo05.bkt.clouddn.com/2016/7/20-1.jpg)

6、进行相关配置

可右键选择调整窗体大小

![20-2](http://ohe7ixo05.bkt.clouddn.com/2016/7/20-2.jpg)

至此，我们就实现了将自己的手机屏幕分享到电脑的功能，赶快来体验一下反应快、画面流畅的Android Screen Monitor吧。