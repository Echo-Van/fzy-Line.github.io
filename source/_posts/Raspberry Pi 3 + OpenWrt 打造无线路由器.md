---
title: Raspberry pi 3 + OpenWrt 打造无线路由器
tags:
  - Raspberry Pi
  - OpenWrt
categories:
  - IoT
  - Raspberry Pi
abbrlink: 20985
date: 2017-10-18 21:13:56
---

　　OpenWrt 在 Raspberry pi 3 上的安装与初步配置记录。

<!--more-->

#### 烧写 Openwrt 系统

　　下载支持 Raspberry Pi 3 代的 LEDE（Openwrt的一个分支）镜像。

　　LEDE官方网站：https://lede-project.org/

　　Raspbery Pi 3 LEDE镜像下载地址：http://downloads.lede-project.org/snapshots/targets/brcm2708/bcm2710/lede-brcm2708-bcm2710-rpi-3-ext4-sdcard.img.gz

　　使用 Win32DiskImager 工具将下载的镜像文件写入到 SD 卡中，然后连接显示器键盘即可进入系统进行相关操作。

　　**Raspbery Pi 3 连接显示器后无显示的问题：**

　　修改系统 /boot/comfig.txt 文件，默认的 HDMI 输出都配置为不开启，所以需要配置 HDMI 输出为如下：

```
hdmi_safe=1
overscan_left=-30
overscan_right=-30
overscan_top=-30
overscan_bottom=-30
hdmi_group=2
hdmi_mode=4
hdmi_drive=2
config_hdmi_boost=4
```

#### 配置 Openwrt

　　配置 Openwrt 有线网络，修改 /etc/config/network 文件，配置 wan 口和 lan 口如下：

```
config interface 'lan'
    option type 'bridge'
    option proto 'static'
    option ipaddr '192.168.3.1'
    option netmask '255.255.255.0'
    option ip6assign '60'
    option gateway '192.168.3.1'

config interface 'wan'
        option proto 'dhcp'
        option ifname 'eth0'
```

　　配置 Openwrt 无线网络，修改 /etc/config/wireless 文件，配置 wlan0 的模式、ssid、key 等信息，如下：

```
config wifi-iface
    option device 'radio0'
    option network 'lan'
    option mode 'ap'
    option ssid 'openwrt-fzy'
    option encryption 'psk2'
    option key '12345678'
```

　　配置允许通过 wan 连接 ssh，修改 /etc/config/firewall 文件：

```
#open ssh on wan interface
config rule                
        option src              wan
        option dest_port        22
        option target           ACCEPT     
        option proto
```

　　重启 Raspberry Pi，网线连接路由器 dhcp 获取 ip，笔记本用 wifi 连接 Raspberry Pi。

　　安装 luci 界面，可以通过浏览器访问路由。

```
opkg update
opkg install luci
/etc/init.d/uhttpd start
/etc/init.d/uhttpd enable
```

　　配置完成后可通过连接到该无线网络的设备访问 192.168.3.1 进入到路由器的 Web 配置界面。

　　至此，Raspberry Pi 作为路由器部分已经完成，后续还可以将其配置成 Wi-Fi 抓包器。
