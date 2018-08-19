---
title: Github Pages + Hexo搭建博客（一）
tags:
  - Hexo
  - Github
categories: Hexo
abbrlink: 1912
date: 2016-11-30 17:12:10
---

#### 写在前面的话

阮一峰说过，喜欢写Blog的人，会经历三个阶段。

（1）第一阶段，刚接触Blog，觉得很新鲜，试着选择一个免费空间来写。

（2）第二阶段，发现免费空间限制太多，就自己购买域名和空间，搭建独立博客。

（3）第三阶段，觉得独立博客的管理太麻烦，最好在保留控制权的前提下，让别人来管，自己只负责写文章。

<!--more-->

我自己就是从一开始在CSDN写，后来租用阿里云的服务器，用WordPress搭建自己的博客，再到现在整体搬迁到Github上来，整个过程是一种锻炼，也是一种成长。

##### GitHub Pages是什么？

GitHub Pages本用于介绍托管在GitHub的项目， 不过，由于他的空间免费稳定，用来做搭建一个博客再好不过了。

##### 为什么选择GitHub Pages？

- GitHub Pages有300M免费空间，搭建的博客可以很方便的进行管理，并且保存可靠；
- GitHub 是趋势，GitHub上面有很多大牛，学IT的人应该尽早融入这样的环境，
- 程序员应该学会使用Git来管理项目，熟悉版本控制。
- Github上有很多的开源项目，多学习学习，眼界会开阔很多；

##### 接下来应该怎么做？

Hexo 是一个简单地、轻量地、基于Node的一个静态博客框架，可以方便的生成静态网页托管在github。我们要使用Github Pages + Hexo搭建博客站点，就必须注册Github账号，安装git、node.js以及hexo等，接下来就一起来实践吧！

#### Github注册与配置

##### 注册

