---
title: LeetCode 74. Search a 2D Matrix
tags:
  - LeetCode
  - Array
categories:
  - Algorithm
  - LeetCode
abbrlink: 64385
date: 2019-01-13 11:10:34
---

<center>LeetCode 74. Search a 2D Matrix 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Write an efficient algorithm that searches for a value in an *m* x *n* matrix. This matrix has the following properties:

- Integers in each row are sorted from left to right.
- The first integer of each row is greater than the last integer of the previous row.
- **中文：** 

编写一个高效的算法来判断 *m* x *n* 矩阵中，是否存在一个目标值。该矩阵具有如下特性：

- 每行中的整数从左到右按升序排列。
- 每行的第一个整数大于前一行的最后一个整数。

##### 示例

- **示例 1:**

```
输入:
matrix = [
  [1,   3,  5,  7],
  [10, 11, 16, 20],
  [23, 30, 34, 50]
]
target = 3
输出: true
```

- **示例 2:**

```
输入:
matrix = [
  [1,   3,  5,  7],
  [10, 11, 16, 20],
  [23, 30, 34, 50]
]
target = 13
输出: false
```

##### 题解

- **题解 1**

　　利用矩阵的如下特性：（1）每行中的整数从左到右按升序排列。（2）每行的第一个整数大于前一行的最后一个整数。我们从右上角开始扫描，比较元素与目标值，如果大于目标值，则向下扫描，如果小于则向左扫描，否则返回True。

```python
class Solution:
    def searchMatrix(self, matrix, target):
        """
        :type matrix: List[List[int]]
        :type target: int
        :rtype: bool
        """
        if len(matrix) == 0:
            return False
        elif len(matrix[0]) == 0:
            return False
        else:
            row = 0
            col = len(matrix[0])-1
            while row < len(matrix) and col >= 0:	# 扫描完毕条件
                if target > matrix[row][col]:	# 目标值大于当前元素
                    row += 1	# 向下移动
                elif target < matrix[row][col]:	# 目标值小于当前元素
                    col -= 1	# 向左移动
                else:
                    return True
            return False
```



- **题解 2**

　　使用二分法。先通过比较目标值与每行第一个数组定位目标值在在哪一行，然后锁定某一行后再对那一行进行二分查找。

```python
        class Solution:
            def searchMatrix(self, matrix, target):
                """
                :type matrix: List[List[int]]
                :type target: int
                :rtype: bool
                """
                row = len(matrix)
                if row == 0:
                    return False
                col = len(matrix[0])
                if col == 0:
                    return False
                else:
                    # 先定位大致在哪一行
                    row_index = row - 1
                    for i in range(row):
                        if target < matrix[i][0]:
                            row_index = i - 1
                            break
                    # 在这一行，再用二分法查找
                    left, right = 0, col - 1
                    while left <= right:
                        mid = int((left + right) / 2)
                        if matrix[row_index][mid] == target:
                            return True
                        elif matrix[row_index][mid] < target:
                            left = mid + 1  # 在右半部分
                        else:
                            right = mid - 1  # 在左半部分
                return False
```

