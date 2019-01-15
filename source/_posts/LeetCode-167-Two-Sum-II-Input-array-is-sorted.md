---
title: LeetCode 167. Two Sum II - Input array is sorted
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 16073
date: 2018-12-25 23:21:05
---

<center>LeetCode 167. Two Sum II - Input array is sorted 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Given an array of integers that is already **sorted in ascending order**, find two numbers such that they add up to a specific target number.

The function twoSum should return indices of the two numbers such that they add up to the target, where index1 must be less than index2.

**Note:**

- Your returned answers (both index1 and index2) are not zero-based.
- You may assume that each input would have *exactly* one solution and you may not use the *same* element twice.
- **中文：** 

给定一个已按照**升序排列** 的有序数组，找到两个数使得它们相加之和等于目标数。

函数应该返回这两个下标值 index1 和 index2，其中 index1 必须小于 index2*。*

**说明:**

- 返回的下标值（index1 和 index2）不是从零开始的。
- 你可以假设每个输入只对应唯一的答案，而且你不可以重复使用相同的元素。

##### 示例

```
输入: numbers = [2, 7, 11, 15], target = 9
输出: [1,2]
解释: 2 与 7 之和等于目标数 9 。因此 index1 = 1, index2 = 2 。
```

##### 题解

- **题解 1**

　　遍历数组，然后使用字典，键为 `target-numbers[i]`，值为 `i` ，依次判断 `numbers[i]` 是否已经在字典中，如果是，则输出结果，即和为目标值的两个数。否则把 `target-numbers[i]` 的值存入字典。

```python
class Solution:
    def twoSum(self, numbers, target):
        """
        :type numbers: List[int]
        :type target: int
        :rtype: List[int]
        """
        d = {}
        for i in range(len(numbers)):
            x = target - numbers[i]  # 判断是否已经在字典中
            if numbers[i] in d:
                return d[numbers[i]] + 1, i + 1  # 输出结果
            else:
                d[x] = i  # 存入字典
```

- **题解 2**

　　双指针思想。由于是排序数组，使用 i，j 两个游标从两端开始处理，每次计算两数之和，如果大于目标值，右边的游标 j 向左移，否则，左边的游标 i 向右移，逐步逼近目标值。直到等于目标值，再输出。注意，输出时要加 1，因为题目要求返回的下标值不是从零开始的。

```python
class Solution:
    def twoSum(self, numbers, target):
        """
        :type numbers: List[int]
        :type target: int
        :rtype: List[int]
        """
        i = 0
        j = len(numbers) - 1
        while i < j:
            tmp = numbers[i] + numbers[j]  # 当前游标所指元素之和
            if tmp == target:
                return i + 1, j + 1  # 输出结果
            elif tmp < target:  # 小于目标值
                i += 1  # 左边的游标右移
            else:  # 大于目标值
                j -= 1  # 右边的游标左移
```

