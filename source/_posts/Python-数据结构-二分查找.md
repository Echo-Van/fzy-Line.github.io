---
title: Python 数据结构-二分查找
tags:
  - Python
categories: 
  - Algorithm
  - Data structure
abbrlink: 63506
date: 2019-03-09 10:22:15
---

<center>Python 二分查找学习。</center>
<!--more-->

#### 二分查找

　　二分查找又称折半查找，优点是比较次数少，查找速度快，平均性能好；其缺点是要求待查表为有序表，且插入删除困难。因此，折半查找方法适用于不经常变动而查找频繁的有序列表。首先，假设表中元素是按升序排列，将表中间位置记录的关键字与查找关键字比较，如果两者相等，则查找成功；否则利用中间位置记录将表分成前、后两个子表，如果中间位置记录的关键字大于查找关键字，则进一步查找前一子表，否则进一步查找后一子表。重复以上过程，直到找到满足条件的记录，使查找成功，或直到子表不存在为止，此时查找不成功。如图所示：

![16-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/2/16-1.png)

　　由上述描述可知，使用二分查找有两个前提条件：

- 待查找的列表必须有序（通常是从小到大的顺序）。
- 必须使用线性表的顺序存储结构来存储数据（底层用数组实现的）。

　　二分查找的时间复杂度是 `O(logn)`，远远好于顺序查找的 `O(n)` 。

#### 代码实现

##### 递归实现

```python
def binary_search(nums, target):
    length = len(nums)
    if length < 1:
        return False
    mid = length // 2
    if nums[mid] > target:
        return binary_search(nums[0:mid], target)
    elif nums[mid] < target:
        return binary_search(nums[mid+1:], target)
    else:
        return True
```

##### 非递归实现

```python
def binary_search(nums, target):
    left = 0
    right = len(nums)-1
    while left < right:
        mid = left+right // 2
        if nums[mid] > target:
            right = mid - 1
        elif nums[mid] < target:
            left = mid + 1
        else:
            return True
```