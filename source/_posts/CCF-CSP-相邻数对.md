---
title: CCF-CSP 相邻数对
tags:
  - 算法学习
  - CCF-CSP
categories:
  - Algorithm
  - CCF-CSP
abbrlink: 55735
date: 2018-09-21 19:06:15
---

<center>CCF-CSP 201409-1 相邻数对 题解</center>

<!--more-->

#### 问题描述

```
试题编号：201409-1
试题名称：相邻数对
时间限制：1.0s
内存限制：256.0MB

问题描述
    给定n个不同的整数，问这些数中有多少对整数，它们的值正好相差1。

输入格式
    输入的第一行包含一个整数n，表示给定整数的个数。
    第二行包含所给定的n个整数。

输出格式
    输出一个整数，表示值正好相差1的数对的个数。

样例输入
    6
    10 2 6 3 7 8

样例输出
    3

样例说明
    值正好相差1的数对包括(2, 3), (6, 7), (7, 8)。

评测用例规模与约定
    1<=n<=1000，给定的整数为不超过10000的非负整数。
```

#### 题解1

　　从第一个数开始，依次向后扫描，每次将该数与其之后的数进行比较，检查差值是不是 1，如果是则是相邻数，否则不是。样例演示如下：

　　10与2，10与6，10与3，10与7，10与8比较

　　2与6，2与3，2与7，2与8比较

　　......以此类推

　　Python 代码实现：

```python
n = int(input())  # 获取整数个数的输入
a = list(map(int, input().split()))  # 获取输入的n个整数
count = 0  # 计数
for i in range(n - 1):  # 按顺序扫描
    for j in range(i + 1, n):
        if abs(a[j] - a[i]) == 1:  # 判断是否是相邻数
            count += 1
print(count)  # 输出结果
```

#### 题解2

　　与题解 1 不同的是，我们可以使用 `sort()` 函数对输入的数据先进行排序，然后再扫描列表，判断其与后面一个数的差值是否为 1，如果是则是相邻数，否则不是。样例演示如下：

　　排序后：2，3，6，7，8，10

　　2与3，3与6，6与7，7与8，8与10比较即可。

　　Python 代码实现：

```python
n = int(input())	# 获取整数个数的输入
a = list(map(int, input().split()))	# 获取输入的n个整数
a.sort()	# 排序
count = 0
for i in range(n-1):	# 按顺序扫描
    if a[i]+1 == a[i+1]:	# 判断是否是相邻数
        count += 1
print(count)	# 输出结果
```

#### 知识点补充

##### abs() 函数

　　`abs()` 函数返回数字的绝对值。参数可以是实数(整数、浮点数等）或复数，如果参数是复数，则返回复数的模。

```python
>>> abs(-1)
1
>>> abs(-11.1)
11.1
>>> abs(4+3j)
5.0
```

##### sort() 函数

　　`sort()` 函数用于对原列表进行排序，如果指定参数，则使用比较函数指定的比较函数。

```python
list.sort(cmp=None, key=None, reverse=False)
```

　　参数说明：

- key指定一个参数的函数，该函数用于从每个列表元素中提取比较键（例如，key=str.lower）。对应于列表中每个项的键计算一次，然后用于整个分类过程。默认值None 表示列表项直接排序而不计算单独的键值。
- reverse 排序规则，reverse = True 降序， reverse = False 升序（默认）。

　　参数 `reverse` 的使用，升序与降序：

```python
>>> L = [1, 3, 2, 4]
>>> L.sort() # 升序
>>> print(L)
[1, 2, 3, 4]
>>> L.sort(reverse=True) # 降序
>>> print(L)
[4, 3, 2, 1]
```

　　参数 `key` 的使用：

```python
>>> L = ['a','Z','w','C','A','b','t']
>>> L.sort(key=str.lower)
>>> print(L)
['a', 'A', 'b', 'C', 't', 'w', 'Z']
```

　　通过指定列表中的元素排序来输出列表：

```python
def takeSecond(elem): # 取第2个元素
    return elem[1]

L = [(2, 2), (3, 4), (4, 1), (1, 3)]
L.sort(key=takeSecond)
print(L)
```

　　输出结果：

```
[(4, 1), (2, 2), (1, 3), (3, 4)]
```

　　使用 `lambda` ，按 `value` 排序：

```python
>>> L = [('fzy', 23), ('zxc', 22), ('qwe', 18)]
>>> L.sort(key=lambda k:k[1])
>>> print(L)
[('qwe', 18), ('zxc', 22), ('fzy', 23)]
```

　　使用 `lambda` ，按照 `key` 排序：

```python
>>> L = [('fzy', 23), ('zxc', 22), ('qwe', 18)]
>>> L.sort(key=lambda k:k[0])
>>> print(L)
[('fzy', 23), ('qwe', 18), ('zxc', 22)]
```

　　使用 `lambda` ，先按 `key` 后按 `value` 排序：

```python
>>> L = [('fzy', 23), ('zxc', 22), ('qwe', 18)]
>>> L.sort(key=lambda k:(k[0], k[1]))
>>> print(L)
[('fzy', 23), ('qwe', 18), ('zxc', 22)]
```

　　`lambda` 函数：

- `lambda` 函数是匿名的：所谓匿名函数，通俗地说就是没有名字的函数。
- `lambda` 函数有输入和输出：输入是传入到参数列表的值，输出是根据表达式计算得到的值。
- `lambda` 函数一般功能简单：单行表达式决定了 `lambda` 函数不可能完成复杂的逻辑，只能完成非常简单的功能。由于其实现的功能一目了然，甚至不需要专门的名字来说明。

　　使用示例：

```python
lambda x, y: x*y；函数输入是x和y，输出是它们的积x*y
lambda *args: sum(args); 输入是任意个数的参数，输出是它们的和
```

