---
title: LeetCode 80. Remove Duplicates from Sorted Array II
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 58342
date: 2019-01-14 11:41:26
---

<center>LeetCode 80. Remove Duplicates from Sorted Array II 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Given a sorted array *nums*, remove the duplicates [**in-place**](https://en.wikipedia.org/wiki/In-place_algorithm) such that duplicates appeared at most *twice* and return the new length.

Do not allocate extra space for another array, you must do this by **modifying the input array in-place** with O(1) extra memory.

- **中文：** 

给定一个排序数组，你需要在**原地**删除重复出现的元素，使得每个元素最多出现两次，返回移除后数组的新长度。

不要使用额外的数组空间，你必须在**原地修改输入数组**并在使用 O(1) 额外空间的条件下完成。

##### 示例

- **示例 1:**

```
给定 nums = [1,1,1,2,2,3],

函数应返回新长度 length = 5, 并且原数组的前五个元素被修改为 1, 1, 2, 2, 3 。

你不需要考虑数组中超出新长度后面的元素。
```

- **示例 2:**

```
给定 nums = [0,0,1,1,1,1,2,3,3],

函数应返回新长度 length = 7, 并且原数组的前五个元素被修改为 0, 0, 1, 1, 2, 3, 3 。

你不需要考虑数组中超出新长度后面的元素。
```

**说明:**

为什么返回数值是整数，但输出的答案是数组呢?

请注意，输入数组是以**“引用”**方式传递的，这意味着在函数里修改输入数组对于调用者是可见的。

你可以想象内部操作如下:

```
// nums 是以“引用”方式传递的。也就是说，不对实参做任何拷贝
int len = removeDuplicates(nums);

// 在函数里修改输入数组对于调用者是可见的。
// 根据你的函数返回的长度, 它会打印出数组中该长度范围内的所有元素。
for (int i = 0; i < len; i++) {
    print(nums[i]);
}
```

##### 题解

- **题解 1**

　　双指针，指向同一个数组，但是指针 i 是数组的索引，而 j 是结果的索引，检查 i 指向的元素是否与 j 指向的元素相同，如果相同则计数。如果i 指向的元素是否与 j 指向的元素不同，或者相等时的计数小于2，则 j 右移，并将 i 指向的元素复制到 j 指向的位置。如果计数大于等于2，则不做处理。

```python
class Solution:
    def removeDuplicates(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        if len(nums) == 0:
            return 0
        j = 0
        count = 0
        for i in range(1, len(nums)):
            if nums[i] == nums[j]:
                count += 1
                if count < 2:
                    j += 1
                    nums[j] = nums[i]
            else:
                j += 1
                nums[j] = nums[i]
                count = 0
        return j+1
```

　　**题解 2**

　　还是采用双指针，i 指向第 1 个元素，为满足题目每个元素最多出现两次的要求，j 指向 i 之后的第 2 个元素，每次判断 i 和 j 所指元素是否相等，如果相等，则删除 j 指向的元素，否则，i 和 j 都向右移动，直到 j 到达 列表 nums 的末尾即可。

```python
class Solution:
    def removeDuplicates(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        i = 0
        j = 2
        while j < len(nums):
            if nums[i] == nums[j]:
                del nums[j]  # 删除出现次数超过 2 次的元素
            else:  # 向右扫描
                i += 1
                j += 1
        return len(nums)
```

　　另一种写法：

```python
class Solution:
    def removeDuplicates(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        j = 0
        for i in nums:	# 遍历数组，并向右扫描
            if j < 2 or i != nums[j - 2]:	# 判断出现次数是否小于 2 次
                nums[j] = i
                j += 1

        return j
```





