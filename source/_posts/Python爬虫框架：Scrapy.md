---
title: Python爬虫框架：Scrapy
tags:
  - Python
  - 爬虫
  - Scrapy
categories: Python
abbrlink: 26234
date: 2016-12-26 08:18:51
---

　　Scrapy是一个为了爬取网站数据，提取结构性数据而编写的应用框架。它使用 Twisted这个异步网络库来处理网络通讯，架构清晰，并且包含了各种中间件接口，可以灵活的完成各种需求。学习Python爬虫有一段时间了，但是也是最近才接触到如此强大的Scrapy，它比BeautifulSoup更加完善，BeautifulSoup可以说是轮子，而Scrapy则是车子，不需要你关注太多的细节。

<!--more-->

**需要注意的是：Scrapy仅仅支持Python 2.7。**

#### 安装Scrapy

```
pip install Scrapy
```

pip 是一个Python包管理工具，主要是用于安装 PyPI 上的软件包，可以替代 easy_install 工具。没有安装过的建议安装一下，经常用到，具体安装教程请自行百度。

#### 创建项目

Windows下，打开命令提示符窗口，进入到打算存储代码的目录中，使用下面的命令创建一个scrapy项目。

```
scrapy startproject 项目名
```

#### 项目结构

文件管理器打开该目录可以看到多了scrapy项目的文件夹，进入文件夹可以看到如下这些文件：

scrapy.cfg: 项目的配置文件

项目名/: 该项目的python模块。之后我们将在此加入代码。

项目名/items.py: 项目中的item文件.

项目名/pipelines.py: 项目中的pipelines文件.

项目名/settings.py: 项目的设置文件.

项目名/spiders/: 放置spider代码的目录.

#### 定义要抓取的数据：Item

爬取的主要目标就是从非结构性的数据源提取结构性数据，例如网页。 Scrapy提供 Item 类来满足这样的需求。

Item 是保存爬取到的数据的容器；其使用方法和python字典类似， 并且提供了额外保护机制来避免拼写错误导致的未定义字段错误。

Item 对象是种简单的容器，保存了爬取到得数据。 其提供了 类似于词典(dictionary-like) 的API以及用于声明可用字段的简单语法。

默认生成的items.py文件如下：

```
# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy

class IpspiderItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    pass
```

我们可以scrapy.Field()定义一些字段，例如name、sex等。

#### 编写提取item数据的Spider

Spider是用户编写用于从单个网站(或者一些网站)爬取数据的类。
其包含了一个用于下载的初始URL，如何跟进网页中的链接以及如何分析页面中的内容， 提取生成 item 的方法。

为了创建一个Spider，您必须继承 scrapy.Spider 类，且定义以下三个属性:

- name: 用于区别Spider。 该名字必须是唯一的，您不可以为不同的Spider设定相同的名字。

- start_urls: 包含了Spider在启动时进行爬取的url列表。 因此，第一个被获取到的页面将是其中之一。 后续的URL则从初始的URL获取到的数据中提取。

- parse() 是spider的一个方法。 被调用时，每个初始URL完成下载后生成的 Response 对象将会作为唯一的参数传递给该函数。 该方法负责解析返回的数据(response data)，提取数据(生成item)以及生成需要进一步处理的URL的 Request 对象。

```
/spiders/__init__.py的大致框架如下：

import scrapy

class DmozSpider(scrapy.Spider):
    name = "这里定义爬虫的名字"
    start_urls = [
        这里填写起始的网址
    ]

    def parse(self, response):
        这里处理请求得到的数据，以及跳转到下一页
```

#### Selectors选择器

Scrapy提取数据有自己的一套机制。它们被称作选择器(seletors)，因为他们通过特定的 XPath 或者 CSS 表达式来“选择” HTML文件中的某个部分。

Selector有四个基本的方法:

- xpath(): 传入xpath表达式，返回该表达式所对应的所有节点的selector list列表 。

