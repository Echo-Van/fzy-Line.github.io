---
title: Ubuntu中ftp服务器安装与配置
tags:
  - FTP
  - Ubuntu
  - Linux
categories:
  - Linux
abbrlink: 14389
date: 2017-09-14 20:15:06
---


　　最近需要用到ftp，所以在腾讯云服务器上搭建了一个ftp服务器，简单记录一下Ubuntu Server中ftp服务器的初步配置。

<!--more-->

#### ftp服务器安装

##### 用apt-get工具安装vsftpd

```
$ sudo apt-get install vsftpd
```

##### 检查FTP端口是否已经打开

ftp默认情况下，命令端口是21，数据端口就是20

```
$ netstat -tnl
```

或者直接在浏览器里输入“ftp://服务器IP”

##### 启动vsftpd服务

```
$ service vsftpd start
或
$ /etc/init.d/vsftpd start
```

##### 停止vsftpd服务

```
$ service vsftpd stop
或
$ /etc/init.d/vsftpd stop
```

##### 重启vsftpd服务

```
$ service vsftpd restart
或
$ /etc/init.d/vsftpd restart
```

##### 查看服务状态

```
$ sudo service vsftpd status
```

#### ftp服务器配置

##### 配置文件

-  主配置文件：/etc/vsftp.conf
-  权限限制用户列表文件：/etc/vsftp.chroot_list
-  认证配置文件：/etc/pam.d/vsftpd

##### 主配置文件

　　修改主配置文件

```
$ sudo nano /etc/vsftpd.conf
```

```
anonymous_enable=NO（是否允许匿名登陆）
local_enable=YES（是否允许本地登陆）
write_enable=YES（设置FTP可写）
```

　　**chroot：change root directory**

　　**chroot_local_user：** 是否将所有用户限制在主目录,YES为启用 NO禁用.(该项默认值是NO,即在安装vsftpd后不做配置的话，ftp用户是可以向上切换到要目录之外的)

　　**chroot_list_enable：** 是否启动限制用户的名单 YES为启用  NO禁用(包括注释掉也为禁用)

　　**chroot_list_file=/etc/vsftpd/chroot_list：** 是否限制在主目录下的用户名单，至于是限制名单还是排除名单，这取决于chroot_local_user的值。文件默认是并不存在，需要手动创建.

![14-1](http://ohe7ixo05.bkt.clouddn.com/2017/9/14-1.png)

```
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd.chroot_list
```

　　我是用的是全局禁止跳出主目录，使用chroot_list添加例外！即，chroot_local_user=YES，chroot_list_enable=YES

```
pam_service_name=vsftpd（这里有可能会出现530的错误，导致ftp用户无法登录，与后面的认证配置文件有关）
```

　　530错误：

![14-2](http://ohe7ixo05.bkt.clouddn.com/2017/9/14-2.png)

##### 权限限制用户列表

　　修改权限限制用户列表文件

```
$ sudo nano /etc/vsftpd.chroot_list
```

　　具体作用与chroot_local_user和chroot_list_enable的配置有关，参考上面的表格进行相应的添加或删除，一行对应一个用户。

##### 认证配置文件

　　修改可访问用户列表文件，

```
$ sudo nano /etc/vsftpd.chroot_list
```

```
# Standard behaviour for ftpd(8).
auth    required        pam_listfile.so item=user sense=deny file=/etc/ftpusers onerr=succeed

# Note: vsftpd handles anonymous logins on its own. Do not enable pam_ftp.so.

# Standard pam includes
@include common-account
@include common-session
@include common-auth
#auth   required        pam_shells.so
```

　　**在这里，注释掉最后一行可以避免530错误。**

![14-3](http://ohe7ixo05.bkt.clouddn.com/2017/9/14-3.png)

#### 用户管理

##### 添加ftp用户

- 创建用户

```
$ sudo useradd username
```

Linux的useradd命令如下：

```
useradd(选项)(参数)
```

　　选项参数如下：

```
-c<备注>：加上备注文字。备注文字会保存在passwd的备注栏位中；
-d<登入目录>：指定用户登入时的启始目录
-D：变更预设值；
-e<有效期限>：指定帐号的有效期限；
-f<缓冲天数>：指定在密码过期后多少天即关闭该帐号；
-g<群组>：指定用户所属的群组；
-G<群组>：指定用户所属的附加群组；
-m：自动建立用户的登入目录；
-M：不要自动建立用户的登入目录；
-n：取消建立以用户名称为名的群组；
-r：建立系统帐号；
-s：指定用户登入后所使用的shell；
-u：指定用户id。
```

- 设置用户口令

```
$ sudo passwd username
```

　　然后输入两次密码即可。

##### 删除ftp用户

```
$ sudo userdel username
```

#### 卸载vsftpd

```
$ sudo apt-get remove --purge vsftpd
```

　　--purge 选项表示彻底删除改软件和相关文件

#### 无权限错误

　　使用cmd的ftp可以正常登录，但是使用windows的文件管理器登录到ftp服务器时报错的问题：

![14-4](http://ohe7ixo05.bkt.clouddn.com/2017/9/14-4.png)

　　在主配置文件中添加：

```
pasv_promiscuous=YES
```

　　此选项激活将关闭pasv的安全检查，关于ftp的port模式和pasv模式将在以后的博客中介绍。

#### 500 OOPS错误

　　500 OOPS: vsftpd: refusing to run with writable root inside

![14-5](http://ohe7ixo05.bkt.clouddn.com/2017/9/14-5.png)

　　在主配置文件中添加：

```
allow_writeable_chroot=YES
```
