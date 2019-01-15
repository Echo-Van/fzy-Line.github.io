---
title: LeetCode 268. Missing Number
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 35039
date: 2019-01-05 19:50:38
---

<center>LeetCode 268. Missing Number 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Given an array containing *n* distinct numbers taken from `0, 1, 2, ..., n`, find the one that is missing from the array.

- **中文：** 

给定一个包含 `0, 1, 2, ..., n` 中 *n* 个数的序列，找出 0 .. *n* 中没有出现在序列中的那个数。

##### 示例

- **示例 1:**

```
输入: [3,0,1]
输出: 2
```

- **示例 2:**

```
输入: [9,6,4,2,3,5,7,0,1]
输出: 8
```

##### 题解

- **题解 1**

　　由于索引即为 0 到 n 的数，所以可以先对数组进行排序，然后遍历数组，依次比较每个数是否与其索引相等，如果不相等，则对应的索引即为缺失值。当然，还要注意处理最后一个数缺失的情况，因为遍历数组只能处理 0 到 n-1。

```python
class Solution:
    def missingNumber(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        length = len(nums)
        nums.sort()  # 排序
        for i in range(length):  # 遍历数组，判断列表值是否与索引相等
            if nums[i] != i:  # 如果不相等，则索引即为缺失的数
                return i
        return nums[length - 1] + 1  # 处理缺失最后一个数的情况
```

- **题解 2** 

　　首先计算 0 到 n 的和，然后用和减去数组元素的和，即可得到缺失的元素。

```python
class Solution:
    def missingNumber(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        con = 0
        for i in range(len(nums)+1):	# 求和
            con += i
        return con - sum(nums)	# 得到缺失值
```

　　也可以直接使用公式计算和，然后减去数组元素的和，即可得到缺失的元素。

```python
class Solution:
    def missingNumber(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        length = len(nums)          
        return int(length*(length+1)/2 - sum(nums))
```