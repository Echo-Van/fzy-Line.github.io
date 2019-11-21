---
title: 剑指offer-数学
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 10888
date: 2019-08-17 22:01:29
---

<center>秋招，来了！</center>
<!--more-->

#### 求1+2+3+...+n

##### 题目描述

　　求1+2+3+...+n，要求不能使用乘除法、for、while、if、else、switch、case等关键字及条件判断语句（A?B:C）。

##### 题解 1

　　使用递归，利用逻辑与的短路特性实现递归终止。使用and 运算符时，前一项为假则整个表达式为假，即 `A and B`，如果 A 为 false 则不会计算 B。 因此可以利用这个性质进行递归运算达到累加的目的。

```python
# -*- coding:utf-8 -*-
class Solution:
    def Sum_Solution(self, n):
        return n and n + self.Sum_Solution(n - 1)
```

##### 题解 2

　　使用 reduce() 函数，它会对参数序列中元素进行累积。函数将一个数据集合（链表，元组等）中的所有数据进行下列操作：用传给 reduce 中的函数 function（有两个参数）先对集合中的第 1、2 个元素进行操作，得到的结果再与第三个数据用 function 函数运算，最后得到一个结果。

　　reduce() 函数语法：

```python
reduce(function, iterable[, initializer])
```

- function -- 函数，有两个参数
- iterable -- 可迭代对象
- initializer -- 可选，初始参数

　　注意：在 Python3 中如果使用 reduce 需要先导入 `from functools import reduce` 。

```python
# -*- coding:utf-8 -*-
class Solution:
    def Sum_Solution(self, n):
        return reduce(lambda x, y: x+y, range(1,n+1))
```

#### 不用加减乘除做加法

##### 题目描述

　　写一个函数，求两个整数之和，要求在函数体内不得使用+、-、*、/四则运算符号。

##### 题解 1

​    通过自增自减来实现（依然用到了加法，好像不太符合题目要求）：

```python
# -*- coding:utf-8 -*-
class Solution:
    def Add(self, num1, num2):
        if num1 < 0:
            while num1:
                num1 += 1
                num2 -= 1
        else:
            while num1:
                num1 -= 1
                num2 += 1
        return num2
```

##### 题解 2

　　使用位运算解题：

- 两个数异或：相当于每一位相加，而不考虑进位；
- 两个数相与，并左移一位：相当于求得进位；
- 将上述两步的结果相加。

```
比如：5+7，注：5=101，7=111，
1. 不考虑进位值，进行异或，101^111=010
2. 计算进位值，先进行与，101&111=101，再左移一位，得到1010
3. 重复1，2

1. 不考虑进位值，进行异或，0010^1010=1000
2. 计算进位值，先进行与，0010&1010=0010，再左移一位，得到00100
3. 重复1，2 

1. 不考虑进位值，进行异或，01000^00100=01100
2. 计算进位值，先进行与，01000&00100=0，左移之后还是0
3. 此时，进位值为0，所以计算可以终止，最终结果为01100，即12
```

　　代码：

```python
# -*- coding:utf-8 -*-
class Solution:
    def Add(self, num1, num2):
        while num2:
            result = num1^num2
            num2 = (num1 & num2) << 1
            num1 = result
        return num1
```

　　提交后，发现超时。自己测试发现当一个整数和一个负数相加时出现了死循环，问题出在 `result= num1^num2` 。实际上，在进行负数的按位加法时，有可能发生在最高位还要向前进一位的情形，正常来说，这种进位因为超出了一个int可以表示的最大位数，应该舍去才能得到正确的结果。

　　在早期版本中如 Python2.7 中，整数的有 int 和 long 两个类型。int类型是一个固定位数的数；long 则是一个理论上可以存储无限大数的数据类型。当数大到可能溢出时，为了避免溢出，Python 会把 int 转化为 long。而Python3.x 之后整数只有一个可以放任意大数的 int 了。可是无论哪种，都是采用了特殊的方法实现了不会溢出的大整数。 所以会使程序无限的算下去，这也是 Python 效率低的一个原因。

　　修改代码，每次都把 num1 规定成一个 32 位的数：

```python
# -*- coding:utf-8 -*-
class Solution:
    def Add(self, num1, num2):
        while num2:
            result = num1^num2
            num2 = (num1 & num2) << 1
            num1 = result & 0xFFFFFFFF
        return num1 if num1 >> 31 == 0 else num1 - 4294967296
```

#### 丑数

##### 题目描述

　　把只包含质因子2、3和5的数称作丑数（Ugly Number）。例如6、8都是丑数，但14不是，因为它包含质因子7。 习惯上我们把1当做是第一个丑数。求按从小到大的顺序的第N个丑数。

##### 题解

　　遍历法效率太低，会超时。因此，我们将查找的丑数按从小到大的顺序排好序，注意每个丑数必为前面的丑数乘以 2、3 或 5 得到的；把现有最大丑数记为 M，则把第一个乘以 2 后大于 M 的结果记为 M2，同理，把每个丑数乘以 3 和 5 ，得到的第一个大于 M 的结果为 M3 和 M5，那么下一个丑数必为 M2/M3/M5 这三个数的最小者。

```python
# -*- coding:utf-8 -*-
class Solution:
    def GetUglyNumber_Solution(self, index):
        if index == 0:
            return 0
        cnt = 1
        min2 = min3 = min5 = 0
        base = [1]
        while cnt < index:
            min_num = min(base[min2]*2, base[min3]*3, base[min5]*5)
            base.append(min_num)
            # 找到第一个乘以2的结果等于当前最大丑数min_num的数字
            if min_num == base[min2]*2:
                min2 += 1
            # 找到第一个乘以3的结果大于当前最大丑数min_num的数字
            if min_num == base[min3]*3:
                min3 += 1
            # 找到第一个乘以5的结果大于当前最大丑数min_num的数字
            if min_num == base[min5]*5:
                min5 += 1
            cnt += 1
        return base[cnt-1]
```