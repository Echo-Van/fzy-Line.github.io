---
title: LeetCode 189. Rotate Array
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 44647
date: 2019-01-02 09:44:38
---

<center>LeetCode 189. Rotate Array 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Given an array, rotate the array to the right by *k* steps, where *k* is non-negative.

- **中文：** 

给定一个数组，将数组中的元素向右移动 *k* 个位置，其中 *k* 是非负数。

**说明:**

- 尽可能想出更多的解决方案，至少有三种不同的方法可以解决这个问题。
- 要求使用空间复杂度为 O(1) 的原地算法。

##### 示例

**示例 1:**

```
输入: [1,2,3,4,5,6,7] 和 k = 3
输出: [5,6,7,1,2,3,4]
解释:
向右旋转 1 步: [7,1,2,3,4,5,6]
向右旋转 2 步: [6,7,1,2,3,4,5]
向右旋转 3 步: [5,6,7,1,2,3,4]
```

**示例 2:**

```
输入: [-1,-100,3,99] 和 k = 2
输出: [3,99,-1,-100]
解释: 
向右旋转 1 步: [99,-1,-100,3]
向右旋转 2 步: [3,99,-1,-100]
```

##### 题解

- **题解 1**

　　思路很简单，每次弹出最后一个元素，再插入到列表索引为 0 的位置即可。但是，这种方法非常耗时。

```python
class Solution:
    def rotate(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: void Do not return anything, modify nums in-place instead.
        """
        for i in range(k):
            n = nums.pop()  # 弹出
            nums.insert(0, n)  # 插入
```

- **题解 2**

　　巧用 `reversed()` 反转函数，先将整个列表反转，然后再对前 k 个反转，再对 k+1 到列表末尾的反转。以列表 `[1, 2, 3, 4, 5, 6, 7]` 为例，向右移 k=3 个位置，先将整个列表反转得到 `[7, 6, 5, 4, 3, 2, 1]` ，再对前 3 个反转得到 `[5, 6, 7, 4, 3, 2, 1]`，最后对第 4 到 7 个元素进行反转得到 `[5, 6, 7, 1, 2, 3, 4]` 。但是，这里需要注意，k 可能会超过列表的长度，我们可以发现，当列表长度为 7 时， `k = 3` 和 `k = 10`，得到的结果是一样的，因为当 `k = 10` 时只是将列表所有数都移动了一遍，然后再移动 `k = 3` 次。所以，我们通过 `k=k%len(nums)` 来处理这种情况。

```python
class Solution:
    def rotate(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: void Do not return anything, modify nums in-place instead.
        """
        l = len(nums)
        k = k % l  # 处理 k 超过列表长度的情况 
        nums.reverse()  # 列表反转
        nums[:k] = reversed(nums[:k])  # 列表前 k 个元素反转
        nums[k:l] = reversed(nums[k:l])  # 列表 第 k+1 个开始到列表末尾的元素反转
```

