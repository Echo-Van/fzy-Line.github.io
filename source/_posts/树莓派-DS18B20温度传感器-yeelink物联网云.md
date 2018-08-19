---
title: 树莓派+DS18B20温度传感器+yeelink物联网云
tags: '［树莓派,DS18B20,yeelink］'
categories: Raspberry Pi
abbrlink: 62926
date: 2016-05-30 10:59:55
---

　　本博文参考了网络上多篇树莓派操作DS18B20的博文，经过博主亲自实践，列出了详细的步骤，通过树莓派的单总线驱动来驱动DS18B20获取温度数据，并通过python读取温度值，上传到yeelink物联网云平台。

<!--more-->

#### 配置准备

##### 电路连接

DS18B20有三个引脚：VCC，DQ，GND

其中VCC和DQ之间需接一个4K7的电阻，VCC接树莓派的3V3（pin1），DQ接GPIO4（pin7）,GND接GND（pin6）

![30-1](http://ohe7ixo05.bkt.clouddn.com/2016/5/30-1.jpg)

##### 升级内核

首先升级内核(如果系统版本较新，可跳过这一步)
（升级内核可能需要很长的时间）
```
sudo apt-get update
sudo apt-get upgrade
```

##### 加载单总线驱动

```
sudo modprobe w1-gpio
sudo modprobe w1-therm
```

**注意：**

系统升级后，有可能gpio读不了w1

**解决办法：**

打开/boot/config.txt 在最后一行手动添加这一行：
dtoverlay=w1-gpio-pullup,gpiopin=4

```
cd /boot
sudo nano config.txt
```

然后保存退出，重启树莓派，再把DS18B20接上，再次加载驱动即可

##### 查看设备是否工作

```
cd /sys/bus/w1/devices/
ls
```
![30-2](http://ohe7ixo05.bkt.clouddn.com/2016/5/30-2.jpg)

28-0000075a0d1c即为我使用的DS18B20的设备号

##### 查看当前温度值

进入到我的DSI8B20，使用命令查看数据

```
cd 28-0000075a0d1c
cat w1_slave
```

![30-3](http://ohe7ixo05.bkt.clouddn.com/2016/5/30-3.jpg)

第二行的t=18437就是当前的温度值，要换算成摄氏度，除以1000，即当前温度为18437/1000=18.437摄氏度。

#### python读取温度值

##### 新建文件

在/home/pi/目录下新建文件夹mytest，并在mytest下新建temp.py

```
mkdir mytest
cd mytest
touch temp.py
```
##### 编辑temp.py
```
nano temp.py
```
##### 编写代码

```
#-*-coding:utf8-*-
#打开你的DS18B20的数据文件
tfile = open("/sys/bus/w1/devices/28-0000075a0d1c/w1_slave")

#读取文件所有内容
text = tfile.read()

#关闭文件
tfile.close()

#用换行符分割字符串成数组，并取第二行
secondline = text.split("\n")[1]

#用空格分割字符串成数组，并取最后一个，即t=18437
temperaturedata = secondline.split(" ")[9]

#取t=后面的数值，并转换为浮点型
temperature = float(temperaturedata[2:])

#转换单位为摄氏度
temperature = temperature / 1000

#打印值
print temperature
```

##### 执行python脚本读取温度

```
python temp.py
```

#### 上传数据到yeelink云端

yeelink是一个开源的硬件数据平台，我喜欢把它定义为一个物联网云平台，因为它给我们提供了API接口，我们可以把数据发送到云平台保存起来，也可以随时查看，真的很棒。具体的操作可以查看博主的博客：《 树莓派+USB摄像头+yeelink实现云监控》。

##### 修改python代码

将温度值用JSON格式保存到一个文本文件（/home/pi/mytest/temper_data.txt），在转换单位为摄氏度后添加如下代码：

```
#数据转换成JSON格式
res = '{"value":%f}' %temperature

#打开文件
output = open('/home/pi/mytest/temper_data.txt', 'w')

#写数据到文本文件中
output.write(res)

#关闭文件
output.close

```

##### 新增yeelink.sh脚本

在/home/pi/mytest/目录下新建yeelink.sh

写入如下内容：

```
sudo python /home/pi/mytest/temp.py
curl --request POST --data-binary @"/home/pi/mytest/temper_data.txt" --header "U-ApiKey:XXXXXXXXXXXXXXXX" http://api.yeelink.net/v1.0/device/设备号/sensor/传感器号/datapoints
```

将XXXXXXXXXXXXXXXX替换为自已账户的API Key，后面的URL也需要替换为自己申请的传感器URL。

##### 为脚本增加可执行权限
```
sudo chmod +x yeelink.sh
```
##### 将脚本加入cronjob定时任务
```
sudo crontab -e
```
##### 让脚本自动运行

加入下面一行, 让脚本每1分钟运行一次，即每1分钟上传一次温度数据，然后保存退出

```
*/1 * * * * /home/pi/mytest/yeelink.sh
```

实验效果：

![30-4](http://ohe7ixo05.bkt.clouddn.com/2016/5/30-4.jpg)
