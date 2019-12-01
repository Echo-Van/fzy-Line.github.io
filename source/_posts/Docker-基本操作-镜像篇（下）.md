---
title: Docker 基本操作-镜像篇（下）
tags:
  - Docker
categories:
  - Cloud/Edge Computing
abbrlink: 23291
date: 2019-02-06 17:26:34
---

<center>Docker 镜像基本操作介绍。</center>
<!--more-->

#### 基于容器构建镜像

　　在上篇中已经介绍了如何基于运行着的容器生成镜像：

```shell
$ docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]
```

- 选项 `-a` ：提交的镜像作者；
- 选项 `-c` ：使用 Dockerfile 指令来创建镜像；
- 选项 `-m` ：提交时的说明文字；
- 选项 `-p` ：在 commit 时，将容器暂停。

　　`docker commit` 命令是在原有镜像的基础上，再叠加上容器的存储层，并构成新的镜像。以后我们运行这个新镜像的时候，就会拥有原有容器最后的文件变化。 因为，当运行一个容器的时候（如果不使用卷的话） ，所做的任何文件修改都会被记录于容器存储层里。而 `docker commit` 命令，可以将容器的存储层保存下来成为镜像。

　　使用 `docker commit` 命令虽然可以比较直观的帮助理解镜像分层存储的概念，但是实际环境中并不会这样使用。 因为存在以下问题：

- 在容器中安装软件包、编译构建，会有大量的无关内容被添加进来，如果不小心清理，`docker commit` 将会导致镜像极为臃肿。 
- 使用 `docker commit` 意味着除了制作镜像的人知道执行过什么命令、怎么生成的镜像，别人根本无从得知，这对后续的维护十分不利。
- 使用 `docker commit` 制作镜像，以及后期修改的话，每一次修改都会让镜像更加臃肿一次，所删除的上一层的东西并不会丢失，会一直如影随形的跟着这个镜像，即使根本无法访问到。 

　　因此，一般不要使用 `docker commit` 定制镜像，定制镜像应该使用 Dockerfile 来完成。 

#### 基于 Dockerfile 构建镜像

　　Dockerfile 使用基本的基于 DSL （领域特定语言）语法的指令来构建一个 Docker 镜像，它实际是一个文本文件，其内包含了一条条的指令(Instruction)，每一条指令构建一层，因此每一条指令的内容，就是描述该层应当如何构建。然后，使用`docker build` 命令基于该 Dockerfile 中的指令构建一个新的镜像。

##### Dockerfile 指令

- **FROM 指定基础镜像**

　　基础镜像是必须指定的。FROM 用于指定基础镜像，因此 Dockerfile 中 FROM 是必备的指令，并且必须是第一条指令。 

　　可以使用 `nginx` 、`mysql` 、`python` 、`golang` 等官方镜像作为基础镜像，也可以使用更为基础的操作系统镜像，如 `ubuntu`、`debian` 、`centos` 。除了选择现有镜像为基础镜像外，Docker 还存在一个特殊的镜像，名为 scratch 。这个镜像是虚拟的概念，并不实际存在，它表示一个空白的镜像。

- **RUN 执行命令**

　　`RUN` 指令是用来执行命令行命令的。 有两种格式：

- `shell` 格式： `RUN <命令>` ，就像直接在命令行中输入的命令一样。 
- `exec` 格式： `RUN ["可执行文件", "参数1", "参数2"]` ，这更像是函数调用中的格式。

　　镜像构建时，一定要确保每一层只添加真正需要添加的东西，任何无关的东西都应该清理掉。

- **COPY 复制文件**

　　`COPY` 指令将从构建上下文目录中 `<源路径>` 的文件/目录复制到新的一层的镜像内的 `<目标路径>` 位置。其格式如下：

- `COPY <源路径>... <目标路径>`
- `COPY ["<源路径1>",... "<目标路径>"]`

　　`<源路径>` 可以是多个，甚至可以是通配符。而 `<目标路径>` 可以是容器内的绝对路径，也可以是相对于工作目录的相对路径（工作目录可以用 WORKDIR 指令来指定） 。目标路径不需要事先创建，如果目录不存在会在复制文件前先行创建缺失目录。 

- **ADD 更高级的复制文件 **

　　`ADD` 指令和 `COPY` 的格式和性质基本一致，但是，<源路径> 可以是一个 URL  Docker 引擎会试图去下载这个链接的文件放到 <目标路径> 去 。如果 <源路径> 为一个 tar 压缩文件的话，压缩格式为 gzip , bzip2 以及 xz 的情况下， ADD 指令将会自动解压缩这个压缩文件到 <目标路径> 去。 

