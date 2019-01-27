---
title: Docker 基本操作-镜像篇（上）
tags:
  - Docker
categories:
  - Cloud Computing
abbrlink: 42746
date: 2019-01-27 16:44:23
---

<center>Docker 镜像基本操作介绍。</center>

<!--more-->

#### 获取镜像

　　Docker 运行容器前需要本地存在对应的镜像，如果本地不存在该镜像，Docker 会从镜像仓库下载该镜像。 从 Docker 镜像仓库获取镜像的命令是：

```shell
$ docker pull [选项] [Docker Registry 地址[:端口号]/]仓库名[:标签]
```

- Docker 镜像仓库地址：地址的格式一般是 <域名/IP>[:端口号] 。默认地址是 Docker Hub。
- 仓库名：如之前所说，这里的仓库名是两段式名称，即 <用户名>/<软件名> 。对于 Docker Hub，如果不给出用户名，则默认为 library ，也就是官方镜像。 
- 选项 `--all-tags , -a`，拉取所有 tagged 镜像；
- 选项 `--disable-content-trust`，忽略镜像的校验,默认开启；
- 选项 `--platform`，如果服务器具有多平台功能，用于设置平台（新版本特性）。

　　示例，从Docker Hub 拉取 ubuntu 系统的镜像：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
84ed7d2f608f: Pull complete 
be2bf1c4a48d: Pull complete 
a5bdc6303093: Pull complete 
e9055237d68d: Pull complete 
Digest: sha256:868fd30a0e47b8d8ac485df174795b5e2fe8a6c8f056cc707b232d65b8a1ab68
Status: Downloaded newer image for ubuntu:latest
```

#### 列出镜像

　　列出已经下载到本地的镜像，使用：

```SHELL
$ docker image ls
```

　　或者：

```shell
$ docker images
```

- 选项 `--all, -a`，列出本地所有的镜像（含中间映像层，默认情况下，过滤掉中间映像层）；
- 选项 `--digests`，显示镜像的摘要信息；
- 选项 `--filter, -f`，显示满足条件的镜像；
- 选项 `--format`，指定返回值的模板文件；
- 选项 `--no-trunc`，显示完整的镜像信息；
- 选项`--quiet, -q`，只显示镜像ID。

　　列表包含了`仓库名` 、 `标签` 、 `镜像 ID` 、 `创建时间` 以及 `所占用的空间 ` 。 

　　示例：

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              fce289e99eb9        3 weeks ago         1.84kB
ubuntu              latest              1d9c17228a9e        3 weeks ago         86.7MB
root@iZwz96uyro861qckgz89ljZ:~# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              fce289e99eb9        3 weeks ago         1.84kB
ubuntu              latest              1d9c17228a9e        3 weeks ago         86.7MB
```

#### 运行镜像

　　镜像是静态的定义，容器是镜像运行时的实体。这里称之为运行镜像其实是不合理的，因为只有容器才能说是运行。但是，启动容器有两种方式，一种是基于镜像新建一个容器并启动，另外一个是将在终止状态的容器重新启动。这里要说的就是基于镜像来启动容器：

