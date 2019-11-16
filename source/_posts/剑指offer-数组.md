---
title: 剑指offer-数组
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 37799
date: 2019-09-01 16:31:52
---

<center>秋招，来了！</center>
<!--more-->

#### 数组中出现次数超过一半的数字

##### 题目描述

　　数组中有一个数字出现的次数超过数组长度的一半，请找出这个数字。例如输入一个长度为9的数组{1,2,3,2,2,2,5,4,2}。由于数字2在数组中出现了5次，超过数组长度的一半，因此输出2。如果不存在则输出0。

##### 题解 

　　参考以前写的博客：[找出数组中出现次数超过一半的数](http://fanzhenyu.cn/2019/04/27/找出数组中出现次数超过一半的数/)

#### 数组中重复的数字

##### 题目描述

　　在一个长度为n的数组里的所有数字都在0到n-1的范围内。 数组中某些数字是重复的，但不知道有几个数字是重复的。也不知道每个数字重复几次。请找出数组中任意一个重复的数字。 例如，如果输入长度为7的数组{2,3,1,0,2,5,3}，那么对应的输出是第一个重复的数字2。

##### 题解 1

　　遍历数组，使用 Python 的关键字 in 判断该元素是否在其之后还出现过，如果是则直接返回。

```python
# -*- coding:utf-8 -*-
class Solution:
    # 这里要特别注意~找到任意重复的一个值并赋值到duplication[0]
    # 函数返回True/False
    def duplicate(self, numbers, duplication):
        length = len(numbers)
        if numbers is None or length==0:
            return False
        for i in range(length):
            if numbers[i] in numbers[i+1:]:
                duplication[0] = numbers[i]
                return True
        return False
```

##### 题解 2

　　用布尔列表表示对应的值是否已经出现过 ，如果是则返回该值。

```python
# -*- coding:utf-8 -*-
class Solution:
    # 这里要特别注意~找到任意重复的一个值并赋值到duplication[0]
    # 函数返回True/False
    def duplicate(self, numbers, duplication):
        length = len(numbers)
        if numbers is None or length == 0:
            return False

        bool_list = [False] * length
        for i in range(length):
            if bool_list[numbers[i]]:  # 重复出现
                duplication[0] = numbers[i]
                return True
            bool_list[numbers[i]] = True  # 标记为已经出现

        return False
```

##### 题解 3

　　由于数组长度为 n，且所有数字都在 0 到 n-1 的范围内，因此考虑利用数组下标。从下标 0 开始，对每个元素，若 `numbers[i]` 不等于 `i`，则交换 `numbers[i]` 和 `numbers[numbers[i]]`，直至 `i` 和 `numbers[i]` 相等继续循环，或 `numbers[i]` 和 `numbers[numbers[i]]` 相等即遇到重复元素返回 True。

```python
# -*- coding:utf-8 -*-
class Solution:
    # 这里要特别注意~找到任意重复的一个值并赋值到duplication[0]
    # 函数返回True/False
    def duplicate(self, numbers, duplication):
        # write code here
        length = len(numbers)
        if numbers is None or length == 0:
            return False
        for i in range(length):
            while i != numbers[i]:
                if numbers[i] == numbers[numbers[i]]:
                    duplication[0] = numbers[i]
                    return True
                tmp = numbers[numbers[i]]
                numbers[numbers[i]] = numbers[i]
                numbers[i] = tmp
        return False
```

#### 调整数组顺序使奇数位于偶数前面

##### 题目描述

　　输入一个整数数组，实现一个函数来调整该数组中数字的顺序，使得所有的奇数位于数组的前半部分，所有的偶数位于数组的后半部分，并保证奇数和奇数，偶数和偶数之间的相对位置不变。

##### 题解 1

　　一次遍历，判断每个数的奇偶性，然后使用两个列表来存储奇数和偶数，最后将两个列表合并。

```python
# -*- coding:utf-8 -*-
class Solution:
    def reOrderArray(self, array):
        odd = []
        even = []
        for i in array:
            if i % 2 == 0:
                even.append(i)
            else:
                odd.append(i)
        odd.extend(even)
        return odd
```

##### 题解 2

　　考虑用双指针。第一个指针初始化时指向数组的第一个数字，它只向后移动；第二个指针初始化时指向数组的最后一个数字，它指向前移动。如果第一个指针的数字是偶数，并且第二个指针指向的数字是奇数，就交换两个数字。

```python
# -*- coding:utf-8 -*-
class Solution:
    def reOrderArray(self, array):
        left = 0
        right = len(array) - 1
        while left <= right:
            while array[left] % 2 != 0:
                left += 1
            while array[right] % 2 != 1:
                right -= 1
            if left < right:
                array[left], array[right] = array[right], array[left]
        return array
```

　　**注意，题目要求保证奇数和奇数，偶数和偶数之间的相对位置不变。**

　　同样采用双指针，第一个指针 left 从左向右遍历，找到第一个偶数，第二个指针 right 从 left+1 开始向后找，直到找到第一个奇数。然后，将 [left,…,right-1] 的元素整体后移一位，最后将找到的奇数放入 left 的位置，并且第一个指针继续向后进行下一次查找。

```python
# -*- coding:utf-8 -*-
class Solution:
    def reOrderArray(self, array):
        left = 0
        length = len(array)
        while left < length:
            while left < length and array[left] % 2 != 0:
                left += 1
            right = left + 1
            while right < length and array[right] % 2 != 1:
                right += 1
            if right < length:
                tmp = array[right]
                for i in range(right - 1, left - 1, -1):
                    array[i + 1] = array[i]
                array[left] = tmp
            else:
                break

        return array
```