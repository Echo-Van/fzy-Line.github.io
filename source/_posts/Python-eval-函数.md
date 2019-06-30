---
title: Python eval 函数
tags:
  - Python
categories:
  - Coding
  - Python
abbrlink: 61266
date: 2019-06-16 16:28:40
---

<center>Python eval 函数学习与总结。</center>

<!--more-->

#### 基本用法

##### 简介

　　`eval()` 函数用来执行一个字符串表达式，并返回表达式的值。

```python
eval(expression[, globals[, locals]])
```

- `expression` ：表达式。
- `globals` ：变量作用域，全局命名空间，如果被提供，则必须是一个字典对象。
- `locals` ：变量作用域，局部命名空间，如果被提供，可以是任何映射对象。

```python
>>>x = 7
>>> eval( '3 * x' )
21
>>> eval('pow(2,2)')
4
>>> n=81
>>> eval("n + 4")
85
```

##### 默认作用域

　　在 `globals` 和 `locals` 两个参数省略的情况下，`eval()` 函数在当前的作用域执行：

```python
x = 100
y = 200


def compute():
    x = 10
    y = 20
    print(eval("x + y"))


compute()
```

　　输出结果：

```
30
```

##### globals 作用域

　　Python 的全局名字空间存储在一个叫 `globals()` 的字典对象中；局部名字空间存储在一个叫 `locals()` 的字典对象中。我们可以用 `print ()` 来查看该函数体内的所有变量名和变量值。

```python
x = 100
y = 200


def compute():
    x = 10
    y = 20
    print(globals())
    print(locals())


compute()
```

　　输出结果：

```
{'__name__': '__main__', '__doc__': None, '__package__': None, '__loader__': <_frozen_importlib_external.SourceFileLoader object at 0x0000024AC58C7710>, '__spec__': None, '__annotations__': {}, '__builtins__': <module 'builtins' (built-in)>, '__file__': 'D:/Code/draw.py', '__cached__': None, 'x': 100, 'y': 200, 'compute': <function compute at 0x0000024AC587C268>}
{'x': 10, 'y': 20}
```

　　从结果可以看到，`globals()` 的结果包含了全局变量 `'x': 100, 'y': 200` ，而 `locals()` 则包含的是局部变量 `'x': 10, 'y': 20`。eval 函数包含 `globals` 参数则会使用全局作用域下的变量。

```python
x = 100
y = 200


def compute():
    x = 10
    y = 20
    print(eval("x + y", globals()))

    
compute()
```

　　输出结果：

```
300
```

##### locals 作用域

如果同时包含 `globals` 和 `locals` 参数，则会优先在本地作用域查找，如果本地作用域没有，才会查找全局作用域。

```python
x = 100


def compute():
    y = 20
    print(eval("x + y", globals(), locals()))


compute()
```

　　输出结果：

```
120
```

#### 字符串转换

##### 字符串转换成列表

```PYTHON
s = "[[1,2], [3,4], [5,6]]"
print(type(s))
lst = eval(s)
print(type(lst))
print(lst)
```

　　输出结果：

```
<class 'str'>
<class 'list'>
[[1, 2], [3, 4], [5, 6]]
```

##### 字符串转换成字典

```python
s = "{'math': 90, 'chinese': 100}"
print(type(s))
dic = eval(s)
print(type(dic))
print(dic)
```

　　输出结果：

```
<class 'str'>
<class 'dict'>
{'math': 90, 'chinese': 100}
```

##### 字符串转换成元组

```python
s = "([1,2], [3,4], [5,6])"
print(type(s))
tup = eval(s)
print(type(tup))
print(tup)
```

　　输出结果：

```
<class 'str'>
<class 'tuple'>
([1, 2], [3, 4], [5, 6])
```

#### 需要注意的地方

　　`eval()` 函数有安全性问题，比如用户恶意输入就会获得当前目录文件。

```python
eval("__import__('os').system('dir')")
```

　　甚至查看目录下的所有文件的内容：

```
eval(open(‘filename’).read())
```

　　怎么避免安全问题？

- 自行写检查函数；

- 使用 [ast.literal_eval](<https://docs.python.org/zh-cn/3.7/library/ast.html>)