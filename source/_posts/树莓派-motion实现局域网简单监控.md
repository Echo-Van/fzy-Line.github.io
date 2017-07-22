---
title: 树莓派+motion实现局域网简单监控
date: 2016-06-14 11:28:26
tags: ［树莓派,监控,motion］
categories: 树莓派
---

#### 检查USB摄像头

主要检查摄像头是否被树莓派检测到（同博主上一篇树莓派的博客）

<!--more-->

如果没有你的摄像头的信息，那么有可能你的树莓派的电源无法供应足够的电力给你的摄像头。这时你可以给你的摄像头用独立的电源线，比如有源USB hub，并重新输入lsusb命令查看。如果摄像头还是不能被识别，我们只有建议你购买其他树莓派支持的摄像头了。

#### 配置motion

**注意：本文以Raspbian系统为例**

##### 安装motion

输入命令：

```
sudo apt-get install motion
```

##### 配置motion daemon 守护进程

输入命令编辑motion：

```
sudo nano /etc/default/motion
```

把里面的no修改成yes，让他可以一直在后台运行：

```
start_motion_daemon=yes
```

##### 修改motion的配置文件

（1）输入命令

```
sudo vim /etc/motion/motion.conf
```

（2）修改配置文件

将第11行的daemon off 改成daemon on，如下图：

![14-1](http://ohe7ixo05.bkt.clouddn.com/2016/6/14-1.jpg)

该文件很长，需要一直往下翻，直到464行你才看到端口号8081，我们通过这个端口来读取视频数据，这里无需修改！如下图：

![14-2](http://ohe7ixo05.bkt.clouddn.com/2016/6/14-2.jpg)

然后到第477行将stream_localhost on改成off，即关闭 localhost 的限制，如下图：

![14-3](http://ohe7ixo05.bkt.clouddn.com/2016/6/14-3.jpg)

当然，你也可以设定图片的分辨率，在第90行进行修改：
![14-4](http://ohe7ixo05.bkt.clouddn.com/2016/6/14-4.jpg)

最后，vim编辑器下按esc然后输入：wq，即保存退出。

##### 配置启动

（1）输入下面命令启动服务： 

```
sudo service motion start  
```

（2）输入以下命令开启motion：

```
sudo motion
```

##### 查看效果

打开浏览器，输入http://树莓派IP:8081即可查看拍到的图像，如下图：

![14-5](http://ohe7ixo05.bkt.clouddn.com/2016/6/14-5.jpg)

#### 需要注意的问题


##### 浏览器的问题

经过测试，Google浏览器和火狐浏览器可以访问到图像，IE、Microsoft Edge和360都不显示图像，而是提示下载，一直下载，其他的没有测试。

##### 局域网限制

之前看到别人的教程写的是外网也可以访问，实际上如果你没有配置你的树莓派成为服务器的话，你的树莓派的ip地址都是私有地址，外网无法访问，只能在局域网内部使用。

##### 摄像头的问题

树莓派供电不足也会影响视频质量，就像我上面的视频不是很清楚，我是直接用笔记本的USB供电的，一般来说笔记本USB口电流一般为500mA，所以如果需要视频清晰的话建议使用移动电源进行供电，或者使用有源USB hub。
