---
title: LeetCode 169. Majority Element
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 5805
date: 2018-12-23 23:21:32
---

<center>LeetCode 169. Majority Element 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Given an array of size *n*, find the majority element. The majority element is the element that appears **more than** `⌊ n/2 ⌋`times.

You may assume that the array is non-empty and the majority element always exist in the array.

- **中文：** 

给定一个大小为 *n* 的数组，找到其中的众数。众数是指在数组中出现次数**大于** `⌊ n/2 ⌋` 的元素。

你可以假设数组是非空的，并且给定的数组总是存在众数。

##### 示例

- **示例 1:**

```
输入: [3,2,3]
输出: 3
```

- **示例 2:**

```
输入: [2,2,1,1,1,2,2]
输出: 2
```

##### 题解

- **题解 1**

　　使用 `set()` 方法得到列表中不重复元素的元组，然后再遍历这个元组，使用列表的 `count()` 方法依次统计元组中元素在列表中出现的次数，然后查看出现是否大于 `⌊ n/2 ⌋` ，如果是则输出该元素即可，因为在任何数组中，出现次数大于该数组长度一半的值只能有一个。

```python
class Solution:
    def majorityElement(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        s = set(nums)  # 不重复元素
        for i in s:
            con = nums.count(i)  # 统计出现次数
            if con > len(nums) // 2:  # //为整数除法，返回不大于结果的一个最大的整数
                return i  # 返回结果
```

- **题解 2**

　　使用排序法，排序后，出现次数大于一半的肯定在中间。

```python
class Solution:
    def majorityElement(self, nums):
        nums.sort()
        return nums[len(nums)//2]	
```

- **题解 3**

　　使用摩尔投票法。摩尔投票法的基本思想很简单，在每一轮投票过程中，从数组中找出一对不同的元素，将其从数组中删除。这样不断的删除直到无法再进行投票，如果数组为空，则没有任何元素出现的次数超过该数组长度的一半。如果只存在一种元素，那么这个元素则可能为目标元素。

```python
class Solution:
    def majorityElement(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        count = 0
        res = 0
        for i in nums:	# 遍历数组
            if count == 0 or i == res:
                res = i
                count += 1
            else:
                count -= 1
        return res
```

