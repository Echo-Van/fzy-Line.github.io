---
title: Python爬虫基础-正则表达式与Http请求
date: 2016-07-03 20:14:28
tags: [Python,爬虫,正则表达式,Http]
categories: Python
---

　　网络爬虫又称为网络机器人，它可以按照程序设定的规则自动抓取网页上的信息。网络是信息的海洋，但是网络中的数据是零散的、无序的且存在着冗余，如何从复杂的网页代码中提取有用的信息便是爬虫需要解决的问题。Python语法简洁，代码风骚，数据的处理能力强，比如函数参数的打包解包，列表解析，矩阵处理，非常方便，所以Python非常适合做网络爬虫。我将在这里很大家分享我的一些网络爬虫小程序，让我们一起体验爬虫带来的乐趣吧！

<!--more-->

#### 基本正则表达式

**Python正则表达式模块：re模块**

##### 导入re模块：

```
import re
```

python通过re模块提供对正则表达式的支持。

##### 常用方法

findall： 匹配所有符合规律的内容，返回包含结果的列表

Search：匹配并提取第一个符合规律的内容，返回一个正则表达式对象（object)

Sub：替换符合规律的内容，返回替换后的值

##### 常用符号

，，问号与括号

点号.  :  匹配任意字符，换行符\n除外

星号* ：匹配前一个字符0次或无限次

问号? ：匹配前一个字符0次或1次

贪心算法：.*

非贪心算法：.*?

括号（）：括号内的数据作为结果返回

##### 常用情况

使用findall与search从大量文本中匹配感兴趣的内容

使用sub实现换页功能


#### Http网络请求

**requests模块**

Requests 是用Python语言编写，基于 urllib，采用 Apache2 Licensed 开源协议的 HTTP 库。它比 urllib 更加方便，可以节约我们大量的工作，完全满足 HTTP 测试需求。

##### 导入requests模块

```
import requests
```

##### 基本Get请求

```
#-*- coding:utf-8 -*-   //定义编码为utf-8，避免显示乱码
import requests
url = 'http://www.baidu.com'   
r = requests.get(url)   //使用requests模块的get方法获取百度首页的源代码
print r.text
```

这里只举例了我们要使用的基本的get请求，如果需要了解更多的requests模块的方法请自行百度。

#### 实例代码

目的：爬取湖南农业大学官网中心位置的三张图片，并且下载下来

##### 获取图片的源代码

使用chrome打开农大官网，右键审查元素，然后点击左上角的放大镜，点击图片就会定位到图片的源代码位置，如图所示：

![3-1](http://ohe7ixo05.bkt.clouddn.com/2016/7/3-1.jpg)

##### 分析源代码，写出正则表达式

分析上图可知，我们需要的部分为src=""中引号里面的url，而三张图片都是相同的格式，所以我们使用re模块的findall方法，将src的中间部分获取到即可：
re.findall('img src="(.*?)" width="990"',html.text,re.S)
（1）findall即匹配所有符合正则表达式规则的内容
（2）(.*?)用作获取src=""的双引号中间的url并返回
（3）re.S的作用是使.的作用范围包括换行符，即可以换行匹配

##### 根据获取到的url下载图片

因为我们获取到的url并不是完整的网址，所以右键上图的链接选择Open link in new tab来查看完整的网址，如下图，因此我们在下载图片时需要在url前加上http://www.hunau.edu.cn/。

![3-2](http://ohe7ixo05.bkt.clouddn.com/2016/7/3-2.jpg)

代码如下：
```
import re   //导入正则表达式的库
import requests   //导入第三方http库
html = requests.get("http://www.hunau.edu.cn/")  //通过get方法获取农大官网的网页源代码
html.encoding = 'utf-8'   //设定编码方式，使能够正常显示中文
# print(html.text)   //也可以把网页源代码输出来看一下

homedir = os.getcwd()   //获取项目当前路径
os.mkdir(homedir+'\pic')   //创建pic文件夹，用于保存图片

pic_url = re.findall('img src="(.*?)" width="990"',html.text,re.S)   //设定正则表达式，爬取图片的url
i = 0
for each in pic_url:   //遍历pic_url
    print 'now downloading:' + each
    pic = requests.get("http://www.hunau.edu.cn/"+each) //补充完整的网址，通过get方法获取图片 
    fp = open('pic\\' + str(i) + '.jpg','wb')  //在pic文件夹下创建jpg格式的文件
    fp.write(pic.content)  //将图片写入到工程文件夹下的pic文件夹中
    fp.close()   
    i += 1
```

文本爬虫，效果如下：

![3-3](http://ohe7ixo05.bkt.clouddn.com/2016/7/3-3.jpg)

**我们在这里只是爬取了三张图片，但是使用python来做网页爬虫真的功能很强大，大家可以试一试修改代码去爬取更多的图片。**