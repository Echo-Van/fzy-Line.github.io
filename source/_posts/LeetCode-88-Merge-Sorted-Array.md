---
title: LeetCode 88. Merge Sorted Array
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 48298
date: 2018-12-24 20:35:59
---

<center>LeetCode 88. Merge Sorted Array 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Given two sorted integer arrays *nums1* and *nums2*, merge *nums2* into *nums1* as one sorted array.

**Note:**

- The number of elements initialized in *nums1* and *nums2* are *m* and *n* respectively.
- You may assume that *nums1* has enough space (size that is greater or equal to *m* + *n*) to hold additional elements from *nums2*.
- **中文：** 

给定两个有序整数数组 *nums1* 和 *nums2*，将 *nums2* 合并到 *nums1* 中*，*使得 *num1* 成为一个有序数组。

**说明:**

- 初始化 *nums1* 和 *nums2* 的元素数量分别为 *m* 和 *n*。
- 你可以假设 *nums1* 有足够的空间（空间大小大于或等于 *m + n*）来保存 *nums2* 中的元素。

##### 示例

```
输入:
nums1 = [1,2,3,0,0,0], m = 3
nums2 = [2,5,6],       n = 3

输出: [1,2,2,3,5,6]
```

##### 题解

- **题解 1**

　　思路很简单，先合并两个数组，再重新排序。注意，此题不需要返回。

```python
class Solution:
    def merge(self, nums1, m, nums2, n):
        """
        :type nums1: List[int]
        :type m: int
        :type nums2: List[int]
        :type n: int
        :rtype: void Do not return anything, modify nums1 in-place instead.
        """
        nums1[m:m + n] = nums2[:n]  # 将 nums2 中的数复制到 nums1 的后面
        nums1.sort()  # 重新排序
```

- **题解 2** 

　　因为 nums1 的右端留有空位，而且两个数组都是排好序的，因此我们只要用两个指针，从两个数组的右端开始进行比较，得到较大的放到从 nums1 右边开始填充。最后如果 nums1 中已有的数都已经移动完成，而 nums2 中还有剩余，则直接将 nums2 的数复制到 nums1 的前面即可。

```python
class Solution:
    def merge(self, nums1, m, nums2, n):
        """
        :type nums1: List[int]
        :type m: int
        :type nums2: List[int]
        :type n: int
        :rtype: void Do not return anything, modify nums1 in-place instead.
        """
        i, j = m - 1, n - 1  # 从右边开始比较
        while i >= 0 and j >= 0:  # 直到最左边
            if nums1[i] > nums2[j]:  # 比较
                nums1[i + j + 1] = nums1[i]  # 填充预留的位置
                i -= 1
            else:
                nums1[i + j + 1] = nums2[j]  # 填充预留的位置
                j -= 1
        nums1[:j + 1] = nums2[:j + 1]  # 复制 nums2 中剩余的数
```

