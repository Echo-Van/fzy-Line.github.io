---
title: Github Pages + Hexo搭建博客（四）
tags:
  - Hexo
  - Github
categories: Hexo
abbrlink: 62906
date: 2017-08-10 12:54:27
---

　　Hexo的前三篇博客已经能够完整地搭建博客，此篇博客主要介绍了自己在使用Hexo期间遇到的一些问题以及解决问题的工具。

<!--more-->

#### 博客备份工具


　　一直想着怎么把博客备份一下，以便丢失时或者是换电脑时能够接着写博客，终于找到一个靠谱的插件，直接将文件备份在博客的仓库中的不同分支，十分方便。

　　项目地址：[https://github.com/coneycode/hexo-git-backup](https://github.com/coneycode/hexo-git-backup)


##### 安装

　　如果hexo的版本是2.x.x则执行如下命令:

```
$ npm install hexo-git-backup@0.0.91 --save
```

　　如果hexo的版本是3.x.x, 则执行:

```
$ npm install hexo-git-backup --save
```

##### 配置

　　在站点配置文件_config.yml中添加如下信息：

```
backup:
  type: git     # 指定提交类型
  message: update xxx   # 添加git commit信息
  repository:   # 指定仓库类型和地址
    github: git@github.com:xxx/xxx.git,分支名字
```

##### 运行

　　使用

```
hexo backup
```

　　或者

```
hexo b
```

　　备份成功后，可以在Github上查看我们新建的备份分支。

#### 使用Latex数学公式

　　Hexo默认使用"hexo-renderer-marked"引擎渲染网页，该引擎会把一些特殊的markdown符号转换为相应的html标签，比如在markdown语法中，下划线'_'代表斜体，会被渲染引擎处理为<em>标签。

　　因为类Latex格式书写的数学公式下划线 '_' 表示下标，有特殊的含义，如果被强制转换为<em>标签，那么MathJax引擎在渲染数学公式的时候就会出错。例如，$x_i$在开始被渲染的时候，处理为$x<em>i</em>$，这样MathJax引擎就认为该公式有语法错误，因为不会渲染。

　　类似的语义冲突的符号还包括'*', '{', '}', '\'等。

　　进入到主题目录，找到_config.yml配置问题，把mathjax默认的false修改为true，具体如下：

```
# MathJax Support
mathjax:
  enable: true
  per_page: true
```

　　此外，还需要在文章的Front-matter里打开mathjax开关，如下：

```
---
title: index.html
date: 2017-03-28 21:01:30
tags:
mathjax: true
--
```

#### 插入图片


　　前面说过使用七牛云进行图片存储，其实也可以直接使用我们的Hexo github仓库进行图片存储。

　　方法一：在hexo/source目录下新建一个img文件夹，将图片放入该文件夹下，插入图片时链接即为/img/图片名称

　　方法二：直接将图片放在public目录下对应的博客文章的目录下。

```
![你想输入的替代文字](xxxx/图片名.jpg)
```

　　但是，这样做也存在一定的缺点，因为Github仓库的的大小也是受限的，所以图片太多就比较麻烦了，所以还是建议用图床等其他云存储方式。

#### 插入音乐

　　网音乐云音乐，虾米音乐都可以生成内嵌音乐的html代码，在其网页端找到喜欢的歌曲，点击分享按钮，把里面的代码复制下来，直接粘贴到博文中即可:

```
<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=330 height=86   
    src="http://music.163.com/outchain/player?type=2&id=450853439&auto=1&height=66">  
</iframe>
```

#### 插入视频

　　将优酷等视频平台提供的视频外链或者自己制作的视频外链替换掉如下src的值即可。

```
<iframe   
    height=498 width=510   
    src="http://player.youku.com/embed/XNjcyMDU4Njg0"   
    frameborder=0 allowfullscreen>  
</iframe>  
```

#### 百度/google收录你的站点

##### 安装sitemap插件

```
npm install hexo-generator-sitemap --save  # google
npm install hexo-generator-baidu-sitemap --save  # 百度
```

　　在站点配置文件_config.yml中添加如下代码：

```
# 自动生成sitemap
sitemap:
  path: sitemap.xml
baidusitemap:
  path: baidusitemap.xml
```

　　执行hexo -g后会在public目录下生成baidusitmap.xml 和 sitemap.xml两个文件。

#### Hexo 3.xx版本的问题

　　Hexo 3.0 把服务器独立成了个别模块，您必须先安装 hexo-server 才能使用。

```
$ npm install hexo-server --save
```

　　安装完成后，输入以下命令以启动服务器，您的网站会在 http://localhost:4000 下启动。在服务器启动期间，Hexo 会监视文件变动并自动更新，您无须重启服务器。

　　然后，通过如下命令可开启本地预览：

```
$ hexo server
```

　　或者

```
hexo s
```

　　如果您想要更改端口，或是在执行时遇到了 EADDRINUSE 错误，可以在执行时使用 -p 选项指定其他端口，如下：

```
$ hexo server -p 5000
```
