---
title: LeetCode 1. Two Sum
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 30593
date: 2018-12-01 19:44:19
---

<center>LeetCode 1. Two Sum 题解</center>

<!--more-->

##### 题目描述

- **英文**

Given an array of integers, return **indices** of the two numbers such that they add up to a specific target.

You may assume that each input would have **exactly** one solution, and you may not use the *same* element twice.

- **中文**

给定一个整数数组和一个目标值，找出数组中和为目标值的**两个**数。

你可以假设每个输入只对应一种答案，且同样的元素不能被重复利用。

##### 示例

```
给定 nums = [2, 7, 11, 15], target = 9

因为 nums[0] + nums[1] = 2 + 7 = 9
所以返回 [0, 1]
```

##### 题解

- **题解 1**

　　两层循环暴力求解，对于列表的每个数，依次使其与其后所有的数单独求和，判断和是否为目标值。

```python
class Solution:
    def twoSum(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: List[int]
        """
        length = len(nums)
        for i in range(length - 1):
            for j in range(i + 1, length):  # i 之后的数
                if nums[i] + nums[j] == target:  # 判断是否等于目标值
                    return i, j
```

- **题解 2**

　　用一层循环，直接在里面查询 `target-nums[i]` 是否存在于 `nums` 列表中，速度比题解 1 快了许多。

```python
class Solution:
    def twoSum(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: List[int]
        """
        for i in range(len(nums)):
            x = target - nums[i]
            if x in nums:  # 是否有对应的数与 nums[i] 的和为目标值
                j = nums.index(x)
                if i == j:
                    continue
                else:
                    return i, j  # 输出结果
```

- **题解 3** 

　　遍历数组，然后使用字典，键为 `target-nums[i]`，值为 `i` ，依次判断 `nums[i]` 是否已经在字典中，如果是，则输出结果，即和为目标值的两个数。否则把 `target-nums[i]` 的值存入字典。

```python
class Solution:
    def twoSum(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: List[int]
        """
        d = {}
        for i in range(len(nums)):
            x = target - nums[i]
            if nums[i] in d:  # 判断是否已经在字典中
                return d[nums[i]], i  # 输出结果
            else:
                d[x] = i  # 存入字典
```