　　在 `COPY` 和 `ADD` 指令中选择的时候，可以遵循这样的原则，所有的文件复制均使用 `COPY` 指令，仅在需要自动解压缩的场合使用 `ADD` 。 

- **CMD 容器启动命令**

　　`CMD` 指令就是用于指定默认的容器主进程的启动命令的。每个 `Dockerfile` 只有⼀个 `CMD` 命令， 如果指定了多个 `CMD` 命令， 那么只有最后⼀条会被执行， 如果启动容器的时候指定了运行的命令， 则会覆盖掉 `CMD` 指定的命令。

- `shell` 格式： `CMD <命令>`
- `exec` 格式： `CMD ["可执行文件", "参数1", "参数2"...]`
- **ENTRYPOINT 入口点**

　　`ENTRYPOINT` 的目的和 `CMD` 一样，都是在指定容器启动程序及参数。 `ENTRYPOINT` 在运行时也可以替代，不过比 `CMD` 要略显繁琐，需要通过 `docker run` 的参数 `--entrypoint` 来指定。同样，一个 `Dockerfile` 中只能有一条 `ENTRYPOINT` 命令，如果多条，则只执行最后一条。另外，`ENTRYPOINT` 没有 `CMD` 的可替换特性。

　　当指定了 `ENTRYPOINT` 后， `CMD` 的含义就发生了改变，不再是直接的运行其命令，而是将`CMD` 的内容作为参数传给 `ENTRYPOINT` 指令，换句话说实际执行时，将变为： `<ENTRYPOINT> "<CMD>" `。

- **ENV 设置环境变量**

　　`ENV` 指令⽤于设置环境变量。也可以在容器启动后，通过 `docker inspect` 查看这个环境变量，还可以通过在 `docker run –env key=value` 时设置或修改环境变量。`ENV` 指令的格式有两种：

- `ENV <key> <value>`
- `ENV <key1>=<value1> <key2>=<value2>... `

　　定义了环境变量，那么在后续的指令中，就可以使用这个环境变量。环境变量可以使用的地方很多，例如 `RUN` 、`COPY` 等指令中。

- **ARG 设置构建参数 **

　　`ARG` 指令用于设置构建参数， 类似于 `ENV`。 和 `ENV` 不同的是， `ARG` 设置的是构建时的环境变量， 在容
器运行时是不会存在这些变量的。格式为：`ARG <name>[=<default value>]` 。

- **EXPOSE 声明端口 **

　　`EXPOSE` 指令是声明运行时容器提供服务端口，这只是一个声明，在运行时并不会因为这个声明应用就会开启这个端口的服务。 格式为 `EXPOSE <端口1> [<端口2>...]  ` 。

　　在 `Dockerfile` 中写入这样的声明有两个好处，一个是帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射；另一个用处则是在运行时使用随机端口映射时，也就是 `docker run -P` 时，会自动随机映射 `EXPOSE` 的端口。

　　`EXPOSE` 和运行时 `-p <宿主端口>:<容器端口>` 的区别：

- `-p` 是映射宿主端口和容器端口，也就是将容器的对应端口服务公开给外界访问。
- `EXPOSE` 仅仅是声明容器打算使用什么端口而已，并不会自动在宿主进行端口映射。 

- **VOLUME 定义匿名卷**

　　`VOLUME` 指令使容器中的⼀个目录具有持久化存储的功能， 该目录可被容器本身使用， 也可共享给其他容器。 即，可实现挂载功能，可以将本地文件夹或者其他容器中的文件夹挂在到这个容器中。当容器中的应用有持久化数据的需求时可以在 `Dockerfile` 中使用该指令。其格式为：

- `VOLUME ["<路径1>", "<路径2>"...]`
- `VOLUME <路径>`

- **ONBUILD 为他人做嫁衣**

　　`ONBUILD` 是一个特殊的指令，它后面跟的是其它指令，比如 `RUN` , `COPY` 等，而这些指令，在当前镜像构建时并不会被执行。只有当以当前镜像为基础镜像，去构建下一级镜像的时候才会被执行。格式：`ONBUILD <其它指令>`。 

- **WORKDIR 指定工作目录**

　　使用 `WORKDIR` 指令可以来指定工作目录（或者称为当前目录） ，以后各层的当前目录就被改为指定的目录，如该目录不存在， `WORKDIR` 会帮你建立目录。 格式为 `WORKDIR <工作目录路径>` 。 

　　实际上就是切换目录指令， 类似于 `cd` 命令， 写在该指令后的 `RUN` ，`CMD` 以及 `ENTRYPOINT` 指令都将该目录作为当前目录， 并执行相应的命令。 

