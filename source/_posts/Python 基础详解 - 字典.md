---
title: Python 基础详解 - 字典
tags:
  - Python
  - 字典
categories:
  - Coding
  - Python
abbrlink: 27689
date: 2017-01-13 22:31:26
---



　　字典是 Python 中唯一内建的映射类型（哈希表）。字典中的值并没有特殊的顺序，但是都存储在一个特定的键下。键可以是数字、字符串甚至是元组。

　　字典中的键是唯一的，但值并不唯一。

<!--more-->

　　字典对象是可变的，但是字典的键必须使用不可变对象，并且一个字典中可以使用不同类型的键值。

#### 创建字典

##### 使用 {} 创建

```python
>>> d = {'name':'fzy','age':'22','class':'13-3'}
>>> d
{'age': '22', 'name': 'fzy', 'class': '13-3'}
```

##### 工厂方法 dict()

```python
>>> items = [('name','fzy'),('age','22'),('class','13-3')]
>>> d = dict(items)
>>> d
{'age': '22', 'name': 'fzy', 'class': '13-3'}
```

　　dict 函数也可以通过关键字参数来创建字典。

```python
>>> d = dict(name='fzy',age='22')
>>> d
{'age': '22', 'name': 'fzy'}
```

#####  内建方法 fromkeys()

　　创建’默认‘字典，字典中元素具有相同的 value，如果没有给出，默认为 None。

```python
>>> {}.fromkeys(('x','y'),-1)
{'y': -1, 'x': -1}
```

#### 基本字典操作

##### 自动添加

　　d[key]=values 将值 values 关联到键 key 上。即使键起初在字典中并不存在，也可以为其赋值，会建立新的项。

##### 访问字典中的值

　　d[key] 返回关联到键 key 上的值。

##### 判断成员资格

　　直接使用 key 访问：key 不存在会报错，可以使用 had_key() 或者 in 和 not in 判断。

##### len 操作

　　len(dict) 返回 dict 中键值对的数量。

```python
>>> d = {'name':'fzy','age':'22','class':'13-3'}
>>> len(d)
3
```

##### del 操作

　　del d[key] 删除字典 d 中键值为 key 的元素，也可以使用 del 删除整个字典。

```python
>>> d = {'name':'fzy','age':'22','class':'13-3'}
>>> del d['class']
>>> d
{'age': '22', 'name': 'fzy'}
>>> del d
>>> d
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'd' is not defined
```

##### 遍历字典

　　方法一：

```python
>>> d = {'name':'fzy', 'age':'22', 'class':'13-3'}
>>> for key in d:
...     print key,d[key]
...
age 22
name fzy
class 13-3
```

　　方法二：

```python
>>> d = {'name':'fzy', 'age':'22', 'class':'13-3'}
>>> for key,value in d.items():
...     print key,value
...
age 22
name fzy
class 13-3
```

#### 字典方法

##### clear() 方法

　　clear() 方法清除字典中所有的项。

```python
>>> d = {'name':'fzy','age':'22','class':'13-3'}
>>> d.clear()
>>> d
{}
```

##### copy() 方法

　　copy() 方法返回一个具有相同键值对的新字典。在复制的时候，使用的是浅拷贝，复制了对象，但是对象中的元素，依然使用引用。


　　**浅拷贝与深拷贝：**

　　浅拷贝：没有拷贝子对象，所以原始数据改变，子对象会改变

　　深拷贝：包含对象里面的自对象的拷贝，所以原始对象的改变不会造成深拷贝里任何子元素的改变

```python
>>> d = {'name':'fzy','age':'22','course':['python','java','c++']}
>>> c = d.copy()
>>> c['name'] = 'xxx'
>>> c['course'].remove('c++')
>>> c
{'course': ['python', 'java'], 'age': '22', 'name': 'xxx'}
>>> d
{'course': ['python', 'java'], 'age': '22', 'name': 'fzy'}
```

　　当副本中替换值时，原字典不受影响，但是，如果修改了某个值，原字典也会改变。避免这个问题的一种方法就是使用深复制，复制其包含的所有值。（可以使用 copy 模块的 deepcopy 函数来实现）

##### items() 和 iteritems() 方法

