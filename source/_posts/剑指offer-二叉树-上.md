---
title: 剑指offer-二叉树(上)
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 60544
date: 2019-08-01 22:09:25
---

<center>秋招，来了！</center>

<!--more-->

#### 二叉树的深度

##### 题目描述

　　输入一棵二叉树，求该树的深度。从根结点到叶结点依次经过的结点（含根、叶结点）形成树的一条路径，最长路径的长度为树的深度。

##### 题解 1

　　递归解法。深度优先遍历，比较每条路径的长度。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    def TreeDepth(self, pRoot):
        if pRoot is None:
            return 0
        left = self.TreeDepth(pRoot.left)
        right = self.TreeDepth(pRoot.right)
        return max(left, right)+1
```

##### 题解 2

　　非递归实现。使用队列辅助实现层次遍历，然后对每一层计数。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    def TreeDepth(self, pRoot):
        depth = 0
        if pRoot is None:
            return depth
        queue = [pRoot]
        while queue:
            depth += 1
            tmp_queue = []
            for i in queue:
                if i.left:
                    tmp_queue.append(i.left)
                if i.right:
                    tmp_queue.append(i.right)
            queue = tmp_queue
        return depth
```

#### 从上往下打印二叉树

##### 题目描述

　　从上往下打印出二叉树的每个节点，同层节点从左至右打印。

##### 题解

　　考察二叉树的广度遍历。可以借助一个队列来实现。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回从上到下每个节点值列表，例：[1,2,3]
    def PrintFromTopToBottom(self, root):
        result = []
        if root is None:
            return result
        queue = [root]
        while queue:
            tmp = queue.pop(0)
            result.append(tmp.val)
            if tmp.left:
                queue.append(tmp.left)
            if tmp.right:
                queue.append(tmp.right)
        return result
```

#### 把二叉树打印成多行

##### 题目描述

　　从上到下按层打印二叉树，同一层结点从左至右输出。每一层输出一行。

##### 题解

　　借助队列，实现层次遍历，把每一层的所有结点的值加入到结果列表中。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回二维列表[[1,2],[4,5]]
    def Print(self, pRoot):
        result = []
        if pRoot is None:
            return result
        queue = [pRoot]
        while queue:
            tmp_queue = []
            level = []
            for i in queue:
                level.append(i.val)
                if i.left:
                    tmp_queue.append(i.left)
                if i.right:
                    tmp_queue.append(i.right)
            queue = tmp_queue
            result.append(level)
        return result
```

