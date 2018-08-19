---
title: Github Pages + Hexo搭建博客（三）
tags:
  - Hexo
  - Github
categories: Hexo
abbrlink: 39803
date: 2016-12-06 16:59:42
---


　　此篇博客主要介绍了自己的博客站点所使用的一些第三方服务的配置，以及主题的一些优化。当然，每个人的需要都不太相同，大家也可以根据自己的喜好去选择使用第三方服务来让自己的博客站点更完善更强大。

<!--more-->

再次强调：在Hexo中有两份主要的配置文件，其名称都是_config.yml。其中，一份位于站点根目录下，主要包含Hexo本身的配置,我们称之为**全局配置文件**；另一份位于主题目录下，这份配置由主题作者提供，主要用于配置主题相关的选项,我们称之为**主题配置文件**。

#### 博客图片存放

Markdown编辑器支持插入图片，可以直接给出图片的链接，因此我们可以将图片存放在我们hexo项目的目录下，再填写对应的路径，也可以将其存放在云服务器上，然后给出链接。

在这里，我们介绍使用七牛云来进行图片托管。七牛云是国内领先的企业级云服务商,致力于打造以数据为核心的场景化PaaS服务，图片加载速度还不错，一般也不会出现图片挂掉的情况。

##### 注册账号

注册申请一个个人账号，然后激活邮箱完成注册。

官网地址：[http://www.qiniu.com/](http://www.qiniu.com/)

##### 存储图片

（1）点击左侧菜单的对象存储

![5-1](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-1.png)

（2）点击上端的添加来创建存储空间

![5-2](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-2.png)

（3）填写好基本信息，点击确定创建

![5-3](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-3.png)

（4）来到新创建的存储空间，点击内容管理

![5-4](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-4.png)

（5）在内容管理中可以看到文件列表，点击上传文件

![5-5](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-5.png)

（6）可以设置上传的文件的前缀，以便进行分类管理

![5-6](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-6.png)

（7）点击关闭，回到内容管理页面查看上传的文件，复制图片链接

![5-7](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-7.png)

至此，我们就将我们博客需要的图片存储到了七牛云，然后我们只要将复制的图片链接插入到博客人文章中即可显示图片，感觉显示速度还是蛮快的。

#### 配置第三方服务

##### 多说社会化评论

（1）多说创建站点

[多说官网：http://duoshuo.com/](http://duoshuo.com/)

登录多说官网，点击主页的我要安装来到创建站点页面填写基本信息：

![5-8](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-8.png)

点击创建后出现：**服务异常,请联系客服人员**的错误不是因为真的出现异常，而是你填写的用户名或者其他信息不符合他的要求，只是他没有提示你，这是需要注意的地方。比如我遇到的是用户名不能使用‘-’中划线和‘_’下划线，或者多说域名填写格式错误。

（2）创建站点完成后在全局配置文件中新增duoshuo_shortname字段。

值设置成上一步中填写的值（红色方框框出部分的值）

例如：

```
duoshuo_shortname: fzyLine
```

（3）实现效果

![5-9](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-9.png)

##### 多说分享

多说分享必须与多说评论同时使用

编辑全局配置文件，添加字段 duoshuo_share，值为 true。

```
# 多说分享服务
duoshuo_share: true
```

实现效果：

![5-10](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-10.png)

##### 不蒜子统计

编辑全局配置文件中的busuanzi_count的配置项。

当enable: true时，代表开启全局开关。若site_uv、site_pv、page_pv的值均为false时，不蒜子仅作记录而不会在页面上显示。

```
busuanzi_count:
  # count values only if the other configs are false
  enable: true
  # custom uv span for the whole site
  site_uv: true
  site_uv_header: <i class="fa fa-user"></i>    #如果使用默认的，会显示图标
  site_uv_footer:
  # custom pv span for the whole site
  site_pv: true
  site_pv_header: <i class="fa fa-eye"></i>     #如果使用默认的，会显示图标
  site_pv_footer:
  # custom pv span for one page only
  page_pv: true
  page_pv_header: <i class="fa fa-file-o"></i>  #如果使用默认的，会显示图标
  page_pv_footer:
```

实现效果：

![5-11](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-11.png)

可以修改成如下的样子：

当site_uv: true时，代表在页面底部显示站点的UV值。即访客数：

```
# 效果：本站访客数12345人次
site_uv: true
site_uv_header: 本站访客数
site_uv_footer: 人次
```

当site_pv: true时，代表在页面底部显示站点的PV值。即总访问量：

```
# 效果：本站总访问量12345次
site_pv: true
site_pv_header: 本站总访问量
site_pv_footer: 次
```

当page_pv: true时，代表在文章页面的标题下显示该页面的PV值（阅读数）。
```
# 效果：本文总阅读量12345次
page_pv: true
page_pv_header: 本文总阅读量
page_pv_footer: 次
```

##### 站内搜索

next主题的官方文档提供了几种实现搜索服务的方式，我们就使用配置最简单的Local Search，添加百度/谷歌/本地 自定义站点内容搜索。

（1）安装 hexo-generator-searchdb，在站点目录下执行以下命令：

```
$ npm install hexo-generator-searchdb --save
```

（2）编辑全局配置文件，新增以下内容到任意位置：

```
search:
  path: search.xml
  field: post
  format: html
  limit: 10000
```

（3）实现效果：

![5-12](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-12.png)


#### 开启打赏功能

next主题开启打赏功能很简单，我们只需要在全局配置文件中填入微信和支付宝收款二维码图片地址即可开启该功能。先到微信和支付宝将自己收款二维码图片保存，我们同样可以将其存在七牛云上，然后贴到下面的配置文件里。

```
reward_comment: 坚持原创技术分享，您的支持将鼓励我继续创作！
wechatpay: 微信当面付图片的url
alipay: 支付宝当面付图片的url
```

实现效果：

![image](http://ohe7ixo05.bkt.clouddn.com/2016/12/5-13.png)

Github pages + Hexo搭建静态博客站点的系列文章到这里就完结了，其实也算是一个很详细的教程了，花了一些时间来整理。之后可能不会再更新，但是，如果之后遇到一些问题或者有更好的推荐，可能还会再写。