---
title: LeetCode 217. Contains Duplicate
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 31656
date: 2019-01-06 19:50:55
---

<center>LeetCode 217. Contains Duplicate 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Given an array of integers, find if the array contains any duplicates.

Your function should return true if any value appears at least twice in the array, and it should return false if every element is distinct.

- **中文：** 

给定一个整数数组，判断是否存在重复元素。

如果任何值在数组中出现至少两次，函数返回 true。如果数组中每个元素都不相同，则返回 false。

##### 示例

- **示例 1:**

```
输入: [1,2,3,1]
输出: true
```

- **示例 2:**

```
输入: [1,2,3,4]
输出: false
```

- **示例 3:**

```
输入: [1,1,1,3,3,4,3,2,4,2]
输出: true
```

##### 题解

- **题解 1**

　　依据集合中元素不重复的特性，使用 set() 方法得到不重复元素的集合，然后判断列表长度是否等于集合的长度，如果是则表示列表中没有重复的元素，返回 False，否则，有，返回 True。

```python
class Solution:
    def containsDuplicate(self, nums):
        """
        :type nums: List[int]
        :rtype: bool
        """
        if len(nums) == len(set(nums)):
            return False
        else:
            return True
```

- **题解 2**

　　先对列表进行排序，然后遍历列表，依次比较每个元素是否等于其后一个元素，如果等于，则表示列表中有重复的元素，返回 True，否则，返回 False。

```python
class Solution:
    def containsDuplicate(self, nums):
        """
        :type nums: List[int]
        :rtype: bool
        """
        length = len(nums)
        if length == 0:
            return False
        nums.sort()
        for i in range(length-1):
            if nums[i] == nums[i+1]:
                return True
        return False
```

