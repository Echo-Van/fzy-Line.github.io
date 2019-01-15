---
title: LeetCode 119. Pascal's Triangle II
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 49279
date: 2018-12-12 23:27:33
---

<center>LeetCode 119. Pascal's Triangle II 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Given a non-negative index *k* where *k* ≤ 33, return the *k*th index row of the Pascal's triangle.

Note that the row index starts from 0.

- **中文：** 

给定一个非负索引 *k*，其中 *k* ≤ 33，返回杨辉三角的第 *k* 行。

![](https://upload.wikimedia.org/wikipedia/commons/0/0d/PascalTriangleAnimated2.gif)

在杨辉三角中，每个数是它左上方和右上方的数的和。

##### 示例

```
输入: 3
输出: [1,3,3,1]
```

##### 进阶

你可以优化你的算法到 *O*(*k*) 空间复杂度吗？

##### 题解

- **题解 1**

　　使用 118. Pascal's Triangle 中的思路，保存每一行的结果，但是，最后只返回保存结果的最后一行即可。注意，这里给的是行的索引，从 0 开始的。

```python
class Solution:
    def getRow(self, rowIndex):
        """
        :type rowIndex: int
        :rtype: List[int]
        """
    	res = []
        for i in range(rowIndex+1):
            res.append([1])
            for j in range(1, i + 1):
                if j == i:
                    res[i].append(1)
                else:
                    res[i].append(res[i - 1][j - 1] + res[i - 1][j])
        return res[-1]
```

- **题解 2**

　　依然考虑杨辉三角的规律：（1）第 i 层有 i 个元素。（2）每层第一个以及最后一个元素值为 1。（3）对于第 `i (i > 2)` 层第 `j（j > 1 && j < i）` 个元素 `A[i][j]`，A`[i][j] = A[i-1][j-1] + A[i-1][j]` 。这里我们不需要存储每一行的数据，每次用上一行数据生成中间的数，每行的第一个以及最后一个元素值为 1，依次更新，直到要求的索引行数。

```python
class Solution:
    def getRow(self, rowIndex):
        """
        :type rowIndex: int
        :rtype: List[int]
        """
        res = [1]
        if rowIndex == 0:  # 只有 1 行的情况
            return res
        for i in range(rowIndex + 1):  # 依次生成每行
            tmp = res  # 存储上一行元素
            res = [1]  # 第一个
            for j in range(i - 1):
                res.append(tmp[j] + tmp[j + 1])  # 用上一行元素生成该行的中间元素
            res.append(1)  # 最后一个元素
        return res
```

