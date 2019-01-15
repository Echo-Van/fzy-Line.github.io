---
title: LeetCode 226. Invert Binary Tree
tags:
  - LeetCode
  - Tree
categories:
  - Algorithm
  - LeetCode
abbrlink: 42612
date: 2019-01-12 19:56:39
---

<center>LeetCode 226. Invert Binary Tree 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Invert a binary tree.

- **中文：** 

翻转一棵二叉树。

##### 示例

输入：

```
     4
   /   \
  2     7
 / \   / \
1   3 6   9
```

输出：

```
     4
   /   \
  7     2
 / \   / \
9   6 3   1
```

##### 题解

- **题解 1**

　　深度优先搜索，递归解法，每次递归交换当前节点的左右子树，同时对左右子树做同样的处理。写法简单，但是比较耗内存。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def invertTree(self, root):
        """
        :type root: TreeNode
        :rtype: TreeNode
        """
        if root is None:
            return root
        if root.left is not None or root.right is not None:
            tmp = root.left
            root.left = root.right
            root.right = tmp
            if root.left is not None:
                self.invertTree(root.left)
            if root.right is not None:
                self.invertTree(root.right)
        return root
```

　　简化的写法：

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def invertTree(self, root):
        """
        :type root: TreeNode
        :rtype: TreeNode
        """
        if root:
            root.left, root.right = self.invertTree(root.right), self.invertTree(root.left)   
        return root
```

- **题解 2**

　　非递归解法，借助队列来实现，依次检查队头元素，如果右子节点则将其互换，然后加入队列，直到队列中没有元素：

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def invertTree(self, root):
        """
        :type root: TreeNode
        :rtype: TreeNode
        """
        if root is None:
            return None
        q = [root]
        while (len(q) > 0):
            node = q[0]  # 获得队头元素
            node.left, node.right = node.right, node.left  # 交换
            if node.left:
                q.append(node.left)  # 左子节点加入队列
            if node.right:
                q.append(node.right)  # 右子节点加入队列
            del q[0]  # 移除队头元素
        return root
```

　　也可以使用栈来实现：

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def invertTree(self, root):
        """
        :type root: TreeNode
        :rtype: TreeNode
        """
        if root is None:
            return None
        stack = [root]
        while (len(q) > 0):
            node = stack.pop()  # 取出栈顶元素
            node.left, node.right = node.right, node.left  # 交换
            if node.left:
                stack.append(node.left)  # 左子节点入栈
            if node.right:
                stack.append(node.right)  # 右子节点入栈
        return root
```

