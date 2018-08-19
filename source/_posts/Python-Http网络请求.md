---
title: Python Http网络请求
tags:
  - Python
  - Http
categories: Python
abbrlink: 51425
date: 2016-08-07 20:39:24
---


　　Python网络爬虫开发离不开Http网络请求，此前的几篇Python网络爬虫博客中，对网络爬虫已经有了一些基本的介绍，也使用了一些网络请求库，但是没有对Python网络请求做详细的说明，此篇博客将对Python的Http网络请求进行一个总结，通过列举不同的Http请求库的不同请求写法来熟悉Python的网络请求，从而有利于后续的网络爬虫开发。

<!--more-->

**注：博主的Python环境为Python2.7.5，使用Python3的读者要注意个别的类库与Python2有很大区别。**

#### urllib与urllib2模块

##### urllib与urllib2比较

urllib与urllib2是python自带的库，不需要额外导入，但是很多人可能会比较困惑这两个库有什么区别呢？很多人认为urllib2是urllib的升级版，我之前也是这么认为的，但是这是不对的。

urllib 和urllib2都是接受URL请求的相关模块，但是他们是不可相互替代的，因为提供了不同的功能。整体来说，urllib2是urllib的增强，但是urllib中有urllib2中所没有的函数。他们两个最显著的不同如下：

1. urllib2可以接受一个Request类的实例来设置URL请求的Headers，urllib仅可以接受URL。这意味着，你不可以伪装你的User Agent字符串等。如果你访问一个网站，想更改User Agent（可以伪装你的浏览器），你就要用urllib2。

2. urllib支持设置编码的函数，urllib.urlencode，在模拟登陆的时候，经常要post编码之后的参数，所以要想不使用第三方库完成模拟登录，你就需要使用urllib。也正因为如此，urllib常和urllib2一起使用。

##### urllib模块

##### urlopen()函数的使用

**urlopen(url, data=None, proxies=None)**

参数url：表示远程数据的路径，一般是http或者ftp路径。

可选参数data：表示以post方式提交到url的数据。

可选参数proxies：表示用于代理的设置。

**urlopen返回一个类文件对象，它提供了如下方法：**

read() , readline() , readlines()，fileno()和close()：
这些函数的使用与文件对象完全一样。

info()：返回一个httplib.HTTPMessage 对象，表示远程服务器返回的头信息。

getcode()：返回Http状态码，如果是http请求，200表示请求成功完成;404表示网址未找到。

geturl()：返回请求的url地址。

##### 简单GET请求

此处代码中的GET请求都是对博主博客的一个404页面发送的请求，会返回服务器响应信息以及网页源代码。

```
# -*- coding:utf-8 -*-
import urllib

res = urllib.urlopen("http://blog.line-coding.tech/")

print res.info()
print res.getcode()
print res.geturl()
print res.read()

```

```
运行结果如下：
Date: Sat, 06 Aug 2016 13:48:53 GMT
Server: Apache/2.4.6 (CentOS) mod_wsgi/4.5.3 Python/2.7.5 PHP/5.4.16
Last-Modified: Thu, 14 Jul 2016 06:29:45 GMT
ETag: "4f3-53792a0bfd6ca"
Accept-Ranges: bytes
Content-Length: 1267
Connection: close
Content-Type: text/html; charset=UTF-8


200
http://blog.line-coding.tech/

篇幅有限，此处省略了请求页面的html文档。
```

##### 简单POST请求

此处代码的POST请求都是对博主服务器上的一个用户注册API接口发送的请求，其中请求参数包括用户名和密码，如果服务器中的数据库已经存在此账号则会返回一个exist，如果注册成功则会返回一个success，请求错误则返回一个go away。

```
# -*- coding:utf-8 -*-
import urllib
url = 'http://data.line-coding.tech/register.php'
data = {'username':'13654852343','password':'123456'}
res = urllib.urlopen(url, data = urllib.urlencode(data))
print res.info()
print res.getcode()
print res.geturl()
print res.read()

```

