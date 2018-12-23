---
title: LeetCode 26. Remove Duplicates from Sorted Array
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 53156
date: 2018-12-05 10:35:11
---

<center>LeetCode 26. Remove Duplicates from Sorted Array 题解</center>

<!--more-->

##### 题目描述

- 英文

Given a sorted array *nums*, remove the duplicates [**in-place**](https://en.wikipedia.org/wiki/In-place_algorithm) such that each element appear only *once* and return the new length.

Do not allocate extra space for another array, you must do this by **modifying the input array in-place** with O(1) extra memory.

- 中文

给定一个排序数组，你需要在**原地**删除重复出现的元素，使得每个元素只出现一次，返回移除后数组的新长度。

不要使用额外的数组空间，你必须在**原地修改输入数组**并在使用 O(1) 额外空间的条件下完成。

##### 示例

- **示例 1:**

```
给定数组 nums = [1,1,2], 

函数应该返回新的长度 2, 并且原数组 nums 的前两个元素被修改为 1, 2。 

你不需要考虑数组中超出新长度后面的元素。
```

- **示例 2:**

```
给定 nums = [0,0,1,1,1,2,2,3,3,4],

函数应该返回新的长度 5, 并且原数组 nums 的前五个元素被修改为 0, 1, 2, 3, 4。

你不需要考虑数组中超出新长度后面的元素。
```

##### 题解

- **题解 1：**

　　类似于第27题. Remove Element，我们使用游标 i 从下标为 1 的元素开始遍历，另外，使用游标 j 来记录已经结果数组的元素。依次检查 i 所指的元素是否与前一个元素相等，如果是则检查下一个元素，否则，将其记录到 j 所指的位置，然后 j 往后移一位准备记录下一个。重复上述过程直到遍历结束。 

```python
class Solution:
    def removeDuplicates(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        length = len(nums)
        if length == 0:
            return 0
        else:
            j = 0
            for i in range(1, length):  # 遍历数组
                if nums[i] != nums[i - 1]:  # 不相等时
                    j += 1  # 记录游标后移
                    nums[j] = nums[i]  # 记录
            return j + 1  # 返回结果
```

- **题解 2**

　　使用游标 i 遍历数组，然后使用一个游标 j，当 i 向后遍历数组时，如果遇到 nums[i] 与 nums[j] 不同，则将 nums[i] 和 nums[j+1] 交换，同时 游标 j 向右移动一个位置，然后 i 继续向后遍历，重复上述过程直到遍历结束。 

```python
class Solution:
    def removeDuplicates(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        length = len(nums)
        if length == 0:
            return 0
        else:
            j = 0
            for i in range(0, length):
                if nums[i] != nums[j]:
                    nums[i], nums[j+1] = nums[j+1], nums[i]
                    j += 1
            return j+1
```



