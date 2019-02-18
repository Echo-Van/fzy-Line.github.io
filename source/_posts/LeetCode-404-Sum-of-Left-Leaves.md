---
title: LeetCode 404. Sum of Left Leaves
tags:
  - LeetCode
  - Tree
categories:
  - Algorithm
  - LeetCode
abbrlink: 45263
date: 2019-01-29 22:10:24
---

<center>LeetCode 404. Sum of Left Leaves 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Find the sum of all left leaves in a given binary tree.

- **中文：** 

计算给定二叉树的所有左叶子之和。

##### 示例

```
    3
   / \
  9  20
    /  \
   15   7

在这个二叉树中，有两个左叶子，分别是 9 和 15，所以返回 24
```

##### 题解

- **题解 1**

　　非递归解法。用一个队列记录未检查的节点，然后从根节点开始，依次检查每个节点的左子节点和右子节点；检查左子节点时，需判断其是不是叶子节点，如果是，则将其加入到结果中，否则，加入到队列中以待后续检查；检查右子节点时，如果不为空则将其左右子节点加入到队列，待后续检查，否则，不做处理。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def sumOfLeftLeaves(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        res = 0
        if root is None:
            return res
        q = [root]  # 存储待检查节点
        while len(q) > 0:
            node = q[0]  # 检查队头节点
            if node.left:
                if node.left.left is None and node.left.right is None:  # 判断是否是叶子节点
                    res += node.left.val  # 记录到结果中
                else:
                    q.append(node.left)  # 加入队列，用于后续检查
            if node.right:
                q.append(node.right)  # 加入队列，用于后续检查
            del q[0]  # 删除检查完的节点
        return res
```

- **题解 2**

　　递归解法。从根节点开始检查每个节点，每次判断左节点是否存在，并且左子节点为叶子节点，则将其值记录到结果中，否则，再依次检查其左右子节点。

```python
class Solution:
    def sumOfLeftLeaves(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        if root == None:
            return 0
        if root.left and root.left.left == None and root.left.right == None:
            return root.left.val + self.sumOfLeftLeaves(root.right)  # 记录到结果中
        else:
            return self.sumOfLeftLeaves(root.left) + self.sumOfLeftLeaves(root.right)  # 递归检查左右子节点
```



