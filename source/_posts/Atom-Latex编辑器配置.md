---
title: Atom Latex编辑器配置
date: 2017-09-16 20:15:06
tags: [Latex, Atom]
categories:
- Atom
---


　　将Atom配置成为强大的Latex编辑器。

<!--more-->

#### 安装Atom

　　Atom是由GitHub打造更为先进的编辑器，支持Windows、Mac、Linux三大桌面平台，完全免费，并且已经在GitHub上开放了全部的源代码。

　　Atom高度的可定制性，让用户可以自行添加所需要的功能，打造自己最易用的代码编辑器。与其它主流代码编辑器相比，显得轻巧了许多。

　　官网下载地址：https://atom.io/

　　Atom Github地址：https://github.com/atom/atom

　　如果使用官网的Installer安装失败，可直接到Github下载压缩包，直接解压使用，无需安装。

　　下载地址：https://github.com/atom/atom/releases/tag/v1.20.0

#### 安装texlive

　　TeX Live是一个TeX发行版，它是一组程序的集合，主要作用就是将你写的TeX代码进行解析排版输出成PS或者pdf。“TeX发行版相对于TeX语言”大致可以理解为“C语言编译器(如GCC或Clang)相对于C语言”的关系；

　　下载地址：http://tug.org/texlive/acquire-netinstall.html

**记住安装地址，后续需要用到！**

#### 安装Latex编译插件

　　打开Atom，File -> Settings -> Install，搜索并安装Latex插件，然后配置插件。

　　配置Tex Path为texlive的安装路径，Engine为pdflatex，其他的默认即可，如下图：

![16-1](http://ohe7ixo05.bkt.clouddn.com/2017/9/16-1.png)

**注意：**

　　我们可能会遇到与Atom官网连接故障的问题导致Atom插件安装失败，可采用手动安装的方式，在Atom中搜索到相关package，点击插件名到Atom Packages页面。

![16-2](http://ohe7ixo05.bkt.clouddn.com/2017/9/16-2.png)

　　然后到该插件的Github仓库，使用git将其克隆到atom的packages文件夹，或者使用下载zip文件并解压的方式，最后用npm命令安装。

![16-3](http://ohe7ixo05.bkt.clouddn.com/2017/9/16-3.png)

　　Windows下.atom文件夹在C盘Users对应的你的用户名的目录下。

　　注：需提前安装nodejs，安装node以后自动会安装npm，使用Git命令行工具进行下载，然后使用npm进行安装。

```
cd ~/.atom/packages
git clone https://github.com/thomasjo/atom-latex.git
cd latex
npm install
```

　　然后重启Atom即可看到该插件已经成功安装。

#### 安装语言高亮插件

　　搜索并安装language-latex插件，该插件还可以实现LaTeX命令的自动补全功能，具体使用方案请自行搜索。

#### 安装PDF预览插件

　　搜索并安装pdf-view插件，安装以后，Latex编译后会调用此插件进行pdf预览。


#### 编译预览

　　新建latex文件，后缀为tex，然后填写如下内容：

```
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

　　点击Atom菜单栏Packages -> Latex -> Builde（快捷键Ctrl+Alt+B）进行编译，然后就可以看到右侧生成的pdf文件，修改之后只要再次编译就可以查看到修改之后的预览效果。


![16-4](http://ohe7ixo05.bkt.clouddn.com/2017/9/16-4.png)
