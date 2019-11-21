---
title: 剑指offer-二叉树(三)
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 7296
date: 2019-09-06 09:36:57
---

<center>秋招，来了！</center>
<!--more-->

#### 序列化二叉树

##### 题目描述

　　请实现两个函数，分别用来序列化和反序列化二叉树。

　　二叉树的序列化是指：把一棵二叉树按照某种遍历方式的结果以某种格式保存为字符串，从而使得内存中建立起来的二叉树可以持久保存。序列化可以基于先序、中序、后序、层序的二叉树遍历方式来进行修改，序列化的结果是一个字符串，序列化时通过 某种符号表示空节点（#），以 ！ 表示一个结点值的结束（value!）。

　　二叉树的反序列化是指：根据某种遍历顺序得到的序列化字符串结果str，重构二叉树。

##### 题解

　　序列化可以基于先序/中序/后序/按层等遍历方式进行，这里采用先序遍历的方式实现，字符串之间用 “，”隔开。

```python
def Serialize(self, root):
    if not root:
        return '#'
    return str(root.val) +',' + self.Serialize(root.left) +','+ self.Serialize(root.right)
```

　　反序列化：根据某种遍历顺序得到的序列化字符串，重构二叉树。具体思路是按前序遍历“根左右”的顺序，根节点位于其左右子节点的前面，即非空（#）的第一个节点是某子树的根节点，左右子节点在该根节点后，以空节点#为分隔符。

```python
def Deserialize(self, s):
    list = s.split(',')
    return self.deserializeTree(list)
 
def deserializeTree(self, list):
    if len(list)<=0:
        return None
    val = list.pop(0)
    root = None
    if val != '#':
        root = TreeNode(int(val))
        root.left = self.deserializeTree(list)
        root.right = self.deserializeTree(list)
    return root
```

#### 按之字形顺序打印二叉树

##### 题目描述

　　请实现一个函数按照之字形打印二叉树，即第一行按照从左到右的顺序打印，第二层按照从右至左的顺序打印，第三行按照从左到右的顺序打印，其他行以此类推。

##### 题解 1

　　层次遍历。借助队列实现的，先将根结点入栈，判断条件为队列非空，将队列中的队头元素记录下来，并删除结点，如果该队头结点有左子树，将左子树根结点入队，有右子树，将右子树根结点入队。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    def Print(self, pRoot):
        res = []
        if pRoot is None:
            return res
        cnt = 0
        queue = [pRoot]
        while queue:
            level = []  # 保存每一层的节点值
            cnt += 1
            length = len(queue)
            for _ in range(length):
                node = queue.pop(0)
                level.append(node.val)
                if node.left:
                    queue.append(node.left)
                if node.right:
                    queue.append(node.right)
            if cnt % 2 == 0:  # 偶数层，从右到左
                level.reverse()
            res.append(level)  # 加入结果集
        return res
```

##### 题解 2

　　利用两个栈。当我们在打印某一层的节点时，把下一层的节点保存到相应的栈中。如果当前打印的是奇数层，则先保存左子节点再保存右子节点到一个栈中；如果当前打印的是偶数层，则先保存右子节点再保存左子节点到另一个栈中。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    def Print(self, pRoot):
        res = []
        if pRoot is None:
            return res
        stack1 = [pRoot]
        stack2 = []
        cnt = 1
        while stack1 or stack2:
            level = []
            if cnt % 2 == 1:  # 当前层为奇数层（先保存左子节点再保存右子节点）
                while stack1:
                    node = stack1.pop()
                    level.append(node.val)
                    if node.left:
                        stack2.append(node.left)
                    if node.right:
                        stack2.append(node.right)

            else:  # 当前层为偶数层（先保存左子节点再保存右子节点）
                while stack2:
                    node = stack2.pop()
                    level.append(node.val)
                    if node.right:
                        stack1.append(node.right)
                    if node.left:
                        stack1.append(node.left)

            cnt += 1  # 层数统计
            res.append(level)  # 加入结果集
        return res
```

#### 二叉树中和为某一值的路径

##### 题目描述

　　输入一颗二叉树的跟节点和一个整数，打印出二叉树中结点值的和为输入整数的所有路径。路径定义为从树的根结点开始往下一直到叶结点所经过的结点形成一条路径。(注意: 在返回值的list中，数组长度大的数组靠前)

##### 题解

　　使用前序遍历的方式访问节点，使用列表 res 存储全部路径，使用列表 tmp 存储当前路径。遍历二叉树的过程：按前序遍历顺序访问每一个节点。访问每个节点时，将结点添加到 tmp 中。如果当前结点是叶子结点，则判断当前路径是否是符合条件的路径，符合条件的路径存入到 res；如果当前结点不是叶子结点，则递归当前节点的左右子节点。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回二维列表，内部每个列表表示找到的路径
    def FindPath(self, root, expectNumber):
        self.res = []
        self.Find(root, expectNumber, [])
        return self.res

    def Find(self, root, num, tmp):
        if root is None:
            return
        tmp.append(root.val)
        if not root.left and not root.right:  # 是否是叶子节点
            if root.val == num:  # 路径和为目标值
                self.res.append(tmp[:])
        else:
            self.Find(root.left, num - root.val, tmp)  # 访问左子节点
            self.Find(root.right, num - root.val, tmp)  # 访问右子节点
        tmp.pop()
```

　　思路一样，代码简化的版本：

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回二维列表，内部每个列表表示找到的路径
    def FindPath(self, root, expectNumber):
        if not root:
            return []
        if root.val == expectNumber and not root.left and not root.right:
            return [[root.val]]
        res = []
        left = self.FindPath(root.left, expectNumber - root.val)
        right = self.FindPath(root.right, expectNumber - root.val)
        for i in left + right:
            res.append([root.val] + i)
        return res
```

