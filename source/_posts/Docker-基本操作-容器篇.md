---
title: Docker 基本操作-容器篇
tags:
  - Docker
categories:
  - Cloud Computing
abbrlink: 53168
date: 2019-02-12 22:06:15
---

<center>Docker 容器基本操作介绍。</center>

<!--more-->

#### 启动与运行

　　启动容器有两种方式，一种是基于镜像新建一个容器并启动，另外一个是将在终止状态（stopped ） 的容器重新启动。使用 `docker run` 或 `docker container run`  命令基于镜像新建并启动一个新的容器。

```shell
$ docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
or
$ docker container run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

- 选项 `-d` ：表示后台运行；
- 选项 `-i`：以交互模式运行容器，通常与 `-t` 同时使用；
- 选项 `-t`：为容器重新分配一个伪输入终端，通常与 `-i` 同时使用；
- 选项 `-P` ：随机端口映射；
- 选项 `-p` ：指定端口映射，有 4 种形式：`ip:hostPort:containerPort` 、`ip::containerPort` 、`hostPort:containerPort` 、`containerPort ` ；
- 选项 `--network ` ：指定网络模式， 该选项有以下可选参数： 
  - `--network=bridge`： 默认选项， 表示连接到默认的网桥；
  - `--network=host`： 容器使用宿主机的网络；
  - `--network=container:NAME_or_ID`： 告诉 Docker 让新建的容器使用已有容器的网络配置；
  - `--network=none`： 不配置该容器的⽹络， 用户可自定义网络配置。 
- 选项 `--dns`： 指定容器使用的 DNS 服务器，默认和宿主一致；
- ......（参数列表可查看官方文档）

　　当利用 `docker run` 或 ``docker container run` 命令来创建容器时，Docker 在后台运行的标准操作包括：

- 检查本地是否存在指定的镜像，不存在就从公有仓库下载
- 利用镜像创建并启动一个容器
- 分配一个文件系统，并在只读的镜像层外面挂载一层可读写层
- 从宿主主机配置的网桥接口中桥接一个虚拟接口到容器中去
- 从地址池配置一个 ip 地址给容器
- 执行用户指定的应用程序
- 执行完毕后容器被终止

　　操作示例，使用容器输出一个 “Hello World”，之后终止容器： 

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker run ubuntu /bin/echo 'Hello world'
Hello world
```

##### 交互模式

　　`docker run` 或 `docker container run`  命令，通过 `-t` 选项让 Docker 分配一个伪终端并绑定到容器的标准输入上，`-i` 选项则让容器的标准输入保持打开。

　　通过 `ctrl+p+q` 可以退出容器但不关闭,，使用 `docker ps` 查看有运行的容器的信息，示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker run -it ubuntu
root@bd60ba8b2925:/# 此时，已是分配的绑定到容器的伪终端
root@d8fdaf7ec19b:/# root@iZwz96uyro861qckgz89ljZ:~# 此时，ctrl+p+q 退回到宿主机的终端
root@iZwz96uyro861qckgz89ljZ:~# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
d8fdaf7ec19b        ubuntu              "/bin/bash"         16 seconds ago      Up 16 seconds                           awesome_wiles
```

　　而，使用 `ctrl+d` 或者`exit` 则可以直接退出容器且关闭，`docker ps` 查看无信息。示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker run -it ubuntu
root@bd60ba8b2925:/# exit
exit
root@iZwz96uyro861qckgz89ljZ:~# 通过exit退出，返回到宿主机的终端
root@iZwz96uyro861qckgz89ljZ:~# 
```

##### 后台运行

　　`docker run` 或 `docker container run`  命令，通过添加 `-d` 参数让 Docker 在后台运行而不是直接把执行命令的结果输出在当前宿主机下。

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker run -d ubuntu /bin/bash -c "while true; do echo hello world; sleep 1; done"
5ed90f3deafe93f0102f0ecc619550c965334ff0a772fecc377cbefab5cdfc4c
```

　　使用 `-d` 参数启动后会返回一个唯一的 id，并不会把输出的结果打印到宿主机上面，可以通过 `docker ps` 或 `docker container ls` 命令来查看容器信息。 要获取容器的输出信息，可以通过 `docker container logs` 命令。示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker logs 5ed90f3deafe
hello world
hello world
hello world
```

　　注： 容器是否会长久运行，是和 `docker run` 或 `docker container run`  指定的命令有关，和 `-d` 参数无关。 

#### 列出容器

　　命令 `docker ps` 和 `docker container ls` 用于列出运行中的容器。如需列出所有容器（包括已停止的容器），可使用 `-a` 参数。

```shell
$ docker ps [OPTIONS]
or
$ docker container ls [OPTIONS]
```

- 选项 `--all, -a` ：显示所有的容器，包括未运行的；
- 选项 `--filter, -f` ：根据条件过滤显示的内容；
- 选项 `--format` ：指定返回值的模板文件；
- 选项  `--latest, -l` ：显示最近创建的容器；
- 选项 `--last , -n` ：列出最近创建的n个容器；
- 选项 `--no-trunc` ：不截断输出；
- 选项 `--quiet, -q` ：静默模式，只显示容器编号；
- 选项 `--size , -s` ：显示总的文件大小。

　　操作示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker run -d ubuntu /bin/bash -c "while true; do echo hello world; sleep 1; done"
5ed90f3deafe93f0102f0ecc619550c965334ff0a772fecc377cbefab5cdfc4c
root@iZwz96uyro861qckgz89ljZ:~# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
5ed90f3deafe        ubuntu              "/bin/bash -c 'while…"   3 seconds ago       Up 2 seconds                            ecstatic_nobel
```