- css(): 传入CSS表达式，返回该表达式所对应的所有节点的selector list列表.

- extract(): 序列化该节点为unicode字符串并返回list。

- re(): 根据传入的正则表达式对数据进行提取，返回unicode字符串list列表。

XPath 是一门用来在XML文件中选择节点的语言，也可以用在HTML上。 CSS 是一门将HTML文档样式化的语言。选择器由它定义，并与特定的HTML元素的样式相关连。

我们可以使用浏览器的开发者工具来得到我们所需节点的xpath表达式，然后通过xpath()方法来得到其内容，如下：

```
response.xpath('xpath表达式')
```

假设，spider抓取到的html文档如下：

```
<html>
 <head>
  <base href='http://example.com/' />
  <title>Example website</title>
 </head>
 <body>
  <div id='images'>
   <a href='image1.html'>Name: My image 1 <br /><img src='image1_thumb.jpg' /></a>
   <a href='image2.html'>Name: My image 2 <br /><img src='image2_thumb.jpg' /></a>
   <a href='image3.html'>Name: My image 3 <br /><img src='image3_thumb.jpg' /></a>
   <a href='image4.html'>Name: My image 4 <br /><img src='image4_thumb.jpg' /></a>
   <a href='image5.html'>Name: My image 5 <br /><img src='image5_thumb.jpg' /></a>
  </div>
 </body>
</html>
```

例如，要得到title标签内的内容，xpath表达式应该写成：

```
//title/text()
```

为了提取真实的原文数据，你需要调用 .extract() 方法如下:

```
response.xpath('//title/text()').extract()
结果如下：
[u'Example website']
```

如你所见， .xpath()方法返回一个类 SelectorList 的实例, 它是一个新选择器的列表。这个API可以用来快速的提取嵌套数据。

再比如，要得到a标签中的链接，应该这样做：

```
for sel in response.xpath('//div/a').extract():  #得到含有所有a标签的列表，遍历列表依次取出其中的链接
    url = sel.xpath('/@href')   #使用@得到属性值
    print url
```

关于xpath的语法这里只是举了两个简单的例子，详细的语法可以参考网上其他教程。

#### 示例程序

我们通过编写一个爬取有代理：12月21号 国内代理ip服务器列表的爬虫来练习scrapy的基本使用。

