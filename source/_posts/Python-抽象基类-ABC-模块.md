---
title: Python 抽象基类 ABC 模块
tags:
  - Python
categories:
  - Coding
  - Python
abbrlink: 54391
date: 2019-07-01 21:36:42
---

<center>Python 抽象基类 ABC 模块学习与总结。</center>

<!--more-->

#### 抽象基类

　　抽象基类主要用于接口设计，而后续的其他类可以覆盖该接口。抽象基类有两个特点：

- 规定继承类必须具有抽象基类指定的方法。
- 抽象基类无法实例化。

　　抽象基类提供了逻辑和实现解耦的能力，即在不同的模块中通过抽象基类来调用，可以用最精简的方式展示出代码之间的逻辑关系，让模块之间的依赖清晰简单。同时，一个抽象类可以有多个实现，让系统的运转更加灵活。而针对抽象类的编程，让每个人可以关注当前抽象类，只关注其方法和描述，而不需要考虑过多的其他逻辑，这对协同开发有很大意义。极简版的抽象类实现，也让代码可读性更高。

#### abc 模块

　　abc 模块是 AbsructBaseClass 的缩写，该模块提供了在 Python 中定义抽象基类的组件。该模块提供了一个元类 ABCMeta，可以用来定义抽象类，另外还提供一个工具类 ABC，可以用它以继承的方式定义抽象基类。抽象基类如果想要声明“抽象方法”，可以使用 `@abstractmethod`，如果想声明“抽象属性”，可以使用`@abstractproperty`。**抽象基类的使用**：

##### 直接继承

　　直接继承抽象基类的子类就没有这么灵活，抽象基类中可以声明”抽象方法“和“抽象属性”，只有完全覆写（实现）了抽象基类中的“抽象”内容后，才能被实例化，而虚拟子类则不受此影响。

```PYTHON
from abc import ABCMeta
class Person(metaclass=ABCMeta):
    @abc.abstractmethod
    def get_name(self, key):
        raise NotImplementedError

    @abc.abstractmethod
    def set_name(self, kye, value):
        raise NotImplementedError

class Student(Person):
    def get_name(self, key):
        pass
    
    def set_name(self, kye, value):
        pass
    
class Teacher(Person):
    pass

p = Person()
s = Student()
t = Teacher()
print('Subclass:', issubclass(Student, Person))
print('Instance:', isinstance(Student(), Person))
```

　　抽象基类的一个主要用途是在代码中检查某些类是否为特定类型，实现了特定接口

##### 虚拟子类

　　将其他的类”注册“到抽象基类下当虚拟子类（调用 register 方法），虚拟子类的好处是你实现的第三方子类不需要直接继承自基类，可以实现抽象基类中的部分 API 接口，也可以根本不实现，但是 `issubclass()`， `issubinstance()` 进行判断时仍然返回真值。

```python
from abc import ABCMeta
class Person(metaclass=ABCMeta):
    @abc.abstractmethod
    def get_name(self, key):
        raise NotImplementedError

    @abc.abstractmethod
    def set_name(self, kye, value):
        raise NotImplementedError

class Student(Person):
    def get_name(self, key):
        pass
    
    def set_name(self, kye, value):
        pass
        
Person.register(Student)
print('Subclass:', issubclass(Student, Person))
print('Instance:', isinstance(Student(), Person))
```

　　在抽象类中抽象方法也可以提供通用的逻辑实现，这样具体类中就可以通过调用super()重用抽象方法的实现：

#### collections.abc 模块

　　collections.abc 模块收集了常用的抽象基类，可用于测试类是否提供特定接口：

```python
__all__ = ["Awaitable", "Coroutine",
           "AsyncIterable", "AsyncIterator", "AsyncGenerator",
           "Hashable", "Iterable", "Iterator", "Generator", "Reversible",
           "Sized", "Container", "Callable", "Collection",
           "Set", "MutableSet",
           "Mapping", "MutableMapping",
           "MappingView", "KeysView", "ItemsView", "ValuesView",
           "Sequence", "MutableSequence",
           "ByteString",
           ]
```

　　例如：

```python
size = None
if isinstance(myvar, collections.abc.Sized):
    size = len(myvar)
```

　　查看 Sized 源码：

```python
class Sized(metaclass=ABCMeta):

    __slots__ = ()

    @abstractmethod
    def __len__(self):
        return 0

    @classmethod
    def __subclasshook__(cls, C):
        if cls is Sized:
            return _check_methods(C, "__len__")
        return NotImplemented
```

　　Sized类改写了 `__subclasshook__` 魔法方法，使其可以通过 `isinstance()` 判断对象是否含有 `__len__` 方法。