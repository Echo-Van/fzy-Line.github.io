---
title: 搜歌，听歌，就用 Listen 1
tags:
  - Tools
  - 软件
categories: Tools
abbrlink: 31831
date: 2017-06-14 20:48:23
---


　　随着音乐的正版化，我们常常因为歌曲版权而不得不穿梭于各个音乐平台之间，比如我很喜欢网易云音乐，可是网易云音乐中林宥嘉的很多歌曲都无法收听，所以不得不到其他平台去找，总之，非常麻烦。现在，推荐给你的是一站式音乐搜索与播放工具 Listen 1，搜歌，听歌，就用 Listen 1。

<!--more-->

#### 简介

　　Listen 1 是一个用 Python 语言开发的免费开源综合音乐搜索工具项目，它可以用来搜索并播放来自网易云音乐，虾米，QQ 音乐三个主流音乐网站的歌曲以及收听精选音乐歌单，让你的曲库更加全面。目前，Listen 1 已经提供 Windows 和 Mac 系统的桌面版以及 Chrome 和 Firefox 浏览器插件版本。

![14-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/6/14-1.png)

　　Listen 1 提供“精选歌单”、“我的歌单”、“快速搜索”以及“关于”四个功能模块。

　　官方网站：[http://githublisten1.coding.me/listen1/](http://githublisten1.coding.me/listen1/)

　　Github仓库： [https://github.com/listen1](https://github.com/listen1)

#### 桌面版安装

![14-2](http://i.imgur.com/R6bTXkY.gif)

　　进入官网下载：

　　官方网站：[http://githublisten1.coding.me/listen1/](http://githublisten1.coding.me/listen1/)

　　注意：如果使用浏览器下载较慢，请复制下载链接使用迅雷下载。

#### Google浏览器-Chrome安装

　　推荐下载浏览器插件版本，安装方便快捷，使用也很简单。

- 下载项目的 zip 文件，在右上方有个 clone and Download，选择 Download ZIP，然后 解压到本地。下载地址：[http://githublisten1.coding.me/listen1/](http://githublisten1.coding.me/listen1/)

![14-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/6/14-3.png)

- 打开 chrome 浏览器，点击右上角的设置按钮下找到更多工具，打开扩展程序，然后勾选打开页面上方的开发者模式。

- 点击加载已解压的扩展程序，选中刚刚解压后的文件夹即可。

![14-4](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/6/14-4.png)

- 点击 chorme 右上角 Listen 1 的图标即可打开它。

![14-5](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/6/14-5.png)

#### Firefox 浏览器打包安装

- 打包 xpi 文件（或在 release 页面下载已经打包好的 xpi 文件）

- 将根目录下 manifest_firefox.json 替换 manifest.json
cd listen1_chrome_extension
zip -r ../listen1.xpi *
安装

- 打开 Firefox，加载 xpi 文件，完成安装

#### 使用体验

- 界面简洁，没有太多的花俏，功能没有专业的音乐播放器强大，但是基本功能都有，用户体验还不错。

- 搜索功能强大，搜歌、听歌方便快捷，但是目前还不支持歌曲下载。

- 不支持用户注册登录，重装插件或清除缓存数据会导致我的歌单数据丢失，但是它提供歌单备份功能，也支持歌单导入进行数据恢复。

---

　　最后，向 Listen 1 的作者致敬，感谢分享感谢开源，希望这个工具能够一直走下去。
