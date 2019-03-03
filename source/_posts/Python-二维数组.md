---
title: Python 二维数组
tags:
  - Python
  - Array
categories:
  - Coding
  - Python
abbrlink: 58371
date: 2019-02-04 19:46:57
---

<center>Python 二维数组学习。</center>

<!--more-->

##### 直接创建法

　　简单粗暴，不过太麻烦，一般不用。

```python
num = [[1,2,3],[4,5,6]]
```

##### 列表生成式法

　　列表生成式即 List Comprehensions，是 Python 内置的非常简单却强大的可以用来创建list的生成式。

　　举例，range 函数生成：

```python
>>> range(1, 11)
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

　　如果要生成 `[1x1, 2x2, 3x3, ..., 10x10]`：

```python
>>> [x * x for x in range(1, 11)]
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

　　相当于：

```python
>>> L = []
>>> for x in range(1, 11):
...    L.append(x * x)
...
>>> L
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

　　还可以在后面加上判断来筛选出仅偶数的平方：

```python
>>> [x * x for x in range(1, 11) if x % 2 == 0]
[4, 16, 36, 64, 100]
```

　　也可以使用两层循环，可以生成全排列：

```python
>>> [m + n for m in 'ABC' for n in 'XYZ']
['AX', 'AY', 'AZ', 'BX', 'BY', 'BZ', 'CX', 'CY', 'CZ']
```

　　当然，最重要的是这里要讲的使用列表生成式来生成二维数组，例如生成 3 行 2 列的 0 数组：

```python
>>> [[0 for i in range(2)] for j in range(3)]
[[0, 0], [0, 0], [0, 0]]
```

　　相当于：

```python
>>> L = []
>>> for _ in range(3):
...     row = []
...     for _ in range(2):
...         row.append(0)
...     L.append(row)
...
>>> L
[[0, 0], [0, 0], [0, 0]]
```

##### 错误的创建方法

　　`list * n` 的意思是 `n` 个 列表的**浅拷贝**的连接。例如，`[[]]` 是一个含有一个空列表元素的列表，所以 `[[]]*3` 表示 3 个指向这个空列表元素的引用，修改任何一个元素都会改变整个列表：

```python
>>> L = [[]]*3
>>> L
[[], [], []]
>>> L[0].append(1)
>>> L
[[1], [1], [1]]
```

　　再例如，一维数组使用 `*` 是没有问题的：

```python
>>> num = [[0]*2 for i in range(2)]
>>> print(num)
[[0, 0], [0, 0]]
>>> num[0][0] = 1
>>> print(num)	# 只改变了num[0][0]的值
[[1, 0], [0, 0]]
```

　　但是，**在创建二维数组时就需要特别注意，因为列表在 Python 中是可变对象，外部的 `*` 相当于浅拷贝二维数组的中的一维列表，因此，改变其中任意一个值，其他的浅拷贝都会被改变**。

```python
>>> num = [[0]*2]*2	# 第二个 * 是浅拷贝
>>> print(num)
[[0, 0], [0, 0]]
>>> num[0][0] = 1
>>> print(num)	# num[0][0]和num[1][0]的值都被改变了
[[1, 0], [1, 0]]
```

##### numpy 创建

　　numpy 模块支持大量的维度数组与矩阵运算，此外也针对数组运算提供大量的数学函数库

```python
>>> import numpy as np
>>> L = np.array([[1,2,3],[4,5,6]], dtype=int)  # 创建2*3维数组
>>> L
array([[1, 2, 3],
       [4, 5, 6]])
>>> L.shape
(2, 3)
>>> L.size
6
>>> L.itemsize
4
```

　　利用特殊方法生成特殊的数组，例如生成 3 行 2 列的二维全 0 数组：

```python
>>> import numpy as np
>>> np.zeros((3, 2), dtype=int)
array([[0, 0],
       [0, 0],
       [0, 0]])
```

　　生成 3 行 2 列的二维全 1 数组：

```python
>>> import numpy as np
>>> np.ones((3, 2), dtype=int)
array([[1, 1],
       [1, 1],
       [1, 1]])
```

　　numpy 模块的功能十分强大，其他方法的使用可以查找其官方文档进行学习。