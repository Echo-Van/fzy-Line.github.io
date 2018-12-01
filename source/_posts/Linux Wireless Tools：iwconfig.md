---
title: Linux Wireless Tools：iwconfig
tags:
  - Linux
  - iwconfig
categories: Linux
abbrlink: 22784
date: 2017-11-11 10:58:28
---


　　iwconfig - 配置无线网络接口

<!--more-->

　　iwconfig 用于 Linux 系统配置无线网络设备或显示无线网络设备信息。iwconfig 命令类似于 ifconfig 命令，但是他配置对象是无线网卡，它对网络设备进行无线操作，如设置无线通信频段。

#### iwconfig 安装

　　Ubuntu 下使用如下命令安装，wireless-tools 工具包中包含了 iwconfig。

```shell
$ sudo apt install wireless-tools
```

#### 使用说明

```
Usage: iwconfig [interface]
                interface essid {NNN|any|on|off}
                interface mode {managed|ad-hoc|master|...}
                interface freq N.NNN[k|M|G]
                interface channel N
                interface bit {N[k|M|G]|auto|fixed}
                interface rate {N[k|M|G]|auto|fixed}
                interface enc {NNNN-NNNN|off}
                interface key {NNNN-NNNN|off}
                interface power {period N|timeout N|saving N|off}
                interface nickname NNN
                interface nwid {NN|on|off}
                interface ap {N|off|auto}
                interface txpower {NmW|NdBm|off|auto}
                interface sens N
                interface retry {limit N|lifetime N}
                interface rts {N|auto|fixed|off}
                interface frag {N|auto|fixed|off}
                interface modulation {11g|11a|CCK|OFDMg|...}
                interface commit
       Check man pages for more details.
```

##### essid

　　设置无线网卡的 ESSID(Extension Service Set ID)。通过 ESSID 来区分不同的无线网络，正常情况下只有相同 ESSID 的无线站点才可以互相通讯，除非想监听无线网络。其后的参数为双引号括起的 ESSID 字符串，或者是any/on/off，如果 ESSID字符串中包含any/no/off，则需要在前面加"--"。


```shell
$ iwconfig eth0 essid any
$ iwconfig eth0 essid "My Network""
$ iwconfig eth0 essid -- "ANY""
```

##### mode

　　设置无线网卡的工作模式，可以是

- Ad-hoc：不带 AP 的点对点无线网络
- Managed：通过多个 AP 组成的网络，无线设备可以在这个网络中漫游
- Master：设置该无线网卡为一个 AP
- Repeater：设置为无线网络中继设备，可以转发网络包
- Secondary：设置为备份的 AP/Repeater
- Monitor：监听模式
- Auto：由无线网卡自动选择工作模式


```shell
$ iwconfig wlan0 mode Managed
$ iwconfig wlan0 mode Ad-Hoc
```

##### freq/channel

　　设置无线网卡的工作频率或者频道，小于 1000 的参数被认为是频道，大于 10000 的参数被认为是频率。频率单位为 Hz，可以在数字后面附带 k, M, G 来改变数量级，比如 2.4G。频道从1开始。使用 lwlist 工具可以查看无线网卡支持的频率和频道。参数 off/auto 指示无线网络自动挑选频率。

　　注意：如果是 Managed 模式，AP 会指示无线网卡的工作频率，因此该设置的参数会被忽略。Ad-hoc 模式下只使用该设定的频率初始无线网络，如果加入已经存在的 Ad-hoc 网络则会忽略该设置的频率参数。

```shell
$ iwconfig wlan0 freq 2422000000
$ iwconfig wlan0 freq 2.422G
$ iwconfig wlan0 channel 3
$ iwconfig wlan0 channel auto
```

##### rate/bit

　　如果无线网卡支持多速率，则可以通过该命令设置工作的速率。小于 1000 的参数由具体的无线网卡驱动定义，一般是传输速率的索引值，大于 1000 的为速率，单位 bps，可以在数字后面附带 k，M，G 来指定数量级。auto 参数让无线网卡自动选择速率 fixed 参数让无线网卡不使用自动速率模式。