　　items() 方法将字典所有的项以列表方式返回。列表的每一项都表示为键值对的形式，但是项再返回时没有特定的次序。

```python
>>> d = {'name':'fzy','age':'22','class':'13-3'}
>>> d.items()
[('age', '22'), ('name', 'fzy'), ('class', '13-3')]
```

　　iteritems() 方法与 items() 方法类似，但是会返回一个迭代器对象而不是列表。

```python
>>> it = d.iteritems()
>>> it
<dictionary-itemiterator object at 0x02AFF750>
>>> list(it)    #把迭代对象转换成列表
[('age', '22'), ('name', 'fzy'), ('class', '13-3')]
```

##### keys() 和 iterkeys() 方法

　　keys() 方法返回字典中键的列表，而 iterkeys() 方法返回字典中键的迭代器。

```python
>>> d = {'name':'fzy','age':'22','class':'13-3'}
>>> d.keys()
['age', 'name', 'class']
>>> it = d.iterkeys()
>>> it
<dictionary-keyiterator object at 0x02AFFB40>
>>> list(it)     #把迭代对象转换成列表
['age', 'name', 'class']
```

##### values() 和 itervalues() 方法

　　values() 方法返回字典中所有值的列表，而 itervalues() 方法返回值的迭代器。

```python
>>> d = {'name':'fzy','age':'22','class':'13-3'}
>>> d.values()
['22', 'fzy', '13-3']
>>> it = d.itervalues()
>>> it
<dictionary-valueiterator object at 0x02AFF8A0>
>>> list(it)    #把迭代对象转换成列表
['22', 'fzy', '13-3']
```

##### has_key() 方法

　　has_key(key) 判断字典中是否存在 key，Python3.0 中不包括这个函数，建议使用 in 和 not in 代替。

```
>>> d = { }
>>> d.has_key('name')
False
>>> d['name'] = 'fzy'
>>> d.has_key('name')
True
```

##### fromkeys() 方法

　　fromkeys(seq,val=None) 方法以 seq 中的元素为键创建并返回一个字典，val 为指定的默认值。

```
>>> {}.fromkeys(('x','y'),-1)
{'y': -1, 'x': -1}
```

##### get() 方法

　　get(key,default=None) 方法是个更宽松的访问字典项的方法，访问字典中不存在的项时不会出错。键存在时，get 方法返回键对应的值，如果该键不存在，则返回 default 指定的值，不指定 default 参数时默认返回 None。

```python
>>> d = { }
>>> print d['name']
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
KeyError: 'name'
>>> print d.get('name')
None
```

##### pop() 和 popitem() 方法

　　pop(key，default) 方法用来获得对应于给定键的值，然后将这个键值对从字典中移除。

```python
>>> d = {'name':'fzy','age':'22','class':'13-3'}
>>> d.pop('age')
'22'
>>> d
{'name': 'fzy', 'class': '13-3'}
```

　　popitem() 类似于 list.pop，但是 list.pop 弹出列表的最后一个元素，popitem 弹出随机的项，因为字典是无序的，并没有“最后的元素”或者其他有关顺序的概念。

```python
>>> d = {'name':'fzy','age':'22','class':'13-3'}
>>> d.popitem()
('age', '22')
>>> d
{'name': 'fzy', 'class': '13-3'}
```

##### update() 方法

　　update() 方法可以利用一个字典项更新另一个字典。

```python
>>> d = {'name':'fzy','age':'22','class':'13-3'}
>>> x = {'age':'18','school':'hunau'}
>>> d.update(x)
>>> d
{'age': '18', 'school': 'hunau', 'name': 'fzy', 'class': '13-3'}
```

提供的字典中的项会被添加到旧的字典中，若有相同的键则会进行覆盖。

##### setdefault() 方法

　　setdefault(key,default=None) 方法能够获得与给定值相关联的值，并且在字典中不含有给定键的情况下设定相应的键值。

```python
>>> d = { }
>>> d.setdefault('name','fzy')
'fzy'
>>> d
{'name': 'fzy'}
>>> d.setdefault('name','111')
'fzy'
>>> d
{'name': 'fzy'}
```

　　由上可知，当键不存在的时候，setdefault 返回默认值并且相应地更新字典。如果键存在，那么就返回与其对应的值，但是不改变字典。