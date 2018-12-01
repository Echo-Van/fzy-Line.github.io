---
title: Python Django 学习笔记
tags:
  - Python
  - Django
categories: 
  - Coding
  - Python
abbrlink: 8346
date: 2018-01-13 13:45:41
---

　　Django 是一个 Web 框架，它采用 MTV（Model-Template-View）模型组织，相比其他框架，Django 充分利用 Python 特点，开发效率更高。

<!--more-->

#### 环境配置

　　这篇博客基于：Python3.6 + PyCharm社区版 + Windows7命令行。使用 pip 安装 Django：

```shell
$ pip install django
```

#### Django开发简单示例

1. 创建工程：`django-admin startproject mysite`
2. 修改工程：
    2.1 创建一个具体应用（app）
    2.2 修改应用的 views.py：对 URL 的具体响应功能
    2.3 修改URL路由：指定 URL 与响应之间的关系
3. 运行测试工程：`$ python manage.py runserver`

#### Django工程

##### 创建工程

　　打开 cmd，使用 django-admin 工具创建 Django 工程：

```shell
$ django-admin startproject mysite
```

##### 目录结构

```
.
├── manage.py
└── mysite
    ├── __init__.py
    ├── settings.py
    ├── urls.py
    └── wsgi.py
```

- manage.py

　　一个实用的命令行工具，实现以各种方式与该 Django 项目进行交互。

- \_\_init\_\_.py

　　让 Python 把该目录当成一个开发包 (即一组模块)所需的文件。 这是一个空文件，一般你不需要修改它。

- settings.py

　　部署和配置整个工程的配置文件，包含 Django 的设置、配置文件，比如 DEBUG 的开关，静态文件的位置等等。

- urls.py

　　可视其为 Django 网站的目录，URL 路由的声明文件（路由文件），链接入口，关联到对应的 views.py 中的一个函数（或者称作 generic 类），访问的链接就对应一个函数。

- wsgi.py

　　基于 WSGI 的 Web 服务器的配置文件。

##### django-admin

　　django-admin 是一个 Django 框架全局的管理工具，它具有以下功能：

- 建立并管理 Django 工程
- 建立并管理 Django 工程使用的数据库
- 控制调试或日志信息
- 运行并维护 Django 工程

　　使用示例：

```
$  django-admin <command> [options]
```

　　查看更多命令可使用帮助：

```
$  django-admin -help
```

##### manage.py

　　与 django-admin 类似，但 manage.py 仅针对当前项目。查看更多命令可使用帮助：

```shell
$ python manage.py help
```

　　使用示例：

```shell
$ python manage.py <command> [options]
or
$ python –m django <command> [options]
```

##### 运行工程

```shell
$ python manage.py runserver
```

　　打开浏览器，输入 [http://127.0.0.1:8080](http://127.0.0.1:8080) 即可看到 Django 默认的页面。

#### Django 应用

　　工程对应于一个网站，是配置和应用的集合，应用对应于特定功能，是具体功能的载体，配置和功能分离是高度模块化的体现。

##### 创建应用

　　一般一个项目有多个 app，当然通用的 app 也可以在多个项目中使用。

```
> cd mysite
> django-admin startapp app
or
> python manage.py startapp app
```

##### Django 目录结构

```
.
├── app
│   ├── admin.py
│   ├── apps.py
│   ├── __init__.py
│   ├── migrations
│   │   └── __init__.py
│   ├── models.py
│   ├── tests.py
│   └── views.py
```

- admin.py

　　后台文件，可以用少量的代码就拥有一个强大的后台。

- apps.py

　　App 的配置文件。

- \_\_init\_\_.py

　　让 Python 把该目录当成一个开发包所需的文件。

- views.py

　　包含对某个HTTP请求（url）的响应，用于处理用户发出的请求，从 urls.py 中对应而来，通过渲染 templates 中的网页可以为用户显示页面内容，比如登录后的用户名，用户请求的数据，通过其输出到页面。

- models.py

　　与数据库操作相关，存入或读取数据时使用。当不使用数据库的时候，也可以当做一般的类封装文件，存储各种类的定义。

##### 修改应用

- 修改应用的 views.py

　　views.py 中包含对某个 HTTP 请求（url）的响应，在其中添加以下代码：

```python
from django.http import HttpResponse

# 设置处理请求的函数
def hello(request):
    return HttpResponse('Hello, Welcome!')
```

- 修改工程的 url.py 中的 URL 路由

　　在 urls.py 中指定 URL 与处理函数之间的路径关系，在文件中添加指定路由：

```python
from django.contrib import admin
from django.urls import path
from app import views   # 添加app的views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('index/', views.hello)   # 添加路由条目
]
```

　　注：Pycharm 导入自己写的包时可能会报错，这时候需要在项目目录上右键选择 Mark Directory as，然后选择 Source Root。

#### 运行测试工程

　　运行 Django：

```shell
> python manage.py runserver
```

　　使用浏览器访问以下地址：[http://127.0.0.1:8000/index/](http://127.0.0.1:8000/index/)

　　可以看到已经正常显示了：Hello, Welcome!