地址如下：[http://www.youdaili.net/Daili/guonei/25083.html](http://www.youdaili.net/Daili/guonei/25083.html)

##### 新建项目

```
scrapy startproject IpSpider
```

##### 分析页面

打开浏览器的开发者工具，快捷键f12，笔记本可能需要fn键+f12.

（1）定位数据

点击控制台左上角的图标，然后鼠标箭头移动到代理ip列表的一条记录，通过分析我们可以知道所有的记录都是存放在一个p标签下的span标签里面，所以我们可以先找到所有的p标签，然后得到p标签下span标签的内容即为我们所需要的代理ip和地址数据。

![25-1](http://ohe7ixo05.bkt.clouddn.com/2016/12/25-9.png)

那么，如何得到所有的p标签呢？


![25-2](http://ohe7ixo05.bkt.clouddn.com/2016/12/25-2.png)

鼠标选中列表中第一个ip地址，右键copy，然后copy xpath，得到如下：

/html/body/div[5]/div[1]/div[1]/div[3]/div[3]/p[1]

第二个ip地址的xpath为：

/html/body/div[5]/div[1]/div[1]/div[3]/div[3]/p[1]

依次类推：

使用response.xpath('/html/body/div[5]/div[1]/div[1]/div[3]/div[3]/p')即可得到所有的p标签，即列表的所有项。

如何得到p标签下span标签的内容呢？

我们copy一下p标签下任意一个span标签得到xpath为：/html/body/div[5]/div[1]/div[1]/div[3]/div[3]/p[1]/span

![25-3](http://ohe7ixo05.bkt.clouddn.com/2016/12/25-3.png)

上一步中我们得到了一个包含所有p标签的列表，然后我们遍历这个列表，依次取出每个p标签中span的内容，如下：

```
for sel in response.xpath('/html/body/div[5]/div[1]/div[1]/div[3]/div[3]/p'):
    sel.xpath('span/text()')
```

这样我们就可以分别得到每一个列表项，即每一条代理ip地址信息。

（2）分析数据格式

![25-4](http://ohe7ixo05.bkt.clouddn.com/2016/12/25-4.png)

由上图可知，代理ip列表的每一项有一条ip信息，我们要获取的ip信息位于字符串的@符号之前，地址信息位于#符号与空格之间，这是我们处理数据的关键所在。

（3）跳转到下一页继续爬取

在第一页时：

![25-5](http://ohe7ixo05.bkt.clouddn.com/2016/12/25-5.png)

在第最后一页时：

![25-6](http://ohe7ixo05.bkt.clouddn.com/2016/12/25-6.png)

每次需要得到下一页按钮的链接，到最后一页时，下一页按钮的链接会变成#号，因此我们只要判断得到的链接不是#号就代表还有下一页，每次得到下一页的链接我们就把它传入Request函数，并yield这个Request让爬虫继续发送请求，爬取下一个页面。

```
pagenum = ''.join(response.xpath('/html/body/div[5]/div[1]/div[1]/div[3]/div[4]/li[8]/a/@href').extract())
    print pagenum
    if pagenum != '#': 
        nexturl = 'http://www.youdaili.net/Daili/guonei/' + pagenum
        print nexturl
        yield Request(nexturl, callback=self.parse)     #爬取下一页
```

##### 编写代码

```
IpSpider/spiders/__init__.py的代码如下：


# -*- coding: utf-8 -*-

import scrapy
from IpSpider.items import IpspiderItem
from scrapy.http import Request 

class IpSpider(scrapy.Spider): 
    name = "ip"
    start_urls = ["http://www.youdaili.net/Daili/guonei/25083.html"]

    def parse(self, response):       
        for sel in response.xpath('/html/body/div[5]/div[1]/div[1]/div[3]/div[3]/p'):
            item = IpspiderItem()
            s = ''.join(sel.xpath('span/text()').extract())
            item['ip'] = s[0:s.rfind('@',1)]    #切分字符串，只取ip
            item['address'] = s[s.rfind('#',1)+1:s.rfind(' ',1)]    #切分字符串，取出#号和空格之间的地址
            yield item  
        
        #处理下一页
        pagenum = ''.join(response.xpath('/html/body/div[5]/div[1]/div[1]/div[3]/div[4]/li[8]/a/@href').extract())
        print pagenum
        if pagenum != '#': 
            nexturl = 'http://www.youdaili.net/Daili/guonei/' + pagenum
            print nexturl
            yield Request(nexturl, callback=self.parse)     #爬取下一页
```

```
IpSpider/items.py的代码如下：

import scrapy

class IpspiderItem(scrapy.Item):
    # define the fields for your item here like:
    ip = scrapy.Field()     #ip字段
    address = scrapy.Field()    #地址字段
    pass
```

pipelines.py和settings.py我们暂时不需处理，待下次深入学习scrapy再来修改。

##### 开始爬取

**进入项目的根目录**，执行crawl命令启动spider:

只执行程序，不保存数据：

```
scrapy crawl ip
```
执行程序，并输出保存数据：

```
scrapy crawl ip -o ip.json
```
该命令将采用 JSON 格式对爬取的数据进行序列化，生成 ip.json 文件。

![25-7](http://ohe7ixo05.bkt.clouddn.com/2016/12/25-7.png)

也可以采用 CSV 格式对爬取的数据进行序列化：

```
scrapy crawl ip -o ip.csv
```

将生成 ip.csv 文件。

效果如下：

![25-8](http://ohe7ixo05.bkt.clouddn.com/2016/12/25-8.png)