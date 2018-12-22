---
title: Raspberry Pi 开启 SSH 服务
tags:
  - Raspberry Pi
  - SSH
categories:
  - IoT
  - Raspberry Pi
abbrlink: 10389
date: 2018-11-16 20:00:56
---

　　解决新版本 Raspbian 操作系统默认不开启 SSH 服务的问题。

<!--more-->

　　旧版 Raspberry Pi 的 Raspbian 系统默认开启 SSH 功能，但是新版默认是关闭的，这对于没有显示器，需要通过 SSH 连接的用户带来一些不便，这里总结了 Raspbian 中几种开启 SSH 的方法。

##### 方法 1

　　将TF卡取下来，插上电脑，在  TF 卡的根目录下创建一个空白的文件，文件名叫：ssh。系统启动后会自动开启 ssh 服务。

##### 方法 2

　　检查 Raspberry Pi SSH 服务是否开启：

```bash
  ps -e | grep ssh
```

![16-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/11/16-1.png)

　　ssh-agent 为客户端，sshd 为服务器端服务，只有 ssh-agent 没有 sshd 表明 SSH 服务还没有开启。如果发现没有安装 SSH 服务，则使用以下命令安装：

```bash
$ sudo apt-get install openssh-server
```

　　如果已经安装，但是没开启，则使用以下命令开启 SSH 服务：

```bash
$ sudo /etc/init.d/ssh start
```

　　如果需要修改 SSH 服务的配置，则需要找到 openssh-server 的配置文件 `/etc/ssh/sshd_config`，其中包含 SSH 服务的各项参数，如默认端口为 22，可以配置为其他端口，配置后重启生效。

　　另外，也可以设置 SSH 服务开机自动启动，打开 `/etc/rc.local` 文件：

```bash
$ sudo nano /etc/rc.local
```

　　在语句 `exit 0` 之前加入：

```
 /etc/init.d/ssh start
```

##### 方法 3

　　在 Raspbian 依次打开 菜单（Menu） > 首选项（Preferences） > Raspberry Pi Configuration，然后点击 Interfaces 栏，选择 “enable” SSH服务：

![16-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2018/11/16-2.png)

##### 方法 4

　　使用命令进入 Raspberry Pi 的系统配置界面：

```bash
$ sudo raspi-config
```

　　然后，选择 “5 Interfacing Options”，回车，再选择第二项 SSH，回车，选择 yes，回车，搞定！







