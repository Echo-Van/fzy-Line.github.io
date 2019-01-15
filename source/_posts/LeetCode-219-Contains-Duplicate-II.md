---
title: LeetCode 219. Contains Duplicate II
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 59768
date: 2019-01-07 19:51:58
---

<center>LeetCode 219. Contains Duplicate II 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Given an array of integers and an integer *k*, find out whether there are two distinct indices *i* and *j* in the array such that **nums[i] = nums[j]** and the **absolute** difference between *i* and *j* is at most *k*.

- **中文：** 

给定一个整数数组和一个整数 *k*，判断数组中是否存在两个不同的索引 *i* 和 *j*，使得 **nums [i] = nums [j]**，并且 *i* 和 *j* 的差的绝对值最大为 *k*。

##### 示例

- **示例 1:**

```
输入: nums = [1,2,3,1], k = 3
输出: true
```

- **示例 2:**

```
输入: nums = [1,0,1,1], k = 1
输出: true
```

- **示例 3:**

```
输入: nums = [1,2,3,1,2,3], k = 2
输出: false
```

##### 题解

- **题解 1**

　　使用字典来进行处理。

```python
class Solution:
    def containsNearbyDuplicate(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: bool
        """
        length = len(nums)
        if length <= 1:
            return False
        dic = {}
        for i in range(length):
            if nums[i] in dic:
                if i-dic[nums[i]] <= k:
                    return True
            dic[nums[i]] = i
        return False
```

　　可以使用 217. Contains Duplicate 题中的方法稍作改进，使用 set() 方法得到不重复元素的集合，然后判断列表长度是否等于集合的长度，如果是则表示列表中没有重复的元素，直接返回 False。否则，进行上面的操作来做进一步的判断。

```python
class Solution:
    def containsNearbyDuplicate(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: bool
        """
        length = len(nums)
        if length == len(set(nums)):	# 改进的地方
            return False
        if length <= 1:
            return False
        dic = {}
        for i in range(length):
            if nums[i] in dic:
                if i-dic[nums[i]] <= k:
                    return True
            dic[nums[i]] = i
        return False
```

- **题解 2**

　　使用集合，集合中只存放 k 个元素，即满足题目要求的两个索引 *i* 和 *j* 的差的绝对值最大为。遍历数组，每次判断元素是否在集合中，如果在，则表示有满足条件的重复元素，返回 True，并且每次都将元素加入到集合中，判断集合中元素个数是否大于 k，如果大于，则将第一个元素移除，保证集合中元素的索引与当前元素的索引相差最大为 k，即只考虑当前元素的前面 k 个元素。

```python
class Solution:
    def containsNearbyDuplicate(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: bool
        """
        record = set()
        for i in range(len(nums)):
            if nums[i] in record:  # 有满足条件的重复元素
                return True
            record.add(nums[i])  # 加入到集合
            if len(record) == k + 1:  # 保证集合中只有 k 个元素
                record.remove(nums[i - k])  # 移除最前面的元素
        return False
```

