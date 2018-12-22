---
title: LeetCode 118. Pascal's Triangle
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 45311
date: 2018-12-04 19:44:04
---

<center>LeetCode 118. Pascal's Triangle</center>

<!--more-->

##### 题目描述

- **英文**

Given a non-negative integer *numRows*, generate the first *numRows* of Pascal's triangle.

In Pascal's triangle, each number is the sum of the two numbers directly above it.

- **中文**

给定一个非负整数 *numRows，*生成杨辉三角的前 *numRows* 行。

![](https://upload.wikimedia.org/wikipedia/commons/0/0d/PascalTriangleAnimated2.gif)

在杨辉三角中，每个数是它左上方和右上方的数的和。

##### 示例

```
输入: 5
输出:
[
     [1],
    [1,1],
   [1,2,1],
  [1,3,3,1],
 [1,4,6,4,1]
]
```

##### 题解

- **题解 1**

　　规律：（1）第 i 层有 i 个元素。（2）每层第一个以及最后一个元素值为 1。（3）对于第 `i (i > 2)` 层第 `j（j > 1 && j < i）` 个元素 `A[i][j]`，A`[i][j] = A[i-1][j-1] + A[i-1][j]` 。依据以上规律，使用二维数组来实现。

```python
class Solution:
    def generate(self, numRows):
        """
        :type numRows: int
        :rtype: List[List[int]]
        """
        if numRows == 0:
            return []
        else:
            L = [[1]]
        for i in range(1, numRows):
            L1 = []
            for j in range(i+1):
                if j == 0 or j == i:	# 处理每层第一个以及最后一个元素
                    L1.append(1)
                else:	# 中间元素由+得到
                    L1.append(L[i-1][j] + L[i-1][j-1])
                    
            L.append(L1)   
        return L
```

- **题解 2**

　　思路与题解 1 一样，简化的写法。

```python
class Solution:
    def generate(self, numRows):
        """
        :type numRows: int
        :rtype: List[List[int]]
        """
        res = []
        for i in range(numRows):
            res.append([1])
            for j in range(1, i + 1):
                if j == i:
                    res[i].append(1)
                else:
                    res[i].append(res[i - 1][j - 1] + res[i - 1][j])
        return res
```





