---
title: Python Web开发框架Flask
date: 2016-10-08 20:45:13
tags: [Python,Flask,Web]
categories: Python
---


　　Flask是一个使用 Python 编写的轻量级 Web 应用框架。Flask 的设计目标是实现一个 wsgi 的微框架，其核心代码保持简单和可扩展性，很容易学习。Flask是一个易于学习和使用的框架，但是它的功能也是十分强大，后续还会有进一步的学习和总结，这是第一篇python Web的博客。

<!--more-->

flask框架中文版开发文档：[http://docs.jinkan.org/docs/flask/](http://docs.jinkan.org/docs/flask/)

Flask 依赖两个外部库：Werkzeug 和 Jinja2 。 Werkzeug 是一个 WSGI（在 Web 应用和多种服务器之间的标准 Python 接口) 工具集。Jinja2 负责渲染模板。

#### virtualenv -- python虚拟沙盒

virtualenv通过创建独立Python开发环境的工具, 来解决依赖、版本以及间接权限问题。

简单地说，你可以为每个项目建立不同的/独立的Python环境，你将为每个项目安装所有需要的软件包到它们各自独立的环境中。

##### 安装virtualenv

```
$ pip install virtualenv
```
由于权限问题使用sudo临时提升权限

```
$ sudo pip install virtualenv
```

##### 建立并进入虚拟环境

```
$ mkdir myproject
$ cd myproject
```


##### 激活虚拟环境

```
$ . venv/bin/activate  #激活当前virtualenv
```

##### 测试

（1）执行python程序

```
$ sudo python Test.py
```

（2）访问测试

通过浏览器访问如下地址：http://localhost:5000或者http://127.0.0.1:5000/，就可以看到Hello World！

（3）关闭服务器，按 Ctrl+C。

##### 退出虚拟环境

```
$ deactivate
```

##### 删除虚拟环境

```
$ rm -r venv
```

##### 获取帮助

```
$ virtualenv -h
```

#### Flask框架

##### 安装flask

```
$ pip install flask
```

##### 基本框架

（1）完整的Flask程序

```
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World!'

if __name__ == '__main__':
    app.run()
```

（2）框架说明

```
from flask import Flask
app = Flask(__name__)
```
以上代码中首先导入了 Flask 类，并得到了该类的的实例app，这将会是我们的 WSGI 应用程序。

```
@app.route('/')
def hello_world():
    return 'Hello World!'
 
```
以上代码中route() 装饰器告诉Flask什么样的URL 能触发我们的函数。即route() 装饰器把一个函数绑定到对应的URL上，这个函数返回我们想要显示在用户浏览器中的信息。

```
if __name__ == '__main__':
    app.run()
```

以上代码中用 run() 函数来让应用运行在本地服务器上。其中 if __name__ == '__main__': 确保服务器只会在该脚本被Python解释器直接执行的时候才会运行，而不是作为模块导入的时候。



##### 调试模式

启用了调试支持，服务器会在代码修改后自动重新载入，并在发生错误时提供一个相当有用的调试器。

有两种途径来启用调试模式。一种是直接在应用对象上设置:


```
app.debug = True
app.run()
```

另一种是作为 run 方法的一个参数传入:

```
app.run(debug=True)
```

##### 路由配置

route() 装饰器把一个函数绑定到对应的 URL 上。
 
 ```
@app.route('/')
def index():
    return 'Index Page'
#通过http://127.0.0.1:5000访问

@app.route('/hello')
def hello():
    return 'Hello World'
#通过http://127.0.0.1:5000/hello访问
```

可以给 URL 添加变量部分，你可以把这些特殊的字段标记为 <variable_name> ， 这个部分将会作为命名参数传递到你的函数。规则可以用 <converter:variable_name> 指定一个可选的转换器。
 
```
@app.route('/user/<username>')
def show_user_profile(username):
    return 'User %s' % username
#通过http://127.0.0.1:5000/user/加上名字访问


@app.route('/post/<int:post_id>')
def show_post(post_id):
    # show the post with the given id, the id is an integer
    return 'Post %d' % post_id
#通过http://127.0.0.1:5000/post/加上id访问
```

默认情况下，路由只回应 GET 请求，但是通过 route() 装饰器传递 methods 参数可以改变这个行为。

```
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        do_the_login()
    else:
        show_the_login_form()
```

关于HTTP协议的相关方法请参考博主博客：[Android网络编程：HTTP协议](http://www.line-coding.tech/index.php/2016/08/22/android-http-2/)

通过以上的学习对于Flask框架应该有了一个基本的认识，后续的博文中还将继续深入学习，敬请关注。