如果你还没有自己的Github账号，那请到Github官网注册账号：[https://github.com/](https://github.com/)

注册成功后github会发送验证邮件到你的邮箱，请查收邮件并进行验证。

##### 新建版本库

注册完成后，点击Start a project来新建一个版本库

![30-1](http://ohe7ixo05.bkt.clouddn.com/2016/11/30-1.png)

如果你已经注册，则在自己的主页，点击”New repository”，即可新建一个版本库 

![30-2](http://ohe7ixo05.bkt.clouddn.com/2016/11/30-2.png)

输入Repository name:yourname.github.io(yourname与你的注册用户名一致,这个就是你博客的域名了) 

##### 启用GitHub Page

进入版本库后，点击右上方的setting

![30-3](http://ohe7ixo05.bkt.clouddn.com/2016/11/30-3.png)

下来到Githubs pages栏目，点击Launch automatic page generator

![30-4](http://ohe7ixo05.bkt.clouddn.com/2016/11/30-4.png)

来到New user site页面后点击右下角的Continue to layouts

最后点击”Publish page”,发布github默认生成的一个静态站点

![30-5](http://ohe7ixo05.bkt.clouddn.com/2016/11/30-5.png)

至此，我们已经配置好了github默认的静态站点，并且可以访问：你的github用户名.github.io测试我们刚刚建立好的站点主页。

#### 下载并安装Git

##### 下载

根据自己电脑操作系统的位数到git官网下载相应的版本：

[https://git-scm.com/download/win](https://git-scm.com/download/win)

##### 安装

根据自己的需要安装到相应的路径下，其他的一路点击next即可

##### 配置环境变量

选中桌面图标计算机，右键选择属性，打开左边的高级系统设置，打开弹出窗口的环境变量，找到path进行编辑。

找到git的安装目录，将其复制后粘贴到path后面。注意每一个加进来的路径后面都要带英文格式的分号。

安装与配置过程可参考图文教程：[git的安装和配置](http://jingyan.baidu.com/article/9f7e7ec0b17cac6f2815548d.html)

#### 测试是否安装成功

windows+R输入cmd打开命令提示符窗口，输入如下命令：

```
git --version
```

若安装成功会打印出本机安装的git的版本。

##### 添加SSH KEY到Github

SSH Key是一个认证，让github识别绑定这台机器，允许这台机器提交。

**（1）检查本机是否有SSH KEY设置**

打开git bash，输入cd ~/.ssh 或cd .ssh

如果没有则提示： No such file or directory

如果有则进入~/.ssh路径下（ls查看当前路径文件，rm * 删除所有文件）

**（2）配置生成SSH KEY**

```
$ cd ~  #保证当前路径在”~”下
$ ssh-keygen -t rsa -C "这里填写你的邮箱地址"
Generating public/private rsa key pair.
Enter file in which to save the key (/c/Users/xxxx_000/.ssh/id_rsa):   #不填直接回车
Enter passphrase (empty for no passphrase):   #输入密码（可以为空）
Enter same passphrase again:   #再次确认密码（可以为空）
Your identification has been saved in /c/Users/xxxx_000/.ssh/id_rsa.   #生成的密钥
Your public key has been saved in /c/Users/xxxx_000/.ssh/id_rsa.pub.  #生成的公钥
The key fingerprint is:
e3:51:33:xx:xx:xx:xx:xxx:61:28:83:e2:81 xxxxxx@yy.com
```

至此，已经生成ssh key，其存放路径为：c:/Users/你电脑的用户名/.ssh/下。

注释：可生成ssh key自定义名称的密钥，默认id_rsa。

**（3）复制SSH KEY到Github**

到C盘你的用户目录下找到.ssh文件夹，查看里面是否有id_rsa和id_rsa.pub这两个文件。

登录GitHub系统；点击右上角账号头像的“▼”→Settings→SSH kyes→Add SSH key，Title自定义，复制id_rsa.pub的公钥内容到GitHub中Add an SSH key的key输入框，最后“Add Key”。

**（4）配置账户**

```
$ git config --global user.name “your_username”  #设置用户名
$ git config --global user.email “your_registered_github_Email” 
#设置邮箱地址(建议用注册giuhub的邮箱)
```
**（5）测试SSH KEY是否设置成功**

```
$ ssh -T git@github.com
```

接下来会返回一些信息，并需要你输入一次yes，若生成ssh key时设置有密码则还会让你输入生成ssh key时设置的密码。

Hi xxx! You've successfully authenticated, but GitHub does not provide shell access. #出现词句话，说明设置成功。


SSH-KEY的生成与配置可参考图文教程[window下配置SSH连接GitHub、GitHub配置ssh key：](http://jingyan.baidu.com/article/a65957f4e91ccf24e77f9b11.html)

#### 下载并安装node.js

##### 下载

根据自己电脑操作系统的位数到git官网下载相应的版本：

[https://nodejs.org/en/download/](https://nodejs.org/en/download/)

##### 安装

根据自己的需要安装到响应的地方，其他的一路点击next即可

##### 配置环境变量

选中桌面图标计算机，右键选择属性，打开左边的高级系统设置，打开弹出窗口的环境变量，找到path进行编辑。

找到node.js的安装目录，将其复制后粘贴到path后面。注意每一个加进来的路径后面都要带英文格式的分号。

#### 测试是否安装成功

windows+R输入cmd打开命令提示符窗口，输入如下命令：

```
node -v
```

若安装成功会打印出本机安装的node.js的版本。

#### 安装和配置hexo

hexo是基于node.js的静态博客，官网也是搭建在GitHub上。

##### 安装

在你喜欢的路径下新建一个文件夹blog，用来存放博客的文件，在此文件夹中右键打开Git Bash

输入如下指令进行安装：

```
$ npm install -g hexo-cli
```

如果执行这条命令时长时间未成功，那么请先使用下面的命令将npm镜像源更改为国内的镜像，再执行上面的安装命令，因为国外的镜像源很有可能被墙了。
```
npm config set registry https://registry.npm.taobao.org 
```

##### 初始化hexo

```
$ hexo init hexo
```

这里会将Github上的hexo项目clone下来，得到hexo文件夹。

初始化成功后会在最后打印一行：INFO  Start blogging with Hexo!

##### 安装依赖文件

进入到hexo文件夹

```
$ cd hexo
```

安装依赖文件：

```
$ npm install
```

部署形成文件：
```
$ hexo generate
```

本地测试

```
$ hexo server
```
![30-6](http://ohe7ixo05.bkt.clouddn.com/2016/11/30-6.png)

在浏览器输入：http://localhost:4000/ 即可访问到我们搭建好的hexo站点。

![30-7](http://ohe7ixo05.bkt.clouddn.com/2016/11/30-7.png)

#### 将本地hexo项目托管到Github

##### 修改全局配置文件_config.yml

**说明：** hexo文件夹下一个_config.yml，我们称之为全局配置文件，在每个主题文件夹内还会有一个_config.yml文件，我们称之为主题配置文件。

用sublime text3或者notepad++等编辑器打开hexo文件夹下的_config.yml文件。

**注意：配置文件中每个字段后面的冒号是英文格式的，且在其后要加一个空格再写值**

编辑最后面的deploy属性，加入代码：

```
type: git
repository: https://github.com/你的Github用户名/你的Github用户名.github.io.git
branch: master 
```

type使用是git。 

repository属性改成你的刚才创建仓库git地址。 

分支branch填写master。

##### 安装hexo-deployer-git插件

```
$ npm install hexo-deployer-git --save
```

##### 部署到Github上

依次执行以下三条命令：

```
$ hexo clean  #清除缓存 网页正常情况下可以忽略此条命令
```

```
$ hexo generator  #生成静态页面至public目录
```

```
$ hexo deploy  #将.deploy目录部署到GitHub
```

执行hexo deploy命令之后，如果最后一行打印出如下信息则表示部署成功

```
INFO  Deploy done: git
```

然后你再去访问你创建的Github pages地址，也就是：你的Github用户名.github.io，即可看到你本地的hexo项目已经被部署到github上去了。此时博客的默认主题是landscape，即上面本地测试时的样子。

此篇博客就讲解到这里，下一篇博客主要讲解hexo主题的配置。