- `CONTAINER_ID`： 表示容器ID。
- `IMAGE`： 表示镜像名称。
- `COMMAND`： 表示启动容器时运行的命令。
- `CREATED`： 表示容器的创建时间。
- `STATUS`： 表示容器运行的状态。 Up 表示运行中， Exited 表示已停止。
- `PORTS`： 表示容器对外的端口号。
- `NAMES`： 表示容器名称。 该名称默认由 `Docker` 自动生成， 也可使用 `docker run` 命令的 `--name` 选项
  自行指定。 

#### 进入容器

　　使用交互模式启动一个容器，再通过 `ctrl+p+q` 退回到宿主机的终端，即切换到后台运行：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker run -it ubuntu
root@76866ccb8619:/# root@iZwz96uyro861qckgz89ljZ:~# 此时，ctrl+p+q 退回到宿主机的终端，容器没有被关闭
root@iZwz96uyro861qckgz89ljZ:~# docker ps # 查看容器状态
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
76866ccb8619        ubuntu              "/bin/bash"         10 seconds ago      Up 9 seconds                            condescending_ptolemy
```

　　此时，如果想要进入运行着的容器则可以使用命令 `docker attach` 、`nsenter`和 `docker exec` 。

##### docker attach

　　使用 `docker attach` 或 `docker container attach` 命令进入容器。命令格式： 

```shell
$ docker attach [OPTIONS] CONTAINER COMMAND [ARG...]
or
$ docker container attach [OPTIONS] CONTAINER
```

　　操作示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker attach 76866ccb8619
root@76866ccb8619:/# 已经进入到容器内
```

　　但是，很多场景下， 使用 `docker attach` 命令并不方便。 当多个窗口同时 `attach` 到同⼀个容器时， 所有窗口都会同步显示。 同理， 如果某个窗口发生阻塞， 其他窗口也无法执行操作。 

##### nsenter

　　nsenter 工具可以访问另一个进程的名称空间，它已经被包含在 util-linux 2.23 或更高版本中。为了连接到容器， 需要找到容器第⼀个进程的 PID 。首先，使用 `docker inspect` 来查看该容器的详细信息，截取 PID 部分进行显示：

```shell
$ docker inspect -f {{.State.Pid}} $CONTAINER_ID
```

　　获得 PID 后， 然后使用 nsenter 命令进入容器：

```shell
$ nsenter --target "$PID" --mount --uts --ipc --net --pid
```

　　操作示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
76866ccb8619        ubuntu              "/bin/bash"         10 seconds ago      Up 9 seconds                            condescending_ptolemy
root@iZwz96uyro861qckgz89ljZ:~# docker inspect -f {{.State.Pid}} 76866ccb8619
31542
root@iZwz96uyro861qckgz89ljZ:~# nsenter --target 31542 --mount --uts --ipc --net --pid    
mesg: ttyname failed: No such device
root@76866ccb8619:/# 已经进入到容器内
```

　　测试发现，通过这种，`ctrl+p+q` 也无法退回到宿主机的终端，需要使用 `exit` ，此时的 `exit` 并不会关闭容器。

```shell
root@76866ccb8619:/# 此时，ctrl+p+q 也无法退回到宿主机的终端
root@76866ccb8619:/# exit
logout
root@iZwz96uyro861qckgz89ljZ:~# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
76866ccb8619        ubuntu              "/bin/bash"         9 minutes ago       Up 9 minutes                            condescending_ptolemy
```

##### docker exec（推荐）

　　在运行的容器中执行命令 `docker exec` 。命令格式：

```shell
$ docker exec [OPTIONS] CONTAINER COMMAND [ARG...]
```

- 选项 `-d` ：分离模式，在后台运行；
- 选项 `-i` ：即使没有附加也保持 STDIN 打开；
- 选项 `-t` ：分配一个伪终端；

　　只用 `-i` 参数时，由于没有分配伪终端，界面没有我们熟悉的 Linux 命令提示符，但命令执行结果仍然可以返回。当 `-i -t` 参数一起使用时，则可以看到我们熟悉的 Linux 命令提示符。

　　注意，该命令必须提供两个参数，一是容器名或ID，二是在运行的容器中执行的命令。操作示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker exec -it 76866ccb8619 /bin/bash
root@76866ccb8619:/#
```

#### 终止容器

