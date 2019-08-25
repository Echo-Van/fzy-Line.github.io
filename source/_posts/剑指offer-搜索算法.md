---
title: 剑指offer-搜索算法
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 49868
date: 2019-07-25 22:08:43
---

<center>秋招，来了！</center>

<!--more-->

#### 二维数组中的查找

##### 题目描述

　　在一个二维数组中（每个一维数组的长度相同），每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。请完成一个函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。

##### 题解 1

　　遍历二维数组，查找是否有与目标值相等的数。但是，这样的方法没有利用题目给出的特性：每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。

```python
# -*- coding:utf-8 -*-
class Solution:
    # array 二维列表
    def Find(self, target, array):
        for i in range(len(array)):
            for j in range(len(array[0])):
                if target == array[i][j]:
                    return True
        return False
```

##### 题解 2

　　从二维数组右上角的元素开始比较，如果目标值大于该值，则查找下一行，否则，就在这一行查找，依次左移，进行比较。这样可以更快地定位到目标元素可能出现的行/列。

```python
# -*- coding:utf-8 -*-
class Solution:
    # array 二维列表
    def Find(self, target, array):
        i = 0
        j = len(array[0])-1
        while i < len(array) and j >= 0:
            if target < array[i][j]:
                j -= 1
            elif target > array[i][j]:
                i += 1
            else:
                return True
        return False
```

#### 旋转数组的最小数字

##### 题目描述

　　把一个数组最开始的若干个元素搬到数组的末尾，我们称之为数组的旋转。输入一个非递减排序的数组的一个旋转，输出旋转数组的最小元素。例如数组{3,4,5,1,2}为{1,2,3,4,5}的一个旋转，该数组的最小值为1。NOTE：给出的所有元素都大于0，若数组大小为0，请返回0。

##### 题解

　　对数据排序后，取第一个元素。

```python
# -*- coding:utf-8 -*-
class Solution:
    def minNumberInRotateArray(self, rotateArray):
        if len(rotateArray) == 0:
            return 0
        rotateArray.sort()
        return rotateArray[0]
```

##### 题解 2

　　遍历数组，找到最小的元素。

```python
# -*- coding:utf-8 -*-
class Solution:
    def minNumberInRotateArray(self, rotateArray):
        length = len(rotateArray)
        if length == 0:
            return 0
        result = rotateArray[0]
        for i in range(length):
            if rotateArray[i]<result:
                result = rotateArray[i]
        return result
```

##### 题解 3

　　利用二分查找。旋转数组可以根据原数组第一个元素（即最小数字）分为两个不减的数组。利用该性质可以使用两个指针来实现二分，初始化时将第一个指针指向数组第1个元素，第二个指针指向数组最后一个元素，然后取两个指针中间的指针（取整）。如果数值大于第二个指针的数字，则最小的元素在后半部分，将第一个指针赋为中间指针后的一个元素；如果数值小于等于第二个指针的数字，则最小的元素在前半部分，将第二个指针赋为中间指针。直到第一个指针和第二个指针相遇，即为最小数字。

```python
# -*- coding:utf-8 -*-
class Solution:
    def minNumberInRotateArray(self, rotateArray):
        length = len(rotateArray)
        if length == 0:
            return 0
        low = 0
        high = length-1
        while low<high:
            mid = low + (high - low)//2
            if rotateArray[mid]>rotateArray[high]:
                low = mid+1
            elif rotateArray[mid]<=rotateArray[high]:
                high = mid
        return rotateArray[low]
```

#### 数字在排序数组中出现的次数

##### 题目描述

　　统计一个数字在排序数组中出现的次数。

##### 题解 1

　　利用 Python 列表的 count 方法来进行统计。

```python
# -*- coding:utf-8 -*-
class Solution:
    def GetNumberOfK(self, data, k):
        return data.count(k)
```

##### 题解 2

　　借助二分查找，先找到 k 出现的位置，然后分别向前向后找到 k 第一次在数组中出现的位置和最后一次在数组中出现的位置，然后即可得到出现的次数。

```python
# -*- coding:utf-8 -*-
class Solution:
    def GetNumberOfK(self, data, k):
        if not data:
            return 0
        low = 0
        high = len(data) - 1
        cnt = 0
        end = high
        while low <= high:
            mid = (low + high) / 2
            if data[mid] == k:
                # 向前查找
                while mid >= 0 and data[mid] == k:
                    mid -= 1
                mid += 1

                # 向后查找
                while mid <= end and data[mid] == k:
                    mid += 1
                    cnt += 1
                return cnt
            elif data[mid] < k:
                low = mid + 1
            else:
                high = mid - 1
        return cnt
```