---
title: 树莓派+DHT11温湿度传感器+yeelink物联网云
tags: '［树莓派,DHT11,yeelink］'
categories: Raspberry Pi
abbrlink: 8959
date: 2016-06-02 11:04:13
---

#### 配置准备

##### DHT11简介

DHT11是一款有已校准数字信号输出的温湿度传感器。 精度湿度+-5%RH， 温度+-2℃，量程湿度20-90%RH， 温度0~50℃。

<!--more-->

![2-1](http://ohe7ixo05.bkt.clouddn.com/2016/6/2-1.jpg)

DHT11有四个引脚，分别是VCC，DATA，NC，GND

![2-2](http://ohe7ixo05.bkt.clouddn.com/2016/6/2-2.jpg)

##### 电路连接

本博文中python程序使用的是BCM编号方式，17号即pin11接DHT11的DATA，VCC接3.3V，NC悬空，GND接0V，可通过下图找到对应引脚，进行连线。

![2-3](http://ohe7ixo05.bkt.clouddn.com/2016/6/2-3.jpg)

#### 用python读取温湿度数据

关于DHT11具体的时序，以及如何操作，在我的博客《 51单片机DHT11温湿度传感器》中有详细分析，有兴趣可以去了解一下，以便你可以看懂下面的python程序。
```
#!/usr/bin/python

import RPi.GPIO as GPIO
import time

#BCM编号方式的17对应树莓派的pin11
channel = 17
data = []
j = 0

#I/O口使用BCM编号方式
GPIO.setmode(GPIO.BCM)

time.sleep(1)

#设置数据线为输出
GPIO.setup(channel, GPIO.OUT)

GPIO.output(channel, GPIO.LOW)
time.sleep(0.02)
GPIO.output(channel, GPIO.HIGH)

#设置数据线为输入
GPIO.setup(channel, GPIO.IN)

while GPIO.input(channel) == GPIO.LOW:
     continue

while GPIO.input(channel) == GPIO.HIGH:
     continue

while j < 40:
     k = 0
     while GPIO.input(channel) == GPIO.LOW:
         continue

     while GPIO.input(channel) == GPIO.HIGH:
         k += 1
         if k > 100:
             break

     if k < 8:
         data.append(0)
     else:
         data.append(1)

     j += 1

print "sensor is working."
print data

#读取数值
humidity_bit = data[0:8]
humidity_point_bit = data[8:16]
temperature_bit = data[16:24]
temperature_point_bit = data[24:32]
check_bit = data[32:40]

humidity = 0
humidity_point = 0
temperature = 0
temperature_point = 0
check = 0

#转换数值
for i in range(8):
     humidity += humidity_bit[i] * 2 ** (7 - i)
     humidity_point += humidity_point_bit[i] * 2 ** (7 - i)
     temperature += temperature_bit[i] * 2 ** (7 - i)
     temperature_point += temperature_point_bit[i] * 2 ** (7 - i)
     check += check_bit[i] * 2 ** (7 - i)

tmp = humidity + humidity_point + temperature + temperature_point

#数据校验
if check == tmp:
     print "temperature : ", temperature, ", humidity : " , humidity
else:
     print "wrong"
     print "temperature : ", temperature, ", humidity : " , humidity, " check : ", check, " tmp : ", tmp

GPIO.cleanup()
```

在python文件的路径下输入命令：

```
sudo python ./dht11.py
```
即可获得数据，效果如图：

![2-4](http://ohe7ixo05.bkt.clouddn.com/2016/6/2-4.jpg)

可以看到，当校验不正确时会打印出“wrong”，表示数据错误，在读取一次得到正常的数据。

#### 上传数据到yeelink

##### 修改python代码

在上面的代码后添加如下代码，即将温度和湿度数据保存到txt文件里：

```
#数据转换成JSON格式
mytemp = '{"value":%f}' %temperature
myhumi = '{"value":%f}' %humidity

#打开文件
tmp_output = open('/home/pi/mytest/DHT11/tmp_data.txt', 'w')
hud_output = open('/home/pi/mytest/DHT11/hud_data.txt', 'w')

#写数据到文本文件中
tmp_output.write(mytemp)
hud_output.write(myhumi)

#关闭文件
tmp_output.close
hud_output.close

```

##### 新增yeelink.sh脚本

yeelink是一个开源的硬件数据平台，我喜欢把它定义为一个物联网云平台，因为它给我们提供了API接口，我们可以把数据发送到云平台保存起来，也可以随时查看，真的很棒。具体的操作可以查看博主的博客：《 树莓派+USB摄像头+yeelink实现云监控》。

```
sudo python /home/pi/mytest/DHT11/dht11.py
curl --request POST --data-binary @"/home/pi/mytest/DHT11/tmp_data.txt" --header "U-ApiKey:XXXXXXXXXXXXXXXX" http://api.yeelink.net/v1.0/device/设备号/sensor/传感器号/datapoints
sleep 10s
curl --request POST --data-binary @"/home/pi/mytest/DHT11/hud_data.txt" --header "U-ApiKey:XXXXXXXXXXXXXXXX" http://api.yeelink.net/v1.0/device/设备号/sensor/传感器号/datapoints
```
"/home/pi/mytest/DHT11/tmp_data.txt"是需要上传到yeelink上的文件的路径，将XXXXXXXXXXXXXXXX替换为自已账户的API Key，后面的URL也需要替换为自己申请的传感器URL。

注意：因为DHT11可以获得温度和湿度两种值，所以我在yeelink添加了两个传感器，便于观察，在这里有两次上传数据，分别是把储存温度值得txt文本和储存湿度值得txt文本通过HTTP协议上传到云端。

##### 为脚本增加可执行权限

```
sudo chmod +x yeelink.sh
```

##### 将脚本加入cronjob定时任务

```
sudo crontab -e
```

##### 让脚本自动运行

加入下面一行, 让脚本每1分钟运行一次，即每1分钟上传一次数据，然后保存退出

```
*/1 * * * * /home/pi/mytest/yeelink.sh
```

注：我给自己的实验新建了几个文件夹，路径如下：/home/pi/mytest/DHT11/，很多操作都是在这个路径下完成的。

实验效果：

温度：

![2-5](http://ohe7ixo05.bkt.clouddn.com/2016/6/2-5.jpg)

湿度：

![2-6](http://ohe7ixo05.bkt.clouddn.com/2016/6/2-6.jpg)