```shell
$ iwconfig wlan0 rate 11M
$ iwconfig wlan0 rate auto
$ iwconfig wlan0 rate 5.5M auto
```

##### ap

　　连接到指定的 AP 或者无线网络，后面的参数可以是 AP 的 MAC 地址，也可以是 iwlist scan 出来的标识符。如果是 Ad-hoc，则连接一个已经存在的 Ad-hoc 网络。使用 off 参数让无线网卡不改变当前已连接的 AP 下进入自动模式。any/auto 参数，无线网卡自动选择最好的 AP。

　　注意：如果无线信号低到一定程度，无线网络会进入自动选择AP模式。


```shell
$ iwconfig wlan0 ap 00:60:1D:01:23:45
$ iwconfig wlan0 ap any
$ iwconfig wlan0 ap off
```

##### key/enc

　　设置无线网卡使用的加密密钥，此处为设置 WEP 模式的加密 key，如果要使用 WPA，需要 wpa_supplicant 工具包。

```shell
$ iwconfig wlan0 key 0123-4567-89
$ iwconfig wlan0 key [3] 0123-4567-89
$ iwconfig wlan0 key s:password [2]
```

##### power

　　设置无线网卡的电源管理模式。period ‘value’  指定唤醒的周期，timeout ‘value’ 指定进入休眠的等待时间，这两个参数之前可以加 min 和 max 修饰，这些值的单位为秒，可以附加 m 和 u 来指定毫秒和微秒。off/on 参数指定是否允许电源管理，all/unicast/multicast 指定允许唤醒的数据包类型。

```shell
$ iwconfig wlan0 power period 2
$ iwconfig wlan0 power 500m unicast
$ iwconfig wlan0 power timeout 300u all
$ iwconfig wlan0 power saving 3
$ iwconfig wlan0 power off
$ iwconfig wlan0 power min period 2 power max period 4
```

##### txpower

　　如果无线网卡支持多发射功率设定，则使用该参数设定发射，单位为 dBm，如果指定为 W（毫瓦），只转换公式为：
dBm=30+log(W)。参数 on/off 可以打开和关闭发射单元，auto 和 fixed 指定无线是否自动选择发射功率。

```shell
$ iwconfig wlan0 txpower 15
$ iwconfig wlan0 txpower 30mW
$ iwconfig wlan0 txpower auto
$ iwconfig wlan0 txpower off
```

##### retry


　　设置无线网卡的重传机制。limit ‘value’  指定最大重传次数；lifetime ‘value’ 指定最长重试时间，单位为秒，可以附带 m 和 u 来指定单位为毫秒和微秒。如果无线网卡支持自动模式，则在 limit 和 lifetime 之前还可以附加 min 和 max 来指定上下限值。

```shell
$ iwconfig wlan0 retry 16
$ iwconfig wlan0 retry lifetime 300m
$ iwconfig wlan0 retry short 12
$ iwconfig wlan0 retry min limit 8
```

##### commit

　　提交所有的参数修改给无线网卡驱动。有些无线网卡驱动会先缓存无线网卡参数修，使用这个命令来让无线网卡的参数修改生效。不过一般不需要使用该命令，因为无线网卡驱动最终都会是参数的修改生效，一般在 debug 时会用到。

##### 其他配置

```
- nwid: Network ID  # 只用于pre-802.11的无线网卡，802.11网卡利用ESSID和AP的MAC地址来替换nwid，现在基本上不用设置。
- nick: Nickname  # 一些网卡需要设置该参数，但是802.11协议栈、MAC都没有用到该参数，一般也不用设置。
- sens # 设置接收灵敏度的下限，在该下限之下，无线网卡认为该无线网络信号太差。
- rts   # 设置节点发送RTS的最小包的大小
- frag  # 设置发送数据包的分片大小。
- modu  # 设定的特定调制集
```
