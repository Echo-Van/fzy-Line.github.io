---
title: Python爬虫利器---BeautifulSoup
tags:
  - Python
  - 爬虫
  - BeautifulSoup
categories: Python
abbrlink: 24032
date: 2016-07-17 20:27:40
---

　　Beautiful Soup提供一些简单的、python式的函数用来处理导航、搜索、修改分析树等功能。它是一个工具箱，通过解析文档为用户提供需要抓取的数据，因为简单，所以不需要多少代码就可以写出一个完整的应用程序。

<!--more-->

#### BeautifulSoup4安装

由于BeatifulSoup库不是Python标准库，因此需要单独安装。

##### 在Linux系统上安装
```
$sudo apt-get install python-bs4
```

##### 在Windows系统安装

可以利用 pip 或者 easy_install 来安装

```
pip install beautifulsoup4
```

```
easy_install beautifulsoup4
```

#### Beautifulsoup4使用

##### 导入库

（1）导入网络请求库

Python2.x里的urllib2与urllib有些不同，在Python3.x里，urllib2改名为urllib，被分成一些子模块：urllib.request、urllib.parse、urllib.error。所以不同的版本使用时略有区别。

Python3.x版本：
```
from urllib.request import urlopen
```

Python2.x版本：
```
from urllib import urlopen
```

（2）导入Beautifulsoup4
```
from bs4 import BeautifulSoup
```

##### 运行Beautifulsoup

首先我准备了一个简单的测试页面，网址是：blog.line-coding.tech，页面的结构如下：

可以看到我们的img标签在红色箭头标注的位置，我们通过代码一步步的去获取中心404图片的url地址，如下：

![17-1](http://ohe7ixo05.bkt.clouddn.com/2016/7/17-1.jpg)

Python3.x版本：

```
from urllib.request import urlopen
from bs4 import BeautifulSoup
html = urlopen("http://blog.line-coding.com")
bsObj = BeautifulSoup(html.read())
print(bsObj.body)
print(bsObj.body.div)
print(bsObj.body.div.div)
print(bsObj.body.div.div.img)
print(bsObj.body.div.div.img['src'])
```

Python2.x版本：

```
import urllib
from bs4 import BeautifulSoup
html = urllib.urlopen("http://blog.line-coding.com")
bsObj = BeautifulSoup(html,"html.parser")
print bsObj.body    #得到body标签的内容
print bsObj.body.div    #得到body标签下div标签的内容
print bsObj.body.div.div    #得到body标签下div标签下的div标签的内容
print bsObj.body.div.div.img    #得到img标签的内容
print bsObj.body.div.div.img['src']    #得到图片url地址
```

结果如下：

![17-2](http://ohe7ixo05.bkt.clouddn.com/2016/7/17-2.jpg)

有了Beautiful4，我们就可以将网页代码转换成一个对象，并通过再通过.号去访问这个对象的信息，一级一级的去查找来所需的信息。接下来的博客中，我会使用Beautiful4来进行数据爬取，敬请关注。

