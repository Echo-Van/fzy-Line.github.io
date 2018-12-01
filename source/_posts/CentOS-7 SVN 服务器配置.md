---
title: CentOS-7 SVN 服务器配置
tags:
  - Linux
  - SVN
categories: Linux
abbrlink: 64672
date: 2016-08-30 15:03:53
---

　　SVN 是 Subversion 的简称，它是一个受欢迎的开放源代码的版本控制系统。简单一点说，SVN 就是用于多个人共同开发同一个项目，共用资源的目的。作为软件开发人员，很有必要了解和学习 SVN 的使用。学习版本控制从 SVN 安装与配置开始，此篇博客主要讲解基于阿里云服务器的 SVN 服务器配置。

<!-- more --> 

#### 版本控制

　　版本控制系统（VCS）是一个软件，帮助软件开发人员团队工作并维持他们完整的工作历史。版本控制系统（VCS）的目标：

- 允许开发者们同时工作
- 不会重写每个人的改变
- 维持每个版本的全部的历史

VCS 被分成两种：

- 集中版本控制系统（CVCS）和
- 分散或不集中的版本控制系统（DVCS）

Subversion 基于集中的版本控制系统，意味着使用统一的服务器让团队协作。

#### 安装SVN

　　大多数 GNU/Linux 发行版系统自带，所以它很有可能已经安装在你的系统上了。可以使用下面命令检查是否安装了。

```shell
$ svn --version
```

　　如果系统已经安装 Subversion 客户端，使用上面的命令会出现安装的软件版本，否则会提示命令找不到。如果你使用基于 RPM 的 GNU/Linux，可以切换到 root 用户使用 yum 命令进行安装，安装成功之后，执行 svn --version 命令。

```shell
$ yum install subversion
```

　　如果你使用基于 Debian 的 GNU/Linux，使用 apt 命令进行安装。

```shell
$ sudo apt-get update
```

　　另外，还需要安装 Apache httpd 模块，如果没有安装请自行百度吧，这里主要讲解如何配置 SVN。

　　注：博主租用的阿里云的服务器，采用 CentOS 系统，自带 SVN，并且我已经安装好了 Apache httpd 模块。

#### 创建目录保存所有的工作

```shell
$ mkdir -p /var/svn
```

#### 创建版本库

```shell
$ svnadmin create /var/svn/repo
```

　　创建完成后，可以使用 ls 命令看到，在版本库中存在如下文件：

```shell
$ conf db format hooks locks README.txt
```

#### 配置版本库

在 conf 目录下有如下三个文件：


- svn 服务综合配置文件（svnserve.conf）

- 用户名口令文件（passwd）

- 权限配置文件（authz）


##### 配置 svnserve.conf 文件

　　找到以下四行，删除前面的注释符使其起作用：

```
anon-access = read  #匿名用户可读
auth-access = write #授权用户可写
password-db = passwd    #使用哪个文件作为账号文件
authz-db = authz.conf   #使用哪个文件作为权限文件
```

##### 配置 passwd 文件

　　在 [users] 块中添加用户和密码，格式：帐号=密码，例如添加如下两个账户：

```
[users]
fzy = 123456
hunau = 111111
```

##### 配置 authz 文件

　　在末尾添加如下代码：

```
[/]
fzy = rw
hunau = r
```

　　意思是版本库的根目录 fzy 用户对其有读写权限，hunau 用户只有读权限。


#### 启动和使用

　　配置成功以后，使用如下命令启动 svn 版本库服务：

```shell
$ svnserve -d -r /var/svn     #其中/var/svn为版本库根目录
```

　　查看是否启动成功：

```shell
$ ps -ef|grep svnserve
```

##### 关闭 svn 服务

1. 使用以下命令查找进程 

```shell
ps aux | grep svn
```

　　如下：
```
root     22368     1  0 Aug29 ?        00:00:00 svnserve -d -r /var/svn
root     24538 24423  0 19:58 pts/0    00:00:00 grep --color=auto svn
```

2. 使用Kill命令杀死进程 

```shell
kill -s 9 22368     #其中22368 为进程ID
```

#### Windwos 客户端安装与使用

1. 下载安装 SVN Windows 客户端：TortoiseSVN

下载地址：[https://tortoisesvn.net/downloads.html](https://tortoisesvn.net/downloads.html)

2. 新建一个文件夹用来存放版本库文件

3. 右键选择 SVN Checkout

![30-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/8/30-1.png)

4. 填写 SVN 地址

![30-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/8/30-2.png)

　　格式为：

```
svn://服务器ip地址/服务器上版本库名称/
```

5. 输入用户名密码

![30-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/8/30-3.png)

　　可以勾选保存账号密码，如果你只用一个账号的话可以这么做，如果需要经常切换账户的话最好不要勾选。如果已经勾选了，但是又需要切换账户，怎么办呢？

　　右键菜单：Settings -> Saved Data-> Authentication data -> Clear

6. 在 repo 文件夹下进行版本控制操作

![30-4](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/8/30-4.png)

　　可以将服务器上的文件通过 SVN Update 更新到本地，也可以将本地文件通过 SVN commit 提交到服务器，还有很多的操作，在这里就不一一讲解了，下次写一篇详细的博客进行介绍。

　　注：文件上传到服务器后存放在服务器什么地方呢？

　　一般放在版本库路径下的 db 文件夹的 revs 文件夹中，例如我的为 /var/svn/repo/db/revs。

#### 需要注意的地方

##### checkout时，提示：URL svn://服务器ip地址/repo doesn't exist...

　　奇怪，怎么会提示库不存在呢？肯定是哪里配置问题。后来尝试了半天，也在网上搜索了很久，终于发现问题所在。

　　如果你的 SVN 库的路径为：/var/svn/repo，那么你启动时，不能用命令：

```shell
svnserve -d -r /var/svn/repo
```

　　而要用命令：
```shell
svnserve -d -r /var/svn/
```

##### commit时，提示：Authorization failed

　　问题可能出在 svnserve.conf 这个文件。注意以下四行一定要取消注释：

```
# anon-access = read
# auth-access = write
# password-db = passwd
# authz-db = authz
```

　　问题也有可能出在 authz 文件里，用户组或者用户权限没有配置好，只要设置[/]就可以，代表根目录下所有的资源，如果要限定资源，可以加上子目录即可。




