---
title: LeetCode 965. Univalued Binary Tree
tags:
  - LeetCode
  - Tree
categories:
  - Algorithm
  - LeetCode
abbrlink: 50552
date: 2019-01-29 22:34:58
---

<center>LeetCode 965. Univalued Binary Tree 题解</center>

<!--more-->

##### 题目描述

- **英文：** 

A binary tree is *univalued* if every node in the tree has the same value.

Return `true` if and only if the given tree is univalued.

- **中文：** 

如果二叉树每个节点都具有相同的值，那么该二叉树就是*单值*二叉树。

只有给定的树是单值二叉树时，才返回 `true`；否则返回 `false`。

**提示：**

1. 给定树的节点数范围是 `[1, 100]`。
2. 每个节点的值都是整数，范围为 `[0, 99]` 。

##### 示例

- **示例 1：**

```
     1
   /   \
  1     1
 / \     \
1   1     1
```

```
输入：[1,1,1,1,1,null,1]
输出：true
```

- **示例 2：**

```
     2
   /   \
  2     2
 / \ 
5   2
```

```
输入：[2,2,2,5,2]
输出：false
```

##### 题解

- **题解 1**

　　非递归解法。用一个队列记录未检查的节点，然后依次检查每个节点，判断节点的值是否与根节点的值相等，如果是，则检查是否有左右子节点，如果有则将其加入到队列，以待后续检查。然后，判断下一个节点。否则，返回False。直到所有节点都被检查完，再返回True。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isUnivalTree(self, root):
        """
        :type root: TreeNode
        :rtype: bool
        """
        q = [root]
        flag = root.val	# 单值
        while len(q) > 0:
            node = q[0]
            if node.val != flag:	# 一旦有一个不相同即不是单值二叉树树
                return False
            if node.left:
                q.append(node.left)	# 左子节点加入队列，待检查
            if node.right:
                q.append(node.right)	# 右子节点加入队列，待检查
            del q[0]
        return True
```

- **题解 2**

　　递归解法。依次检查每个节点，判断节点是否为空，左子节点和父节点是否相同，右子节点和父节点是否相同，左子节点和右子节点是否相同。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isUnivalTree(self, root):
        """
        :type root: TreeNode
        :rtype: bool
        """
        left = (root.left is None) or (root.val == root.left.val and self.isUnivalTree(root.left))
        right = (root.right is None) or (root.val == root.right.val and self.isUnivalTree(root.right))
        return left and right
```



