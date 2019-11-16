---
title: 剑指offer-栈和队列(上)
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 11832
date: 2019-08-06 15:43:57
---

<center>秋招，来了！</center>

<!--more-->

#### 用两个栈实现队列

##### 题目描述

　　用两个栈来实现一个队列，完成队列的Push和Pop操作。 队列中的元素为int类型。

##### 题解

　　入栈时，将元素压入第一个栈；出栈时，先把第一个栈的元素依次弹出并压入到第二个栈，此时第二个栈的栈顶元素即为队头元素，弹出栈顶元素作为结果，然后再把第二个栈的元素依次弹出并压入到第一个栈，最后返回结果即可。

```python
# -*- coding:utf-8 -*-
class Solution:
    def __init__(self):
        self.stack1 = []
        self.stack2 = []
        
    def push(self, node):
        self.stack1.append(node)

    def pop(self):
        while self.stack1:
            self.stack2.append(self.stack1.pop())
        result = None
        if self.stack2:
            result = self.stack2.pop()
        while self.stack2:
            self.stack1.append(self.stack2.pop())
        return result
```

##### 补充

　　用两个队列来实现一个栈，完成栈的 Push 和 Pop 操作。入栈时直接压入 queue1 中，出栈时先将除 queue1 最后一个元素外依次 Pop 出队列，并压入 queue2 中，将留在 queue1 中的最后一个元素出队列即为出队元素，之后再次将 queue2 中的元素压回 queue1 中。

```python
# -*- coding:utf-8 -*-
class Solution:
    def __init__(self):
        self.queue1 = []
        self.queue2 = []
        
    def push(self, node):
        self.queue1.append(node)

    def pop(self):
        while self.queue1:
            self.queue2.append(self.queue1[0])
            del self.queue1[0]
        result = None
        if self.queue2:
            result = self.queue2[-1]
            del self.queue2[-1]
        while self.queue2:
            self.queue1.append(self.queue2[0])
            del self.queue2[0]
        return result
```

#### 包含min函数的栈

##### 题目描述

　　定义栈的数据结构，请在该类型中实现一个能够得到栈中所含最小元素的min函数（时间复杂度应为O(1)）。

##### 题解 1

　　通过列表存放栈的元素，通过内置函数 min 得到列表中最小的元素即为栈中最小的元素。

```python
# -*- coding:utf-8 -*-
class Solution:
    def __init__(self):
        self.stack = []
        
    def push(self, node):
        self.stack.append(node)
    def pop(self):
        if self.stack:
            return self.stack.pop()
        else:
            return None
    def top(self):
        return self.stack[-1]
    def min(self):
        return min(self.stack)
```

##### 题解 2

　　设置一个变量存放最小值，每一次压栈的时候进行比较。再设置一个辅助栈，用于存放当前栈的最小值（设置辅助栈是因为，若最小值出栈了，最小值需要进行更新，因此需要辅助栈来保存次小值）。

```python
# -*- coding:utf-8 -*-
class Solution:
    def __init__(self):
        self.stack = []
        self.min_stack = []
        self.min_item = float('inf')

    def push(self, node):
        if node < self.min_item:
            self.min_item = node
            self.min_stack.append(node) 
        self.stack.append(node)
        
    def pop(self):
        if self.stack:
            item = self.stack.pop()
            if item == self.min_stack[-1]:
                self.min_stack.pop()
                self.min_item = self.min_stack[-1]
            return item
        else:
            return None
        
    def top(self):
        return self.stack[-1]
    
    def min(self):
        return self.min_item
```

#### 栈的压入、弹出序列

##### 题目描述

　　输入两个整数序列，第一个序列表示栈的压入顺序，请判断第二个序列是否可能为该栈的弹出顺序。假设压入栈的所有数字均不相等。例如序列1,2,3,4,5是某栈的压入顺序，序列4,5,3,2,1是该压栈序列对应的一个弹出序列，但4,3,5,1,2就不可能是该压栈序列的弹出序列。（注意：这两个序列的长度是相等的）

##### 题解

　　借助一个辅助列表，模拟栈的操作，遍历压入序列，每次压入一个元素，然后检查栈顶元素是否与 j 指向的弹出序列的元素相等，如果是则弹出，并检查弹出序列的下一个元素，再次判断栈顶元素是否与 j 指向的弹出序列的元素相等，直到不相等，再执行压入操作。最后判断栈是否为空，如果为空则证明第二个序列就是该栈的弹出序列。

```python
# -*- coding:utf-8 -*-
class Solution:
    def IsPopOrder(self, pushV, popV):
        len_push = len(pushV)
        len_pop = len(popV)
        if len_push != len_pop:
            return False
        stack = []
        j = 0
        for i in range(len_push):
            stack.append(pushV[i])
            while j<len_pop and popV[j] == stack[-1]:
                stack.pop()
                j += 1
        if stack:
            return False
        else:
            return True
```