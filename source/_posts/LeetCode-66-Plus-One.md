---
title: LeetCode 66. Plus One
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 23357
date: 2018-12-02 19:38:11
---

<center>LeetCode 66. Plus One</center>

<!--more-->

##### 题目描述

- **英文：**

Given a **non-empty** array of digits representing a non-negative integer, plus one to the integer.

The digits are stored such that the most significant digit is at the head of the list, and each element in the array contain a single digit.

You may assume the integer does not contain any leading zero, except the number 0 itself.

- **中文：** 

给定一个由**整数**组成的**非空**数组所表示的非负整数，在该数的基础上加一。

最高位数字存放在数组的首位， 数组中每个元素只存储一个数字。

你可以假设除了整数 0 之外，这个整数不会以零开头。

##### 示例

- **示例 1**

```
输入: [1,2,3]
输出: [1,2,4]
解释: 输入数组表示数字 123。
```

- **示例 2**

```
输入: [4,3,2,1]
输出: [4,3,2,2]
解释: 输入数组表示数字 4321。
```

##### 题解

- **题解 1**

　　直接对列表最后 1 个数进行加1的操作，如果不等于10，即无需进位，则直接返回加 1 后的数组，否则，处理进位。从数组的尾部开始，依次往前处理进位的情况。如果数组最前面的数依然需要进位，则在数组前增加一个 1。

```python
class Solution:
    def plusOne(self, digits):
        """
        :type digits: List[int]
        :rtype: List[int]
        """
        digits[len(digits) - 1] += 1  # 最后 1 位加 1
        if digits[len(digits) - 1] < 10:  # 如果没有进位则直接返回数组
            return digits
        flag = 0
        for i in range(len(digits) - 1, -1, -1):  # 处理有进位的情况
            if flag == 1:  # 进位处理
                digits[i] += 1  # 进 1 位
                flag = 0  # 进位标志清除
            if digits[i] == 10:  # 需要进位
                digits[i] = 0  # 该位清空，先前进 1 位
                flag = 1  # 标志进位
        if flag == 1:  # 如果最前面的数也要进位，则在数组前增加1
            return [1] + digits
        else:
            return digits
```

- **题解 2**

　　考察的就是加法进位的问题，把数组最后 1 个数加 1 也看作是进位。从后向前依次处理进位的情况，然后记录到结果列表中。如果数组最前面的数依然需要进位，则把进位值插入到数组最前面。

```python
class Solution:
    def plusOne(self, digits):
        """
        :type digits: List[int]
        :rtype: List[int]
        """
        res = []  # 结果列表
        sum = 0
        one = 1  # 进位值
        for i in range(len(digits) - 1, -1, -1):  # 从后向前处理
            sum = one + digits[i]  # 进位值加上当前值
            one = int(sum / 10)  # 是否要向前进位
            res.insert(0, int(sum) % 10)  # 记录到结果列表
        if one > 0:  # 如果最后还有进位，插入到列表最前面
            res.insert(0, one)
        return res
```