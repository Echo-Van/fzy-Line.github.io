---
title: Ubuntu16.04中Mysql 5.7 安装配置
tags:
  - Linux
  - Ubuntu
  - Mysql
categories: Linux
abbrlink: 2800
date: 2018-01-26 02:45:12
---

　　记录在Ubuntu 16.04安装Mysql 5.7时遇到的一些问题。

<!--more-->

##### Mysql安装

　　使用如下命令进行安装：

```
sudo apt-get install mysql-server mysql-client
```

　　检查安装是否成功以及MySQL是否运行：

```
sudo netstat -tap | grep mysql
```

　　启动/关闭/重启 Mysql：

```
sudo service mysql start    # 启动
sudo service mysql stop # 关闭
sudo service mysql restart  # 重启
```

　　通过以上步骤基本已经完成安装，但是我们也应该注意到，安装过程中都没有要求填写用户名和密码。终端输入mysql -u root -p之后，要求输入密码，但是我们并没有设置密码，随便输入之后，提示如下错误：

```
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
```

　　查找资料发现5.7版本与之前的版本不太一致，需要一些特殊的操作，具体请看下一节。

##### Mysql 5.7 root无法登录的问题

　　在这个文件里面有着MySQL默认的用户名和用户密码，用户名默认的不是root，而是debian-sys-maint，如下所示：

```
> cat /etc/mysql/debian.cnf 
```

![26-1](http://ohe7ixo05.bkt.clouddn.com/2018/1/26-1.png)

　　使用该账号进行登录：

```
> mysql -u debian-sys-maint -p
```

　　查询已有的数据库

```
> show databases;
```

　　操作mysql数据库：

```
> use mysql
```

　　查看mysql数据库中有哪些表：

```
> show tables;
```

　　可以看到有一个user表，我们查询user表中的用户和密码：

```
select user,authentication_string from user
```

![26-2](http://ohe7ixo05.bkt.clouddn.com/2018/1/26-2.png)

　　注意：这里不能查询password字段（如下命令），因为在新版本中password字段已经被authentication_string字段替换。

```
> select user,password from user
```

　　更新user表中root用户的密码：

```
> update user set authentication_string=password('新密码') where user='root';
```

　　重新加载权限表，一定要进行这一步，否则更新不会生效：

```
flush privileges
```

　　最后，即可使用root用户以及我们设置的密码进行登录：

```
> mysql -u root -p

```

　　注意：由于用户debian-sys-maint的信息可以从文件中查找到，因此最好将其密码也改一下。