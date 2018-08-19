---
title: 树莓派+USB摄像头+yeelink实现云监控
tags: '［树莓派,监控,yeelink］'
categories: Raspberry Pi
abbrlink: 22224
date: 2016-06-10 11:20:43
---

#### 配置USB摄像头

##### 检查摄像头是否被树莓派检测到

输入命令：

```
$ lsusb
```

<!--more-->

##### 查看输出信息

 ![10-1](http://ohe7ixo05.bkt.clouddn.com/2016/6/10-1.jpg)

如上图我们可以看到camera的信息，如果没有你的摄像头的信息，那么有可能你的树莓派的电源无法供应足够的电力给你的摄像头。这时你可以给你的摄像头用独立的电源线，比如有源USB hub，并重新输入lsusb命令查看。如果摄像头还是不能被识别，我们只有建议你购买其他树莓派支持的摄像头了。


##### 安装fswebcam

要想拍摄照片，你要安装fswebcam，这是一款小型摄像头程序。你可以直接通过Raspbian的仓库来安装fswebcam。

 输入命令：

```
sudo apt-get install fswebcam
```


#### 配置yeelink云端


 - 到[yeelink官网](http://www.yeelink.net/)注册一个账号

 - 添加一个新设备,填写基本信息
![10-2](http://ohe7ixo05.bkt.clouddn.com/2016/6/10-2.jpg)

 - 点击管理设备，然后添加一个传感器
![10-3](http://ohe7ixo05.bkt.clouddn.com/2016/6/10-3.jpg)

 - 查看API文档
![10-4](http://ohe7ixo05.bkt.clouddn.com/2016/6/10-4.jpg)
![10-5](http://ohe7ixo05.bkt.clouddn.com/2016/6/10-6.jpg)


#### 配置shell脚本

 - 创建shell脚本
输入命令
```
touch yeelink.sh
```

 - 打开yeelink.sh
输入命令：
```
nano yeelink.sh
```
 - 编辑yeelink.sh
 写入如下两行，然后保存退出：

```
sudo fswebcam -d /dev/video0 -r 800x600 --bottom-banner --title "RaspberryPi@Yeelink" --save /home/pi/yeelink.jpg
curl --request POST --data-binary  @"/home/pi/yeelink.jpg" --header "U-ApiKey:这里填写你自己的ApiKey" http://api.yeelink.net/v1.0/device/你的设备码/sensor/你的传感器码/photos
```
- 为脚本增加可执行权限
输入命令：

```
chmod +x yeelink.sh
```
- 将脚本加入cronjob定时任务
输入命令：

```
crontab -e
```

- 加入下面一行, 让脚本每分钟运行一次,即发送一张图片，然后保存退出

```
*/1 * * * * /home/pi/yeelink.sh
```

至此，我们的项目就完成了，我们可以到yeelink网站上去管理我们的设备，可以看到每隔一分钟会收到一张图片。如下图是我测试时的图片：

![10-5](http://ohe7ixo05.bkt.clouddn.com/2016/6/10-5.jpg)
