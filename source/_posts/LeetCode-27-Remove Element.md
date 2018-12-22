---
title: LeetCode 27. Remove Element
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 60385
date: 2018-12-03 19:34:47
---

<center>LeetCode 27. Remove Element 题解</center>

<!--more-->

##### 题目描述

- **英文：**

Given an array *nums* and a value *val*, remove all instances of that value [**in-place**](https://en.wikipedia.org/wiki/In-place_algorithm) and return the new length.

Do not allocate extra space for another array, you must do this by **modifying the input array in-place** with O(1) extra memory.

The order of elements can be changed. It doesn't matter what you leave beyond the new length.

- **中文：**

给定一个数组 *nums* 和一个值 *val*，你需要**原地**移除所有数值等于 *val* 的元素，返回移除后数组的新长度。

不要使用额外的数组空间，你必须在**原地修改输入数组**并在使用 O(1) 额外空间的条件下完成。

元素的顺序可以改变。你不需要考虑数组中超出新长度后面的元素。

##### 示例

- **示例 1:**

```
给定 nums = [3,2,2,3], val = 3,

函数应该返回新的长度 2, 并且 nums 中的前两个元素均为 2。

你不需要考虑数组中超出新长度后面的元素。
```

- **示例 2:**

```
给定 nums = [0,1,2,2,3,0,4,2], val = 2,

函数应该返回新的长度 5, 并且 nums 中的前五个元素为 0, 1, 3, 0, 4。

注意这五个元素可为任意顺序。

你不需要考虑数组中超出新长度后面的元素。
```

##### 题解

- **题解 1**

　　使用两个游标 i 和 j 来遍历数组，如果 第 i 个元素的值等于 val，则使用 j 记录位置，同时递增 i，直到下一个不等于 val 的元素出现，将此时 i 对应的值复制到 j 的位置上，再增加 j ，重复上述过程直到遍历结束。最后，j 就是新数组的长度。 

```python
class Solution:
    def removeElement(self, nums, val):
        """
        :type nums: List[int]
        :type val: int
        :rtype: int
        """
        j = 0
        for i in range(len(nums)):  # 遍历数组
            if nums[i] != val:  # 不等于时才记录
                nums[j] = nums[i]  # 复制不等于 val 的值
                j += 1  # 新数组的长度
        return j
```

- **题解 2**

　　使用列表的 `pop()` 方法：

```python
class Solution:
    def removeElement(self, nums, val):
        """
        :type nums: List[int]
        :type val: int
        :rtype: int
        """
        while val in nums:  # 如果列表中还有目标元素
            nums.pop(nums.index(val))  # 移除该元素
        return len(nums)
```

- **题解 3**

　　使用 `del` 语句：

```python
class Solution:
    def removeElement(self, nums, val):
        """
        :type nums: List[int]
        :type val: int
        :rtype: int
        """
        while val in nums:  # 如果列表中还有目标元素
            del nums[nums.index(val)]  # 移除该元素
        return len(nums)
```

- **题解 4**

　　使用列表的 `remove()` 方法（此方法效率最高）：

```python
class Solution:
    def removeElement(self, nums, val):
        """
        :type nums: List[int]
        :type val: int
        :rtype: int
        """
        while val in nums:  # 如果列表中还有目标元素
            nums.remove(val)  # 移除该元素
        return len(nums)
```



