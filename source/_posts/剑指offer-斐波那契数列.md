---
title: 剑指offer-斐波那契数列
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 34735
date: 2019-07-10 11:21:36
---

<center>秋招，来了！</center>
<!--more-->

#### 斐波那契数列

##### 题目描述

　　大家都知道斐波那契数列，现在要求输入一个整数n，请你输出斐波那契数列的第 n (n<=39)项（从0开始，第0项为0）。

##### 题解 1

　　斐波那契数列属于经典的递归问题，对于这题的求解，我们首先要知道斐波那契数列的状态转移式，即`f[n]=f[n-1]+f[n-2]`，且在 n=1 或 2 时，f[n]=1。在理解基础的状态转移式后，最容易想到的便是递归调用：

递归法：

```python
# -*- coding:utf-8 -*-
class Solution:
    def Fibonacci(self, n):
        if n <= 1:
            return n
        return self.Fibonacci(n-1) + self.Fibonacci(n-2)
```

　　但很遗憾，这样算法的时间复杂度往往达不到要求。

##### 题解 2

　　仔细观察后可以发现，每次求解的 f[n] 都在之后两个 f[n] 的求解中起作用，因此我们可以将其保存，这样能够避免重复计算，降低算法的时间复杂度；同时，因为只在后续两个 f[n] 的求解中起作用，因此只需要保存两个 f[n] 的值即可。从下向上计算：

```python
# -*- coding:utf-8 -*-
class Solution:
    def Fibonacci(self, n):
        if n <= 1:
            return n
        pre_two = 0
        pre_one = 1
        result = 0
        for i in range(2, n+1):
            result = pre_one + pre_two
            pre_two = pre_one
            pre_one = result
        return result
```

　　也可以简化写成这样：

```python
# -*- coding:utf-8 -*-
class Solution:
    def Fibonacci(self, n):
        if n <= 1:
            return n
        res = 1
        pre = 0
        for i in range(2, n+1):
            res = res + pre
            pre = res - pre
        return res
```

#### 跳台阶

##### 题目描述

　　一只青蛙一次可以跳上1级台阶，也可以跳上2级。求该青蛙跳上一个n级的台阶总共有多少种跳法（先后次序不同算不同的结果）。

##### 题解

```
n  结果  可能的跳法
1   1   (1)
2   2   (11,2)
3   3   (111,12,21)
4   5   (1111,112,121,211,22)
......
F(n)=F(n-1)+F(n-2)
显然，就是斐波那契数列。
```

　　代码：

```python
# -*- coding:utf-8 -*-
class Solution:
    def jumpFloor(self, number):
        if number <= 1:
            return number
        res = 1
        pre = 1
        for i in range(2, number+1):
            res = res + pre
            pre = res - pre
        return res
```

#### 变态跳台阶

##### 题目描述

　　一只青蛙一次可以跳上1级台阶，也可以跳上2级……它也可以跳上n级。求该青蛙跳上一个n级的台阶总共有多少种跳法。

##### 题解

```
n   结果   跳法
1    1    (1)
2    2    (11,2)
3    4    (111,12,21,3)
4    8    (1111,112,121,211,22,13,31,4)
.....
f(3)=f(2)+f(1)+1
推出：f(n)=f(n-1)+f(n-2)+ *** +f(1)+1

而f(n-1)=f(n-2)+ *** +f(1)+1
因此：
f(n)-f(n-1)=f(n-1)
即f(n)=2*f(n-1)
```

　　代码：

```python
# -*- coding:utf-8 -*-
class Solution:
    def jumpFloorII(self, number):
        if number <= 2:
            return number
        return 2**(number-1)
```

#### 矩形覆盖

##### 题目描述

　　我们可以用2\*1的小矩形横着或者竖着去覆盖更大的矩形。请问用n个2\*1的小矩形无重叠地覆盖一个2\*n的大矩形，总共有多少种方法？

##### 题解

```
自己画个图模拟一下：
n   结果
1    1
2    2
3    3
4    5
......
F(n)=F(n-1)+F(n-2)
很显然，又是斐波那契数列。
```

　　代码：

```python
# -*- coding:utf-8 -*-
class Solution:
    def rectCover(self, number):
        if number <= 1:
            return number
        res = 1
        pre = 1
        for i in range(2, number+1):
            res = res + pre
            pre = res - pre
        return res
```