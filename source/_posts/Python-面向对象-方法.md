---
title: Python 面向对象-方法
tags:
  - Python
categories:
  - Coding
  - Python
abbrlink: 39214
date: 2019-06-12 17:20:29
---

<center>Python 面向对象，类方法、静态方法、实例方法和属性方法学习与总结。</center>

<!--more-->

#### 类方法

　　类方法是类对象的方法，在定义时需要在上方使用 `@classmethod` 进行装饰，形参为 `cls`。表示类对象，类对象和实例对象都可调用。

```python
class Person:
    def __init__(self, name, age, phone):
        self.name = name
        self.age = age
        self._phone = phone

    @classmethod
    def say(cls):  # 传递参数为cls
        print("Hello......")


p = Person("fzy", 24, "13111112222")
p.say()  # 类的实例对象调用
Person.say()  # 类对象调用
```

　　输出结果：

```
Hello......
Hello......
```

#### 静态方法

　　静态方法是一个任意函数，在其上方使用 `@staticmethod` 进行装饰，可以用对象直接调用，静态方法实际上跟该类没有太大关系。

```python
class Person:
    def __init__(self, name, age, phone):
        self.name = name
        self.age = age
        self._phone = phone

    @staticmethod
    def say():  # 无需传递参数
        print("Hello......")


p = Person("fzy", 24, "13111112222")
p.say()  # 类的实例对象调用
Person.say()  # 类对象调用
```

　　输出结果：

```
Hello......
Hello......
```

　　在 Python 3 中，如果方法只通过类调用，而不需要通过实例调用的话，不用非要声明为静态的。

```
class Person:
    def __init__(self, name, age, phone):
        self.name = name
        self.age = age
        self._phone = phone

    @staticmethod
    def say():  # 无需传递参数
        print("Hello......")


p = Person("fzy", 24, "13111112222")
p.say()  # 类的实例对象调用
Person.say()  # 类对象调用
```



#### 实例方法

　　类实例方法是类实例化对象的方法，只有实例对象可以调用，形参为 `self`，指代对象本身。

```python
class Person:
    def __init__(self, name, age, phone):
        self.name = name
        self.age = age

    def say(self):  # 传递参数self
        print("My name is ", self.name)


p = Person("fzy", 24, "13111112222")
p.say()  # 类的实例对象调用
```

　　输出结果：

```
My name is fzy
```

#### 属性方法

　　通常，在面向对象的编程语言里，会为私有属性设置 `getter` 和 `setter` 方法来实现对私有属性的获取和设置功能。如下所示：

```python
class Person:
    def __init__(self, name, age):
        self._name = name
        self._age = age

    def get_name(self):
        return self._name

    def set_name(self, value):
        self._name = value

    def get_age(self):
        return self._age

    def set_age(self, value):
        self._age = value


p = Person("fzy", 24)
print(p.get_name(), p.get_age())
p.set_name("cj")
p.set_age(23)
print(p.get_name(), p.get_age())
```

　　输出结果：

```
fzy 24
cj 23
```

　　属性方法的作用就是通过 `@property` 把一个方法变成一个静态属性。使用 `property` 取代 `getter` 和 `setter` 方法。

```python
class Person:
    def __init__(self, name, age):
        self._name = name
        self._age = age

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, value):
        self._name = value

    @property
    def age(self):
        return self._age

    @age.setter
    def age(self, value):
        self._age = value


p = Person("fzy", 24)
print(p.name, p.age)
p.name = "cj"
p.age = 23
print(p.name, p.age)
```

　　输出结果：

```
fzy 24
cj 23
```



