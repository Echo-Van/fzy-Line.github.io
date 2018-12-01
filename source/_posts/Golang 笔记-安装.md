---
title: Golang 笔记-安装
tags: Golang
categories:
  - Coding
  - Golang
abbrlink: 8740
date: 2018-08-19 20:20:35
---

<center>Golang 安装与环境配置介绍。</center>

<!--more-->

#### Golang 编译器

　　Golang 目前有2个版本的编译器：Go 原生编译器 gc 和非原生编译器 gccgo，这两款编译器都是在类 Unix 系统下工作 。其中，gc 版本的编译器已经被移植到 Windows 平台上，并集成在主要发行版中，你也可以通过安装 MinGW 从而在 Windows 平台下使用 gcc 编译器。 

　　对于非常底层的纯 Go 语言代码或者包而言，在各个操作系统平台上的可移植性是非常强的，只需要将源码拷贝到相应平台上进行编译即可，或者可以使用交叉编译来构建目标平台的应用程序。

#### Golang 安装

　　支持 Linux、Windows 和 Mac OS 上的安装，可参考下面的教程根据自己的需要进行安装：

- 官方安装教程：https://golang.org/doc/install （需要翻墙）
- 菜鸟教程 Go 语言环境安装：http://www.runoob.com/go/go-environment.html

#### Golang 环境变量

　　通过 `go env` 命令可以查看 Go 语言的环境信息。 其中，

- **$GOROOT** 表示 Go 在你的电脑上的安装位置，它的值一般都是 `$HOME/go`，当然，你也可以安装在别的地方。
- **$GOARCH** 表示目标机器的处理器架构，它的值可以是 386、amd64 或 arm。
- **$GOOS** 表示目标机器的操作系统，它的值可以是 darwin、freebsd、linux 或 windows。
- **$GOBIN** 表示编译器和链接器的安装位置，默认是 `$GOROOT/bin`，如果你使用的是 Go 1.0.3 及以后的版本，一般情况下你可以将它的值设置为空，Go 将会使用前面提到的默认值。

　　目标机器是指你打算运行你的 Go 应用程序的机器。Go 编译器支持交叉编译，也就是说你可以在一台机器上构建运行在具有不同操作系统和处理器架构上运行的应用程序，也就是说编写源代码的机器可以和目标机器有完全不同的特性（操作系统与处理器架构）。

　　为了区分本地机器和目标机器，你可以使用 `$GOHOSTOS` 和 `$GOHOSTARCH` 设置本地机器的操作系统名称和编译体系结构，这两个变量只有在进行交叉编译的时候才会用到，如果你不进行显示设置，他们的值会和本地机器（`$GOOS` 和 `$GOARCH`）一样。

- **$GOPATH** 默认采用和 `$GOROOT` 一样的值，但从 Go 1.1 版本开始，你必须修改为其它路径。它可以包含多个包含 Go 语言源码文件、包文件和可执行文件的路径，而这些路径下又必须分别包含三个规定的目录：`src`、`pkg` 和 `bin`，这三个目录分别用于存放源码文件、包文件和可执行文件。
- **$GOARM** 专门针对基于 arm 架构的处理器，它的值可以是 5 或 6，默认为 6。
- **$GOMAXPROCS** 用于设置应用程序可使用的处理器个数与核数。

#### Golang 安装目录

　　Go 安装目录（`$GOROOT`）的文件夹结构应该如下所示：

- `/bin`：包含可执行文件，如：编译器，Go 工具
- `/doc`：包含示例程序，代码工具，本地文档等
- `/lib`：包含文档模版
- `/misc`：包含与支持 Go 编辑器有关的配置文件以及 cgo 的示例
- `/os_arch`：包含标准库的包的对象文件（`.a`）
- `/src`：包含源代码构建脚本和标准库的包的完整源代码（Go 是一门开源语言）
- `/src/cmd`：包含 Go 和 C 的编译器和命令行脚本

　　此外，还有 README.md, AUTHORS, CONTRIBUTORS, LICENSE 文件

#### Golang 工作空间

　　Go 的源代码必须存放在 workspace 中。 `GOPATH `环境变量 指明了你的工作空间的位置，该目录可以是任意的，唯一的要求是不能是你安装 Go 时的目录。workspace 是一个目录（directory hierachy），在这个目录下有三个子目录：

- `src` 包含 Go 源代码文件, 源代码文件组织成 packages (one package per directory)
- `pkg` 包含 package objects （二进制的包）
- `bin` 包含 可执行的命令 command（可执行的二进制文件）

　　go tool 编译(build) 源代码文件(source packages)，并且将 resulting binaries 安装在 `pkg` 和 `bin` 目录下面。





