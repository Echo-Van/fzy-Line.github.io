---
title: Python 数据结构-二叉树
abbrlink: 35970
date: 2019-01-23 19:24:08
tags:
  - Python
  - 二叉树
categories:
  - Coding
  - Python
---

<center>Python 数据结构-二叉树学习。</center>

<!--more-->

　　二叉树是树的特殊一种，具有如下特点：1、每个结点最多有两颗子树，结点的度最大为2。2、左子树和右子树是有顺序的，次序不能颠倒。3、即使某结点只有一个子树，也要区分左右子树。

#### 基本结构

##### 节点

```python
class Node():
    def __init__(self, val = 0):
        self.val = val
        self.left = None
        self.right = None
```

##### 二叉树

```python
class BinaryTree():
    def __init__(self):
        self.root = None
```

#### 基本操作

##### 插入节点

```python
def insert_node(self, val):
    node = Node(val)
    if not self.root:
        self.root = node
        return
    else:
        q = [self.root]
        while True:
            root = q.pop(0)
            if root.left is None:
                root.left = node
                return
            elif root.right is None:
                root.right = node
                return
            else:
                q.append(root.left)
                q.append(root.right)
```

##### 判断是否为空

```python
def is_empty(self):
    if self.root:
        return True
    else:
        return False
```

##### 统计节点数

```python
def count_node(self, root):
    if root is None:
        return 0
    else:
        return 1 + self.count_node(root.left) + self.count_node(root.right)
```

##### 最大深度

- **递归方式**

```python
def max_depth(self, root):
    if root is None:
        return 0
    return 1 + max(self.max_depth(root.left), self.max_depth(root.right))
```

- **非递归方式**

```python
def max_depth(self, root):
    if root is None:
        return 0
    depth = 0
    queue = [root]
    while len(queue) != 0:
        depth += 1
        node = queue[0]
        for i in range(len(queue)):
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
            del queue[0]
    return depth
```

##### 构造树

```python
nums = [4, 2, 7, 1, 3, 6, 9]
tree = BinaryTree()
for i in nums:
    tree.insert_node(i)
```

　　生成如下所示的二叉树：

```
     4
   /   \
  2     7
 / \   / \
1   3 6   9
```

##### 打印树

```python
def print_tree(self, root):
    if root:
        print(root.val, end=" ")
        self.print_tree(root.left)
        self.print_tree(root.right)
```

#### 反转树

- **递归方式**

```python
def invert_tree(self, root):
    if not root:
        return
    root.left, root.right = root.right, root.left
    if root.left:
        self.invert_tree(root.left)
    if root.right:
        self.invert_tree(root.right)
```

- **非递归方式**

```python
def invert_tree(self, root):
    if root is None:
        return root
    if root.left is not None or root.right is not None:
        tmp = root.left
        root.left = root.right
        root.right = tmp
        if root.left is not None:
            self.invert_tree(root.left)
        if root.right is not None:
            self.invert_tree(root.right)
    return root
```

#### 遍历

##### 前序遍历

- **递归方式**

```python
def pre_order(self, root, res=None):
    if root is None:
        return []
    if res is None:
        return []
    res.append(root.val)
    self.pre_order(root.left, res)
    self.pre_order(root.right, res)
    return res
```

- **非递归方式**

```python
def pre_order(self, root):
    res = []
    if not root:
        return res
    stack = []
    stack.append(root)
    while stack:
        root = stack.pop()
        res.append(root.val)
        if root.right:
            stack.append(root.right)
        if root.left:
            stack.append(root.left)
    return res
```

##### 中序遍历

- **递归方式**

```python
def in_order(self, root, res=None):
    if root is None:
        return []
    if res is None:
        return []
    self.in_order(root.left, res)
    res.append(root.val)
    self.in_order(root.right, res)
    return res
```

- **非递归方式**

```python
def in_order(self, root):
    res = []
    if not root:
        return res
    stack = []
    while root or stack:
        while root:
            stack.append(root)
            root = root.left
        root = stack.pop()
        res.append(root.val)
        root = root.right
    return res
```

##### 后序遍历

- **递归方式**

```python
def post_order(self, root):
    res = []
    if root is None:
        return []
    preorder(root.left, res)
	preorder(root.right, res)
    res.append(root.val)
    return res
```

- **非递归方式**

```python
def post_order(self, root):
    res_temp = []
    res = []
    if not root:
        return res
    stack = []
    stack.append(root)
    while stack:
        root = stack.pop()
        res_temp.append(root.val)
        if root.left:
            stack.append(root.left)
        if root.right:
            stack.append(root.right)
    while res_temp:
        res.append(res_temp.pop())
    return res
```

##### 层次遍历

```python
def level_order(self, root):
    res = []
    if not root:
        return res
    level = [root]
    while level:
        current = []
        new_level = []
        for node in level:
            current.append(node.val)
            if node.left:
                new_level.append(node.left)
            if node.right:
                new_level.append(node.right)
        level = new_level
        res.append(current)
    return res
```

