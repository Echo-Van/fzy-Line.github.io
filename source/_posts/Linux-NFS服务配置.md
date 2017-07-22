---
title: Linux NFS服务配置
date: 2016-10-05 16:02:23
tags: [Linux,NFS]
categories: Linux
---

　　NFS（Network File System）即网络文件系统，是FreeBSD支持的文件系统中的一种，它允许网络中的计算机之间通过TCP/IP网络共享资源。在NFS的应用中，本地NFS的客户端应用可以透明地读写位于远端NFS服务器上的文件，就像访问本地文件一样。本博文记录了博主配置NFS服务的过程，并测试成功，希望对大家有所帮助。

<!---more-->

注：本博客基于CentOS7进行测试，并假设你已经具有一定的Linux操作基础。

#### 服务端配置

##### 安装必要的包

使用NFS服务需要安装两个包：nfs-utils和rpcbind

```
yum install -y nfs-utils
```

使用yum安装nfs-utils时会自动安装rpcbind

##### 配置/etc/exports文件

```
vim /etc/exports
```

在配置文件中增加内容，每一行分为三部分：

- 本地要共享出去的目录
- 允许访问的主机（ip或ip段）
- 权限选项

例如写入如下一行：

```
/home/fzy/ 192.168.0.1/24(rw,sync,all_squash,anonuid=501,anongid=501)
```

意思是：把/home/fzy/目录共享给ip地址为192.168.0.1/24的主机.

权限部分特别说明：

- **rw** 表示读/写
- **ro** 表示只读
- **sync** 表示数据同步写入内存缓冲区与磁盘中，效率较低，但可以保证数据的一致性（适合于小文件传输）
- **async** 表示数据先暂时放于内存，而非直接写入硬盘，等到必要时才写入磁盘（适合于大文件传输）
- **no_root_squash** 表示root用户对这个共享的目录拥有至高的控制权（不安全，不建议使用）
- **root_squash** 表示root用户对这个共享的目录的权限和普通用户一样。
- **all_squash** 表示不管使用NFS的用户是谁，其身份都会被限定成一个指定的普通用户。
- **no_all_squash** 表示所有的普通用户使用nfs都不使用权限压缩（默认设置）
- **anonuid/anongid** 要和root_squash以及all_squash选项一同使用，用于指定使用NFS的用户被限定后的uid和gid

##### 启动NFS服务

在启动nfs前，需先启动rpcbind

```
# service rpcbind start
# service nfs start
```

![5-1](http://ohe7ixo05.bkt.clouddn.com/2016/10/5-1.png)

虽然上面的命令能够正常启动服务，但是根据提示，我们应该使用如下命令来替换：

<pre>
# /bin/systemctl start rpcbind.service
# /bin/systemctl start nfs.service
</pre>

##### 关闭NFS服务

<pre>
# /bin/systemctl stop rpcbind.service
# /bin/systemctl stop nfs.service
</pre>

#### 客户端挂载NFS

##### 查看服务器共享的目录

```
# showmount -e 服务器ip地址
```

会得到如下的结果：

```
Export list for 服务器ip地址:
/home/fzy 客户端ip地址
```

##### 在客户端上挂载NFS

```
# mount -t nfs 服务器ip地址:服务器共享目录  挂载点
```

其中-t nfs 指定挂载的类型为nfs

##### 查看是否挂载成功

命令df用于查看已挂载磁盘的总容量、使用容量、剩余容量等。

```
# df -h
```

-h 表示使用合适的单位显示

如下图：

![5-2](http://ohe7ixo05.bkt.clouddn.com/2016/10/5-2.png)

##### 解除挂载

```
# umount 已挂载的目录
```

如果遇到：umount.nfs: 已挂载的目录: device is busy

可以添加-l参数，如下：

```
# umount -l 已挂载的目录
```

选项 –l 并不是马上umount，而是在该目录空闲后再umount，即延迟卸载。

##### 开机自动挂载

方法一：

/etc/fstab里添加如下内容：

```
服务器ip地址:共享的目录 客户端挂载点 nfs defaults 1 1 
```

第1个1表示备份文件系统，第2个1表示从/分区的顺序开始fsck磁盘检测，0表示不检测.

方法二（推荐）：

将手动挂载命令加入到/etc/rc.local中.


#### 命令exportfs

##### 命令选项

- -a 表示全部挂载或者卸载 
- -r 表示重新挂载
- -u 表示卸载某一目录
- -v 表示显示共享的目录

##### 使用命令

**修改配置文件/etc/exports后，使用exportfs命令挂载不需要重启NFS服务**

```
# exportfs -arv
```