```
运行结果如下：
篇幅有限，此处只写出服务器返回的内容
exist
```

##### urllib2模块

urllib2用一个Request对象来映射你提出的HTTP请求,在它最简单的使用形式中你将用你要请求的地址创建一个Request对象，通过调用urlopen并传入Request对象，将返回一个相关请求response对象，这个应答对象如同一个文件对象，所以你同样可以像在使用urllib模块时调用info()、getcode()、geturl()、read()等函数。

##### 简单GET请求
```
# -*- coding:utf-8 -*-
import urllib2

res = urllib2.urlopen("http://blog.line-coding.tech/")
print res.info()
print res.getcode()
print res.geturl()
print res.read()

```

```
运行结果同urllib的GET方法
```

**说明：**

下文中使用到百度APIStore中一个既可以接收GET请求又可以接收POST请求的查询学校信息的API接口，该接口的使用方法可参考 相关文档（[http://apistore.baidu.com/apiworks/servicedetail/2843.html](http://apistore.baidu.com/apiworks/servicedetail/2843.html)），简单说来，使用它时需要传递一个学校名字的参数，以及添加自己的百度API Store的API-key。由于它既可以接收GET请求又可以接收POST请求，所以下文的示例代码中会得到很多同样的结果，但是采用GET方法时参数是连接在在url后面的，而POST方法则不是，请大家注意区分。

##### 带Header的POST请求

```
# -*- coding:utf-8 -*-
import urllib,urllib2
from urllib import urlencode

url = 'http://apis.baidu.com/jidichong/school_search/school_search'
data = {'name':'清华大学'}
req = urllib2.Request(url, urlencode(data))
req.add_header("apikey", "c57bc70b78d5926e8cfbb3ad9c195465")    #此处添加自己的百度API Stroe的APIKEY
resp = urllib2.urlopen(req)
print resp.read()
```

```
运行结果如下：
{"status":1,"msg":"请求成功","result":{"npage":1,"pageSize":10,"total":1,"data":[{"phone":"010-62770334;010-62782051","website":"www.tsinghua.edu.cn","email":"zsb@mail.tsinghua.edu.cn","address":"北京市海淀区清华大学","zipcode":"","name":"清华大学","img":"http://img.jidichong.com/school/3.png","parent":"教育部","type":" 211 985","profile":"","info":"院士：68人 博士点：198个 硕士点：181个","city":"北京"}]}}
```

#### httplib2模块

##### 安装httplib2模块

httplib2是一个全面的HTTP客户端库，它也是一个第三方开源库，所以需要自行安装。

```
pip install httplib2
```

##### 带参数和Header的GET请求

```
# -*- coding:utf-8 -*-
import httplib2 
h = httplib2.Http()  
url = 'http://apis.baidu.com/jidichong/school_search/school_search/?name=清华大学'   #带请求参数的url
headers = {'apikey': 'c57bc70b78d5926e8cfbb3ad9c195465'}
resp, content = h.request (url,'GET', None , headers)  #使用GET方法时，这里的Body参数必须写成None
# print resp
print content 
```

**httplib2 Http对象的request()方法返回两个值：**

第一个是httplib2.Response对象，其中包含了服务器返回的所有http头。比如, status为200 表示请求成功。

第二个返回值包含了http服务器返回的实际数据。数据以bytes对象返回，不是字符串。 如果你需要一个字符串，你需要确定字符编码并自己进行转换

```
程序运行结果：
{"status":1,"msg":"请求成功","result":{"npage":1,"pageSize":10,"total":1,"data":[{"phone":"010-62770334;010-62782051","website":"www.tsinghua.edu.cn","email":"zsb@mail.tsinghua.edu.cn","address":"北京市海淀区清华大学","zipcode":"","name":"清华大学","img":"http://img.jidichong.com/school/3.png","parent":"教育部","type":" 211 985","profile":"","info":"院士：68人 博士点：198个 硕士点：181个","city":"北京"}]}}
```

##### 带参数和Header的POST请求

```
# -*- coding:utf-8 -*-
import httplib2 
from urllib import urlencode
h = httplib2.Http() 
url = 'http://apis.baidu.com/jidichong/school_search/school_search'
data = {'name':'清华大学'} 
headers = {'apikey': 'c57bc70b78d5926e8cfbb3ad9c195465','Content-type': 'application/x-www-form-urlencoded'}
# 必须带上headers参数，否则POST不成功
resp, content = h.request(url,'POST',urlencode(data),headers) 
# print resp  
print content
```

```
程序运行结果同上GET方法
```

#### requests模块

requests是第三方库，它使用的是urllib3，继承了urllib2的所有特性。Requests支持HTTP连接保持和连接池，支持使用cookie保持会话，支持文件上传，支持自动确定响应内容的编码，支持国际化的URL和POST数据自动编码。同时，它支持Http协议的GET、POST、PUT、DELETE等多种请求方式。

##### 安装

```
pip install requests
```

##### 简单GET请求

```
# -*- coding:utf-8 -*-
import requests
import sys 
reload(sys) 
sys.setdefaultencoding('utf8')  #设置文件的编码方式

req = requests.get(url='http://blog.line-coding.tech')    
print req.url
print req.status_code 
print req.text
```


```
程序运行结果：
http://blog.line-coding.tech/
200
篇幅有限，此处省去网页源代码
```

##### 带参数和Header的GET请求

如果你想为请求添加HTTP头部，只要简单地传递一个dict给headers参数就可以了。

```
# -*- coding:utf-8 -*-
import requests
import sys 
reload(sys) 
sys.setdefaultencoding('utf8')  #设置文件的编码方式

url = 'http://apis.baidu.com/jidichong/school_search/school_search'
headers = {'apikey':'c57bc70b78d5926e8cfbb3ad9c195465'}
params = {'name':'清华大学'}
rep = requests.get(url, params = params, headers = headers)
print rep.text
```


```
程序运行结果：
{"status":1,"msg":"请求成功","result":{"npage":1,"pageSize":10,"total":1,"data":[{"phone":"010-62770334;010-62782051","website":"www.tsinghua.edu.cn","email":"zsb@mail.tsinghua.edu.cn","address":"北京市海淀区清华大学","zipcode":"","name":"清华大学","img":"http://img.jidichong.com/school/3.png","parent":"教育部","type":" 211 985","profile":"","info":"院士：68人 博士点：198个 硕士点：181个","city":"北京"}]}}
```


##### 带参数和Header的POST请求

```
# -*- coding:utf-8 -*-
import requests
import sys 
reload(sys) 
sys.setdefaultencoding('utf8')  #设置文件的编码方式

url = 'http://apis.baidu.com/jidichong/school_search/school_search'
headers = {'apikey':'c57bc70b78d5926e8cfbb3ad9c195465'}
data = {'name': '清华大学'}
r = requests.post(url , data = data, headers = headers )
print r.text
```

```
程序运行结果同上带参数和Header的GET请求，注意这是因为这个接口能够接收GET和POST两种方式的请求，如果你使用的接口有规定只使用GET方法，
那还是按规定来吧，要不然请求肯定失败。
```

##### POST发送JSON数据

由于没有找到合适的可以接收JSON数据的API来做这个测试，所以这里摘抄了别人的一段代码，貌似这个接口也不能用了，悲剧啊。不过，反正就是使用json.dumps将dict转换成json格式的数据之后添加到post的参数中然后再发送post请求就对了。

```
# -*- coding:utf-8 -*-
import requests
import json

url = 'https://api.github.com/some/endpoint'
payload = {'some': 'data'}
r = requests.post(url, data = json.dumps(payload))
print r.text
```

貌似这个接口也不能用了，待博主找到一个更好的API接口再来更新吧，先写到这里了。说实话，总结了四个网络请求模块，把我自己都搞晕了，但是最后也还是弄清楚了，可能放在一起来看有点容易搞混，但是有对比才有知道自己应该用哪个啊。