- **USER 指定当前用户 **

　　`USER` 指令用于设置启动镜像时的用户或者 `UID`， 写在该指令后的 `RUN`、`CMD` 以及 `ENTRYPOINT` 指令都将使用该用户执行命令。 格式：`USER <用户名>` 。

　　`USER` 指令和 `WORKDIR` 相似，都是改变环境状态并影响以后的层。 `WORKDIR` 是改变工作目录， `USER` 则是改变之后层的执行 `RUN` , `CMD` 以及 `ENTRYPOINT` 这类命令的身份。 

- **LABEL 为镜像添加元数据 **

　　`LABEL` 指令用于为镜像添加元数据。格式为：`LABEL <key>=<value> <key>=<value> <key>=<value> ... ` 。⽤于指定维护者信息的 `MAINTAINER` 指令已经过时，可使用 `LABEL maintainer="xxx@xxx.com" ` 替代。

##### 构建镜像

　　`docker build` 和 `docker image build` 命令使用 Dockerfile 创建镜像。

```shell
$ docker image build [OPTIONS] PATH | URL | -
```

　　或：

```shell
$ docker build [OPTIONS] PATH | URL | -
```

- 选项 `--tag, -t` ：设置标签，格式： `name:tag`， tag 可选；
- 选项 `--no-cache` ：创建镜像的过程不使用缓存；
- 选项 `--add-host` ：添加自定义从 host 到 IP 的映射， 格式为：`host:ip`；
- 选项 `--build-arg` ：设置构建时的变量；
- 选项 `--cache-from` ： 作为缓存源的镜像；
- ......具体选项可查看官方文档，这里不详细介绍。

　　**PATH|URL**： 指定构建镜像的上下文的路径，构建镜像的过程中，可以且只可以引用上下文中的任何文件。

　　`docker build` 支持从从 URL 构建，例如从 Git 仓库：

```shell
$ docker build git仓库地址
```

　　如果所给出的 URL 不是个 Git 仓库，而是个  tar  压缩包，那么 Docker 引擎会下载这个包，并自动解压缩，以其作为上下文，开始构建。用给定的 tar 压缩包构建：

```
$ docker build - < context.tar.gz
```

　　也可以使用当前目录的 Dockerfile 创建镜像，或者通过 -f Dockerfile 文件的位置。还支持从标准输入中读取 Dockerfile 进行构建。

　　示例，创建 Dockerfile 文件，内容如下：

```dockerfile
FROM nginx
RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
```

　　构建镜像：

```shell
root@iZwz96uyro861qckgz89ljZ:~/docker# docker build -t mynginx .
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM nginx
 ---> f09fe80eb0e7
Step 2/2 : RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
 ---> Running in 403fbe9c02bf
Removing intermediate container 403fbe9c02bf
 ---> b3074b079926
Successfully built b3074b079926
Successfully tagged mynginx:latest
```

　　在这条命令中，使用 `-t` 指定了镜像名为 mynginx，由于没有使用 `-f` 指令，所以默认使用上下文路径下名为 Dockerfile 的文件认为是构建镜像的"Dockerfile"。最后指定上下文路径，在这条命令中，上下文路径是 `.` 。

#### 精简镜像体积

##### 选择最精简的基础镜像

　　选择体积最小的基础镜像可有效降低镜像体积。如：`alpine`、`busybox` 等。

##### 清理镜像构建的中间产物

　　构建镜像的过程中，当 Dockerfile 的指令执行完成后，删除镜像不需要用的的文件。`apt-get autoremove` 和 `apt-get clean all ` 把所有不必要的依赖全删，或者使用系统 rm 命令删除不需要的源文件。

##### 减少镜像的层数

　　镜像是一个分层存储的文件，并且镜像对层数也是有一定数量的限制，当前镜像的层数最高是127层，如果不多加注意，将会导致镜像越来越臃肿。在使用 Dockerfile 构建镜像时，每一条指令都会生成一个层，因此可以通过串联 Dockerfile 指令，例如RUN 指令通过 `&&` 和 `/` 支持将命令串联在一起，减少最终生成镜像的层数。

##### 多阶段构建

　　Docker 多阶段构建是 17.05 以后引入的新特性，旨在解决编译和构建复杂的问题，减小镜像大小。对于多阶段构建，在 Dockerfile 中使用多个` FROM` 语句。每个 `FROM` 指令可以使用不同的基础，并且每个指令都开始一个新的构建。您可以选择性地将工件从一个阶段复制到另一个阶段，从而在最终镜像中只留下您想要的内容（这里只做简单描述，后续再详细分析 Docker 的多阶段构建）。 