　　命令`docker stop` 和 `docker container stop` 命令用于终止容器。命令格式： 

```shell
$ docker stop [OPTIONS] CONTAINER [CONTAINER...]
or
$ docker container stop [OPTIONS] CONTAINER [CONTAINER...]
```

- 选项 `--time, -t` ：强制杀死容器前等待的时间， 单位是秒，默认值 10。

　　当 Docker 容器中指定的应用终结时，容器也自动终止。 终止状态的容器可以用 `docker container ls -a` 命令看到。 处于终止状态的容器，可以通过 `docker container start` 命令来重新启动。此外， `docker container restart` 命令会将一个运行态的容器终止，然后再重新启动它。 

　　操作示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker stop 76866ccb8619
76866ccb8619
root@iZwz96uyro861qckgz89ljZ:~# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

#### 启动已终止容器

　　对于已停止的容器， 可使用 `docker start` 命令来启动。命令格式： 

```shell
$ docker start [OPTIONS] CONTAINER [CONTAINER...]
or
$ docker container start [OPTIONS] CONTAINER [CONTAINER...]
```

　　操作示例，使用 `docker ps -a` 找到已停止的容器的ID，然后通过 `docker start` 命令将其再次启动：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
76866ccb8619        ubuntu              "/bin/bash"         31 minutes ago      Exited (0) 13 minutes ago                       condescending_ptolemy
root@iZwz96uyro861qckgz89ljZ:~# docker start 76866ccb8619
76866ccb8619
root@iZwz96uyro861qckgz89ljZ:~# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
76866ccb8619        ubuntu              "/bin/bash"         32 minutes ago      Up 3 seconds                            condescending_ptolemy
```

#### 重启容器

　　使用 `docker restart` 命令来重启容器。 该命令实际上是先执行了 `docker stop` 命令， 然后执行了 `docker start` 命令。命令格式： 

```shell
$ docker restart [OPTIONS] CONTAINER [CONTAINER...]
or
$ docker container restart [OPTIONS] CONTAINER [CONTAINER...]
```

- 选项 `--time, -t` ：关闭容器前等待的时间， 单位是秒，默认是 10 。

　　操作示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker restart 76866ccb8619
76866ccb8619
```

#### 导出和导入容器 

##### 导出容器

　　使用 `docker export` 或 `docker container export` 命令，导出容器快照到本地文件：

```shell
$ docker export [OPTIONS] CONTAINER
or
$ docker container export [OPTIONS] CONTAINER
```

- 选项 `--output, -o ` ：将输入内容写到文件。

　　操作示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
76866ccb8619        ubuntu              "/bin/bash"         35 minutes ago      Up About a minute                       condescending_ptolemy
root@iZwz96uyro861qckgz89ljZ:~# docker export 76866ccb8619 > ubuntu.tar
root@iZwz96uyro861qckgz89ljZ:~# ls
ubuntu.tar

```

##### 导入容器

　　使用 `docker import` 命令，从容器快照文件中再导入为镜像：

```shell
$ docker import [OPTIONS] file|URL|- [REPOSITORY[:TAG]]
```

- 选项 `-c` ：应用docker 指令创建镜像；
- 选项 `-m` ：提交时的说明文字。

　　操作示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# cat ubuntu.tar | docker import - my/ubuntu:v1.0  
sha256:e4f23944020551aaa9da470d3af9520cb6e8d5857c855bedf8f3345e524a57a4
root@iZwz96uyro861qckgz89ljZ:~# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
my/ubuntu           v1.0                e4f239440205        8 seconds ago       69.8MB
```

　　此外，也可以通过指定 URL 或者某个目录来导入：

```shell
$ docker import URL 镜像标签
```

　　既可以使用 `docker load` 来导入镜像存储文件到本地镜像库，也可以使用 `docker import` 来导入一个容器快照到本地镜像库。区别在于容器快照文件将丢弃所有的历史记录和元数据信息（即仅保存容器当时的快照状态） ，而镜像存储文件将保存完整记录，体积也要大。此外，从容器快照文件导入时可以重新指定标签等元数据信息。 

#### 删除容器

　　命令 `docker rm` 和 `docker container rm` 用于删除一个处于终止状态的容器。命令格式： 

```shell
$ docker rm [OPTIONS] CONTAINER [CONTAINER...]
or
$ docker container rm [OPTIONS] CONTAINER [CONTAINER...]
```

- 选项 `--force, -f` ：通过 SIGKILL 信号强制删除正在运行中的容器；
- 选项 `--link, -l`：删除容器间的网络连接；
- 选项 `--volumes, -v` ：删除与容器关联的卷。

　　不加 `-f` 选项的命令只能删除已停止的容器， 如需删除正在运行的容器， 需使用 `-f` 参数。 如果要删除所有的容器：

```shell
$ docker rm -f $(docker ps -a -q)
```

　　清理所有处于终止状态的容器 ：

```SHELL
$ docker container prune
```

　　操作示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker rm -f 76866ccb8619
76866ccb8619
```

