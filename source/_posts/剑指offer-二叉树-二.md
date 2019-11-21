---
title: 剑指offer-二叉树(二)
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 35874
date: 2019-08-02 10:03:19
---

<center>秋招，来了！</center>

<!--more-->

#### 平衡二叉树

##### 题目描述

　　输入一棵二叉树，判断该二叉树是否是平衡二叉树。

##### 题解 1

　　只需确保树的左右子树的高度差不超过 2 即可。一个树的深度为左子树和右子树深度的最大值 + 1。问题规模转变为求左子树和右子树的深度，问题形式不变，规模变小，典型的递归问题，最后向上回溯即可求得输入的根节点的高度。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    def IsBalanced_Solution(self, pRoot):
        if pRoot == None:
            return True
        left_depth = self.TreeDepth(pRoot.left)
        right_depth = self.TreeDepth(pRoot.right)
        if abs(left_depth - right_depth) > 1:
            return False
        return True
        
    def TreeDepth(self, pRoot):
        if pRoot == None:
            return 0
        left = self.TreeDepth(pRoot.left)
        right = self.TreeDepth(pRoot.right)
        return max(left, right) + 1
```

##### 题解 2

　　改进题解 1，在求节点的深度只需遍历一次节点。利用一个全局变量表示平衡标志位，在求树的深度时，对求得的左右子树的高度进行判断是否符合平衡二叉树的要求，若不满足，平衡标志位为 False。同时，在求树的深度的时判断这个标志位，若为 False，则说明该树的某一部分不平衡，直接返回即可，即树不是平衡的。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    def __init__(self):
        self.isBalance = True
        
    def IsBalanced_Solution(self, pRoot):
        if pRoot is None:
            return True
        self.juge(pRoot)
        return self.isBalance

    def juge(self, root):
        if root is None or self.isBalance == False:
            return 0
        left = self.juge(root.left)
        right = self.juge(root.right)
        if abs(left - right) < 2:
            self.isBalance = True
        else:
            self.isBalance = False
        return max(left, right) + 1
```

#### 二叉树的镜像

##### 题目描述

　　操作给定的二叉树，将其变换为源二叉树的镜像。输入描述：

```
二叉树的镜像定义：源二叉树 
    	    8
    	   /  \
    	  6   10
    	 / \  / \
    	5  7 9 11
    	镜像二叉树
    	    8
    	   /  \
    	  10   6
    	 / \  / \
    	11 9 7  5
```

##### 题解 1

　　递归实现。交换当前节点的左右子树，然后继续操作交换后的左右子节点的孩子节点。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回镜像树的根节点
    def Mirror(self, root):
        # write code here
        if root is None:
            return
        root.left, root.right = root.right, root.left
        self.Mirror(root.left)
        self.Mirror(root.right)
```

##### 题解 2

　　非递归实现。层次遍历，将每个节点的左右子节点互换即可。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回镜像树的根节点
    def Mirror(self, root):
        # write code here
        if root is None:
            return None
        queue = [root]
        while queue:
            level = []
            length = len(queue)
            for i in range(length):
                node = queue[i]
                node.left, node.right = node.right, node.left
                if node.left:
                    level.append(node.left)
                if node.right:
                    level.append(node.right)
            queue = level
```

#### 对称的二叉树

##### 题目描述

　　请实现一个函数，用来判断一颗二叉树是不是对称的。注意，如果一个二叉树同此二叉树的镜像是同样的，定义其为对称的。

##### 题解 1

　　递归方法，判断的规则：

- 如果左子树或右子树均为空，则该树对称；

- 如果左子树或右子树只有一个为空，则该树不对称；

- 如果左子树和右子树均不为空，当左子树的左子树和右子树的右子树镜像对称，且左子树的右子树和右子树的左子树镜像对称时，该树对称。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    def isSymmetrical(self, pRoot):
        return self.isMirror(pRoot, pRoot)

    def isMirror(self, p1, p2):
        if p1 is None and p2 is None:
            return True
        if p1 is None or p2 is None:
            return False
        if p1.val != p2.val:
            return False
        return self.isMirror(p1.left, p2.right) and self.isMirror(p1.right, p2.left)
```

##### 题解 2

　　非递归方法，判断规则一样。每次成对取出节点，这两个节点其实是二叉树的对称位置，判断这两个节点的相等情况：

- 如果两节点均为空，则继续下一轮循环；
- 如果两节点只有一个为空，直接返回 False；
- 如果两节点都不为空，且它们的数值不同，也直接返回 False；
- 此时两节点的数值一定相等，将它们的左右子节点逆序加入到队列中，保证每一对节点都是对称的位置。

　　到最后，如果队列中为空，则二叉树对称，返回 True。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    def isSymmetrical(self, pRoot):
        if pRoot is None:
            return True
        queue = [pRoot.left, pRoot.right]
        while queue:
            node1 = queue.pop()
            node2 = queue.pop()
            if node1 is None and node2 is None:
                continue
            if node1 is None or node2 is None or node1.val != node2.val:
                return False
            queue.append(node1.left)
            queue.append(node2.right)
            queue.append(node1.right)
            queue.append(node2.left)
        return True
```