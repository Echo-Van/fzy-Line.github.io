---
title: '[转]Ubuntu下修改环境变量的三种方法'
tags:
  - Ubuntu
categories: 转载
abbrlink: 23766
date: 2017-06-22 15:03:37
---

Ubuntu下设置环境变量有三种方法，一种用于当前终端，一种用于当前用户，一种用于所有用户。

<!--more-->

#### 用于当前终端

在当前终端中输入：

```
export PATH=$PATH:<你的要加入的路径>
```

不过上面的方法只适用于当前终端，一旦当前终端关闭或在另一个终端中，则无效。

例如：

```
export NDK_ROOT=/home/jiang/soft/Android-ndk-r8e 
```

这样只能在当前终端使用。

#### 用于当前用户

在用户主目录下有一个 .bashrc 隐藏文件，可以在此文件中加入 PATH 的设置如下：

```
$ vi ~/.bashrc
```

加入：

```
export PATH=<你的要加入的路径>:$PATH
```

例如：

```
export PATH=/home/jiang/soft/Android-ndk-r8e:$PATH 
```

如果要加入多个路径，只要：

```
export PATH=<你要加入的路径1>:<你要加入的路径2>: ...... :$PATH
```

当中每个路径要以冒号分隔。

这样每次登录都会生效

#### 用于所有用户

```
sudo vi /etc/profile 
```

加入：

```
export PATH=<你要加入的路径>:$PATH
```

终端输入：echo $PATH 可以查看环境变量

**注意，修改环境变量后，除了第一种方法立即生效外，第二第三种方法要立即生效，可以source ~/.bashrc或者注销再次登录后就可以了！**