---
title: Python daemon守护进程
tags:
  - Python
categories:
  - Coding
  - Python
abbrlink: 2070
date: 2019-06-24 20:09:42
---

<center>Python daemon 守护进程学习与总结。</center>

<!--more-->

#### 守护进程

##### 定义

　　守护进程是生存期长的一种进程。它们独立于控制终端并且周期性的执行某种任务或等待处理某些发生的事件。他们常常在系统引导装入时启动，在系统关闭时终止。

##### 特性

- 在后台运行。
- 与其运行前的环境隔离开来。这些环境包括未关闭的文件描述符、控制终端、会话和进程组、工作目录以及文件创建掩码等。这些环境通常是守护进程从执行它的父进程（特别是shell）中继承下来的。
- 启动方式特殊，它可以在系统启动时从启动脚本 /etc/rc.d 中启动，可以由 inetd 守护进程启动，可以由 crond 启动，还可以由用户终端（通常是 shell）执行。

　　总之，除开这些特殊性以外，守护进程与普通进程基本上没有什么区别。因此，编写守护进程实际上是把一个普通进程按照上述的守护进程的特性改造成为守护进程。

##### 编程规则

- 在后台运行，调用 fork ，然后使父进程 exit。
- 脱离控制终端，登录会话和进程组，调用 setsid() 使进程成为会话组长。
- 禁止进程重新打开控制终端。
- 关闭打开的文件描述符，调用 fclose()。
- 将当前工作目录更改为根目录。
- 重设文件创建掩码为 0。
- 处理 SIGCHLD 信号。

#### Python 实现

##### 样例

```python
# coding=utf8
import os
import sys
import atexit
 
def daemonize(pid_file=None):
    """
    创建守护进程
    :param pid_file: 保存进程id的文件
    :return:
    """
    # 从父进程fork一个子进程出来
    pid = os.fork()
    # 子进程的pid一定为0，父进程大于0
    if pid:
        # 退出父进程
        sys.exit(0)
 
    # 子进程默认继承父进程的工作目录，最好是变更到根目录，否则回影响文件系统的卸载
    os.chdir('/')
    # 子进程默认继承父进程的umask（文件权限掩码），重设为0（完全控制），以免影响程序读写文件
    os.umask(0)
    # 让子进程成为新的会话组长和进程组长
    os.setsid()
 
    # 注意了，这里是第2次fork，也就是子进程的子进程，我们把它叫为孙子进程
    _pid = os.fork()
    if _pid:
        # 退出子进程
        sys.exit(0)
 
    # 此时，孙子进程已经是守护进程了，接下来重定向标准输入、输出、错误的描述符(是重定向而不是关闭, 这样可以避免程序在 print 的时候出错)
 
    # 刷新缓冲区先，小心使得万年船
    sys.stdout.flush()
    sys.stderr.flush()
 
    # dup2函数原子化地关闭和复制文件描述符，重定向到/dev/nul，即丢弃所有输入输出
    with open('/dev/null') as read_null, open('/dev/null', 'w') as write_null:
        os.dup2(read_null.fileno(), sys.stdin.fileno())
        os.dup2(write_null.fileno(), sys.stdout.fileno())
        os.dup2(write_null.fileno(), sys.stderr.fileno())
 
    # 写入pid文件
    if pid_file:
        with open(pid_file, 'w+') as f:
            f.write(str(os.getpid()))
        # 注册退出函数，进程异常退出时移除pid文件
        atexit.register(os.remove, pid_file)
```

##### 开源项目

　　Github 开源项目：[python-daemon](https://github.com/serverdensity/python-daemon.git) 提供了 Python 版本的守护进程化实现。提供了以下方法：

- `start()` - starts the daemon (creates PID and daemonizes).
- `stop()` - stops the daemon (stops the child process and removes the PID).
- `restart()` - does `stop()` then `start()`.

　　直接继承 Daemon 类即可，使用示例：

```python
from daemon import Daemon

class pantalaimon(Daemon):
    def run(self):
        # Do stuff

# 指定 pid 文件的路径
pineMarten = pantalaimon('/path/to/pid.pid')
pineMarten.start()
```