---
title: Atom Latex 编辑器配置
tags:
  - Latex
  - Atom
categories:
  - Tools
abbrlink: 13369
date: 2017-09-16 20:15:06
---


　　将 Atom 配置成为强大的 Latex 编辑器。

<!--more-->

#### 安装 Atom

　　Atom 是由 GitHub 打造更为先进的编辑器，支持 Windows、Mac、Linux 三大桌面平台，完全免费，并且已经在 GitHub 上开放了全部的源代码。

　　Atom 高度的可定制性，让用户可以自行添加所需要的功能，打造自己最易用的代码编辑器。与其它主流代码编辑器相比，显得轻巧了许多。

　　官网下载地址：https://atom.io/

　　Atom Github 地址：https://github.com/atom/atom

　　如果使用官网的 Installer 安装失败，可直接到 Github 下载压缩包，直接解压使用，无需安装。

　　下载地址：https://github.com/atom/atom/releases/tag/v1.20.0

#### 安装 Texlive

　　TeX Live 是一个 TeX 发行版，它是一组程序的集合，主要作用就是将你写的 TeX 代码进行解析排版输出成 PS 或者 pdf。“TeX 发行版相对于 TeX 语言”大致可以理解为“ C 语言编译器（如GCC或Clang）相对于 C 语言”的关系；

　　下载地址：http://tug.org/texlive/acquire-netinstall.html

　　**记住安装地址，后续需要用到！**

#### 安装 Latex 编译插件

　　打开 Atom，File -> Settings -> Install，搜索并安装 Latex 插件，然后配置插件。

　　配置 Tex Path 为 texlive 的安装路径，Engine 为 pdflatex，其他的默认即可，如下图：

![16-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/9/16-1.png)

　　**注意：**

　　我们可能会遇到与 Atom 官网连接故障的问题导致 Atom 插件安装失败，可采用手动安装的方式，在 Atom 中搜索到相关 package，点击插件名到 Atom Packages 页面。

![16-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/9/16-2.png)

　　然后到该插件的 Github 仓库，使用 git 将其克隆到 Atom 的 packages 文件夹，或者使用下载 zip 文件并解压的方式，最后用 npm 命令安装。

![16-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/9/16-3.png)

　　Windows 下 .atom 文件夹在 C 盘 Users 对应的你的用户名的目录下。

　　注：需提前安装 nodejs，安装 node 以后自动会安装 npm，使用 Git 命令行工具进行下载，然后使用 npm 进行安装。

```shell
$ cd ~/.atom/packages
$ git clone https://github.com/thomasjo/atom-latex.git
$ cd latex
$ npm install
```

　　然后重启 Atom 即可看到该插件已经成功安装。

#### 安装语言高亮插件

　　搜索并安装 language-latex 插件，该插件还可以实现 LaTeX 命令的自动补全功能，具体使用方案请自行搜索。

#### 安装 PDF 预览插件

　　搜索并安装 pdf-view 插件，安装以后，Latex 编译后会调用此插件进行 pdf 预览。


#### 编译预览

　　新建 Latex 文件，后缀为 tex，然后填写如下内容：

```latex
\documentclass[UTF8]{article}
\author {Zhenyu Fan}
\title {My First Latex document}

\usepackage{ctex}
\usepackage{amsmath}
\usepackage{amssymb}
\begin{document}
\maketitle
\section{First section}
    \subsection{First subsection}
        \subsubsection{First double subsection}
            \paragraph{Fist paragraph}
    \subsection{Second subsection}

心之所向，素履以往。

\end{document}
```

　　点击 Atom 菜单栏 Packages -> Latex -> Builde（快捷键 Ctrl+Alt+B）进行编译，然后就可以看到右侧生成的pdf 文件，修改之后只要再次编译就可以查看到修改之后的预览效果。


![16-4](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/9/16-4.png)
