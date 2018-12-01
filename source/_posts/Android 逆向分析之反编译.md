---
title: Android 逆向分析之反编译
tags:
  - Android
  - 反编译
categories: Android
abbrlink: 37360
date: 2016-10-03 10:14:35
---

　　如果你已经具备一定的 Android 开发基础，那你一定会思考别人的 App 是怎么做的，在使用一款 App 的时候也会想它这个布局、这个效果是怎么实现的？思考是好事，但是全靠猜可不行，如何拿到他的源代码呢？反编译的作用不言而喻。直接拿别人的源码确实不太道德，所以我们提倡学习借鉴，而不是复制。

<!--more-->

**使用工具：**

- apktool（获取资源文件工具）

  [apktool官方地址](https://ibotpeaches.github.io/Apktool/)
  
- dex2jar（获取源码文件工具）

  [dex2jarGithub地址](https://github.com/pxb1988/dex2jar)

- jd-gui（源码查看工具）

  [jd-gui官方地址](http://jd.benow.ca/)


**工具打包下载地址：**

　　百度云链接：http://pan.baidu.com/s/1jHVHc4Q，密码：ra3u


　　**注：以下操作需要你的电脑安装JDK，我们假设你已经安装了，并配置好了环境变量。**

#### 反编译得到资源文件

　　apktool反编译得到程序的源代码、图片、XML配置、语言资源等文件。

##### 简单的使用

　　如果你只需要简单的反编译，那下面这条命令已经能够满足你的需求。在Windows下，使用cmd进入到下载的decompile文件夹，然后使用如下命令进行反编译：

```
apktool.jar d apk文件路径
```

##### 配置更多

　　如果你需要使用带参数的 apktool，体验更多的功能，或者你经常使用反编译，那建议你进行相应的配置。将decompile文件夹下的 apktool.jar 和 apktool.bat 移动/复制到 C:\Windows目录下(需要管理员权限)，如果不进行这一步，使用 apktool 命令时会提示： 'apktool' 不是内部或外部命令，也不是可运行的程序或批处理文件。此处操作的原理就是将 apktool 的文件加入到环境变量中，因为 C:\Windows 已经在系统的环境变量中，所以复制到该文件夹后，apktool 就成为了一个随处可用的命令。

　　比如使用 apktool 命令进行反编译：

```
apktool d apk文件路径
```

**apktool有如下参数可供使用：**

```
(1) -version 或者 --version 查看apktool版本信息

(2) -advance 或者 --advanced 输出更详细的信息

(3) d 或者 decode 反编译

(4) b 或者 build 编译

(5) -o 或者 --output <dir> apk反编译后输出到指定目录

---------------------------以上较常用-----------------------------

(6) -r 或者 --no-res 阻止反编译resource，不修改resources.arsc，若仅仅修改java（smail），建议使用该选项

(7) -s 或者 --no-src 阻止dex文件分割，在build时仅仅移动classes.dex，若需要快速打包，建议使用该选项

(8) -f 或者 --force-all 在打包时重写已经存在的文件，强制覆盖

(9) -t 或者 --frame-tag <TAG> 给生成的framework文件打上标识

(10) -p 或者 --frame-path <dir>指定framework文件储存的位置
```

　　使用 apktool 进行反编译之后可以得到 android 工程的 res 目录下的所有文件，以及 AndroidManifest.xml，还有一个 smali 文件夹，很可惜，这个文件夹里的文件并不是 java 文件，而是很多 smali 格式的文件。如下图所示：

![3-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/10/3-2.png)

　　因为 Android 系统有自己的虚拟机 Dalvik，代码编译最终不是采用的 java 的 class，而是使用的 smali。如果我们懂一点 smali 语法，那看懂这些文件也是不成问题的，但是我们有更好的办法，请看下一步。

#### Apk反编译得到Jar文件

1. 在 windows 下，使用 cmd 进入到下载的 decomplie 目录下的 dex2jar 文件夹
2. 将 apk 文件改成 rar 后者 zip 文件，然后解压得到 classes.dex 文件
3. 将解压得到的 classes.dex 文件复制到 dex2jar 文件夹内
4. 使用如下命令得到 classes-dex2jar.jar 文件

```
d2j-dex2jar.bat classes.dex文件的路径
```

![3-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/10/3-3.png)

　　在 dex2jar 文件夹可以看到生成了一个 classes-dex2jar.jar 的文件，然后通过下一步的工具即可查看项目java源码。

#### 使用jar查看器查看源码

　　打开下载的 decompile 文件夹中的 jd-gui-windows-1.4.0 目录下的 jd-gui.exe ，使用 jd-gui 打开上一步得到的jar文件即可看到项目的 java 源码，如下图所示：

![3-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/10/3-1.png)

　　此工具可用来查看 jar 文件，其实很多第三方的 jar 包也是可以通过此工具打开进行查看的。