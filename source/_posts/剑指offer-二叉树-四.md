---
title: 剑指offer-二叉树(四)
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 35452
date: 2019-09-10 09:37:14
---

<center>秋招，来了！</center>

<!--more-->

#### 二叉搜索树的后序遍历序列

##### 题目描述

　　输入一个整数数组，判断该数组是不是某二叉搜索树的后序遍历的结果。如果是则输出Yes，否则输出No。假设输入的数组的任意两个数字都互不相同。

##### 题解

　　二叉搜索树：空树或者二叉树的所有结点比它的左子结点大，比它的右子结点小。在后序遍历得到的序列中，最后一个数字是树的根结点的值。数组中前面的数字可以分为两部分：第一部分是左子树结点的值，它们都比根结点的值小；第二部分是右子树结点的值，它们都比根结点的值大。

　　根据以上规律，采用递归实现，每次根据序列得到根节点，然后找到中间位置，判断中间位置的右边节点的值是否都大于根节点的值，如果是，则继续检查左边的子序列和右边的子序列。否则，不是后序遍历的结果。

```python
# -*- coding:utf-8 -*-
class Solution:
    def VerifySquenceOfBST(self, sequence):
        if not sequence:
            return False
        end = sequence[-1]
        length = len(sequence)
        i = 0
        while i < length - 1:  # 找到中间位置
            if sequence[i] > end:
                break
            i += 1
        mid = i
        for j in range(mid, length - 1):
            if sequence[j] < end:  # 如果右边的小于根节点，则不是后续遍历序列
                return False

        left = True
        if mid > 0:  # 再检查左边
            left = self.VerifySquenceOfBST(sequence[:mid])
        right = True
        if mid < length - 1:  # 再检查右边
            right = self.VerifySquenceOfBST(sequence[mid:-1])
        return left and right
```

#### 二叉树的下一个结点

##### 题目描述

　　给定一个二叉树和其中的一个结点，请找出中序遍历顺序的下一个结点并且返回。注意，树中的结点不仅包含左右子结点，同时包含指向父结点的指针。

##### 题解

　　分为以下几种情况：

- 如果一个节点有右子树，那么它的下一个结点就是它的右子树的最左子节点。
- 如果一个节点没有右子树
  - 如果节点是它父节点的左子节点，那么它的下一个节点就是它的父节点。
  - 如果节点是它父节点的右子节点，沿着指向父节点的指针一直向上遍历，直到找到一个是它父节点的左子节点的节点。如果这样的节点存在，那么这个节点的父节点就是我们要找的下一个节点。

```python
# -*- coding:utf-8 -*-
# class TreeLinkNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
#         self.next = None
class Solution:
    def GetNext(self, pNode):
        if pNode is None:
            return None
        if pNode.right:  # 有右子树
            pNode = pNode.right
            while pNode.left:
                pNode = pNode.left
            return pNode
        else:  # 没有右子树
            while pNode.next:
                if pNode.next.left == pNode:
                    return pNode.next
                pNode = pNode.next
```

#### 二叉搜索树的第k个结点

##### 题目描述

　　给定一棵二叉搜索树，请找出其中的第k小的结点。例如， （5，3，7，2，4，6，8）    中，按结点数值大小顺序第三小结点的值为4。

##### 题解 1

　　中序遍历整棵树，将节点存储在列表中，最后返回列表的第 k 个节点即可。但是，一定要注意边界范围：`k=0 和 k>len(lst)` 。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回对应节点TreeNode
    def KthNode(self, pRoot, k):
        # write code here

        def inOrder(root, order):  # 中序遍历
            if root is None:
                return
            inOrder(root.left, order)
            order.append(root)
            inOrder(root.right, order)

        if pRoot is None or k == 0:  # 注意k等于0的情况
            return None
        lst = []
        inOrder(pRoot, lst)
        if k > len(lst):  # 注意k大于二叉树节点个数的情况
            return None
        return lst[k - 1]
```

##### 题解 2

　　同样是中序遍历，但是这里是一边遍历一遍找，找到即停止。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回对应节点TreeNode
    def __init__(self):
        self.res = None
        self.cnt = 0

    def KthNode(self, pRoot, k):
        # write code here
        self.inOrder(pRoot, k)
        return self.res

    def inOrder(self, root, k):  # 中序遍历
        if root is None or self.cnt >= k:  # 满足条件返回
            return
        self.inOrder(root.left, k)
        self.cnt += 1  # 计数
        if self.cnt == k:  # 找到第k小的数
            self.res = root
        self.inOrder(root.right, k)
```

##### 题解 3

　　非递归方式实现中序遍历并计数，即可找到第k个节点。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回对应节点TreeNode
    def KthNode(self, pRoot, k):
        if pRoot is None or k == 0:
            return None
        cnt = 0
        stack = []
        while pRoot or stack:  # 中序遍历
            while pRoot:
                stack.append(pRoot)
                pRoot = pRoot.left
            pRoot = stack.pop()
            cnt += 1
            if cnt == k:  # 满足条件返回
                return pRoot
            pRoot = pRoot.right
        return None
```