```shell
$ docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

　　Docker run命名的具体使用将在后续的博客中进行详细说明。这里给出一个简单的示例，通过运行 ubuntu 容器输出 `Hello world`：

```shell
root@iZwz96uyro861qckgz89ljZ:~/docker# docker run ubuntu /bin/echo "Hello world"
Hello world
```

#### 删除本地镜像

　　删除本地的镜像，可以使用 ：

```shell
$ docker image rm [选项] <镜像1> [<镜像2> ...]
```

　　其中， `<镜像>` 可以是 `镜像短 ID` 、 `镜像长 ID` 、 `镜像名` 或者 `镜像摘要` 。 

- 选项 `--force , -f` ，强制删除镜像；
- 选项 `--no-prune` ，

```shell
root@iZwz96uyro861qckgz89ljZ:~# docker image rm ubuntu
Untagged: ubuntu:latest
Untagged: ubuntu@sha256:868fd30a0e47b8d8ac485df174795b5e2fe8a6c8f056cc707b232d65b8a1ab68
Deleted: sha256:1d9c17228a9e80a0a23927f24f3cf17d012cf0bb3eae5e3541a8c6987ab9bd5a
Deleted: sha256:3288cd6e6e7d42bcb4a74121b412c42a11f96da52685e42dbf9de6a747a55c6b
Deleted: sha256:b1636589630239bdb9153f95ac564bcd2afd9202aaf8511cbf5a9a37e03daf35
Deleted: sha256:043f492f40c539cfe7cee4cb8aae00ed1d5b19e864fbe6ea35ec92a2333bacc4
Deleted: sha256:2fb7bfc6145d0ad40334f1802707c2e2390bdcfc16ca636d9ed8a56c1101f5b9
```

#### 创建镜像

　　在运行着的容器的基础上生成镜像：

```shell
$ docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]
```

- 选项 `-a` ：提交的镜像作者；
- 选项 `-c` ：使用 Dockerfile 指令来创建镜像；
- 选项 `-m` ：提交时的说明文字；
- 选项 `-p` ：在 commit 时，将容器暂停。

　　示例，将容器 9fbbb230909a 保存为新的镜像，并添加提交人信息和说明信息：

```shell
root@iZwz96uyro861qckgz89ljZ:~/docker# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
9fbbb230909a        ubuntu              "/bin/bash -c 'while…"   23 minutes ago      Up 23 minutes                           admiring_chatterjee
root@iZwz96uyro861qckgz89ljZ:~/docker# docker commit -a "fanzhenyu" -m "my ubuntu" 9fbbb230909a ubuntu:my
sha256:fe0e9216b2dd575dff6b5521616b55ce996fdb89fd893ba9e80a8a671f6acc2d
root@iZwz96uyro861qckgz89ljZ:~/docker# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              my                  fe0e9216b2dd        13 seconds ago      87.5MB
ubuntu              latest              20bb25d32758        4 days ago          87.5MB
```

　　构建镜像也可以通过：

```shell
$ docker image build [OPTIONS] PATH | URL | -
```

　　或：

```shell
$ docker build [OPTIONS] PATH | URL | -
```

　　使用 Dockerfiles 来实现。Dockerfile 是一个文本文件，其内包含了一条条的指令，每一条指令构建一层，因此每一条指令的内容，就是描述该层应当如何构建。 

　　示例，以定制 nginx 镜像为例，Dockerfile 的内容如下：

```dockerfile
FROM nginx
RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
```

　　在 Dockerfile 文件所在目录执行： 

```shell
root@iZwz96uyro861qckgz89ljZ:~/docker# docker image build -t nginx:my .
Sending build context to Docker daemon  90.01MB
Step 1/2 : FROM nginx
latest: Pulling from library/nginx
5e6ec7f28fb7: Pull complete 
ab804f9bbcbe: Pull complete 
052b395f16bc: Pull complete 
Digest: sha256:56bcd35e8433343dbae0484ed5b740843dd8bff9479400990f251c13bbb94763
Status: Downloaded newer image for nginx:latest
 ---> 42b4762643dc
Step 2/2 : RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
 ---> Running in da558d0a335d
Removing intermediate container da558d0a335d
 ---> b6cca0cd24a1
Successfully built b6cca0cd24a1
Successfully tagged nginx:my
```

　　特别注意命令最后的 `.` 符号，这个点一定要有，否则会报错。这里的 `.` 是在指定上下文路径 。

　　当构建的时候，用户会指定构建镜像上下文的路径， docker build 命令得知这个路径后，会将路径下的所有内容打包，然后上传给 Docker 引擎。这样Docker 引擎收到这个上下文包后，展开就会获得构建镜像所需的一切文件。 

#### 导入和导出镜像

　　导出镜像，将一个或多个镜像保存到tar存档（默认情况下流式传输到标准输出）：

```shell
$ docker save [OPTIONS] IMAGE [IMAGE...]
```

　　或：

```shell
$ docker image save [OPTIONS] IMAGE [IMAGE...]
```

- 选项 `--output , -o` ，输出到的文件。

　　示例，导出 ubuntu 镜像为 tar 文件：

```shell
root@iZwz96uyro861qckgz89ljZ:~/docker# docker save -o ubuntu.tar ubuntu
root@iZwz96uyro861qckgz89ljZ:~/docker# ls -lh
total 86M
-rw------- 1 root root 86M Jan 27 10:21 ubuntu.tar
```

　　导入镜像，从tar存档或标准输入加载镜像：

```shell
$ docker image load [OPTIONS]
```

- 选项 `--input , -i` ，从tar归档文件中读取，而不是标准输入；
- 选项 `--quiet , -q`，安静模式，不输出load的中间信息。

　　示例，导入刚刚导出的 ubuntu 镜像：

```shell
root@iZwz96uyro861qckgz89ljZ:~/docker# docker load -i ubuntu.tar
adcb570ae9ac: Loading layer [==================================================>]  89.95MB/89.95MB
7604c8714555: Loading layer [==================================================>]  15.87kB/15.87kB
9e9d3c3a7458: Loading layer [==================================================>]  11.26kB/11.26kB
27a216ffe825: Loading layer [==================================================>]  3.072kB/3.072kB
Loaded image: ubuntu:latest
```

