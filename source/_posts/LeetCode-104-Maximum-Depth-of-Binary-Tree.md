---
title: LeetCode 104. Maximum Depth of Binary Tree
tags:
  - LeetCode
  - Tree
categories:
  - Algorithm
  - LeetCode
abbrlink: 30717
date: 2019-01-11 19:24:26
---

<center>LeetCode 104. Maximum Depth of Binary Tree 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

Given a binary tree, find its maximum depth.

The maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.

**Note:** A leaf is a node with no children.

- **中文：** 

给定一个二叉树，找出其最大深度。

二叉树的深度为根节点到最远叶子节点的最长路径上的节点数。

**说明:** 叶子节点是指没有子节点的节点。

##### 示例

给定二叉树 `[3,9,20,null,null,15,7]`，

```
    3
   / \
  9  20
    /  \
   15   7
```

返回它的最大深度 3 。

##### 题解

- **题解 1**

　　深度优先搜索（DFS），递归求解，树的深度 = max（左子树深度，右子树深度）+ 1。分别遍历根节点的左右子树（这里的根节点是相对而言的，不只是最初的根节点），每遍历一层，加 1，比较左右结果大小，最后结果再加 1。

```python
class Solution:
    def maxDepth(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        if root is None:
            return 0
        return 1 + max(self.maxDepth(root.left), self.maxDepth(root.right))
```

- **题解 2**

　　广度优先搜索，利用队列求解。每次从队头取出元素，检查是否有子节点，如果有则将节点的左右子节点分别加入队列，每次检查深度都加 1，直到队列中不再有元素。

```python
class Solution:
    def maxDepth(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        if root is None:
            return 0
        depth = 0
        q = [root]
        while(len(q)!=0):
            depth += 1	# 深度统计
            for i in range(len(q)):
                if q[0].left:
                    q.append(q[0].left)	# 左子节点插入到队列
                if q[0].right:
                    q.append(q[0].right)	# 右子节点插入到队列
                del q[0]	# 删除队头元素
        return depth
```

