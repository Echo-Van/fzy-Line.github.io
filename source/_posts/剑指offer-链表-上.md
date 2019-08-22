---
title: 剑指offer-链表(上)
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 46600
date: 2019-07-22 11:21:08
---

<center>秋招，来了！</center>
<!--more-->

#### 反转链表

##### 题目描述

　　输入一个链表，反转链表后，输出新链表的表头。

##### 题解 1

　　由于题目并没有要求必须原地反转，因此可以借助外部空间实现。这里可以将单链表储存到列表，然后从后向前遍历列表，实现反转。但是，此方式比较浪费空间，而且需要两次遍历，效率较低。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None
class Solution:
    # 返回ListNode
    def ReverseList(self, pHead):
        
        if pHead == None or pHead.next==None:
            return pHead
    
        res = []
        while pHead:
            res.append(pHead)
            pHead = pHead.next
        
        for i in range(len(res)-1, -1, -1):
            if i == 0:
                res[i].next = None
                return res[-1]
            res[i].next = res[i-1]
```

##### 题解 2

　　使用 3 个指针，分别指向当前遍历到的结点、它的前一个结点及后一个结点。在遍历过程中，首先记录当前节点的后一个节点，然后将当前节点的后一个节点指向前一个节点，其次前一个节点再指向当前节点，最后再将当前节点指向最初记录的后一个节点，如此反复，直到当前节点的后一个节点为 None 时，则代表当前节点时反转后的头结点了。整个过程只需遍历链表一次，效率提高不少，且需要的外部空间也较题解1要少很多。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None
class Solution:
    # 返回ListNode
    def ReverseList(self, pHead):
        
        if pHead == None or pHead.next == None:
            return pHead

        last = None
        while pHead:
            tmp = pHead.next
            pHead.next = last
            last = pHead
            pHead = tmp

        return last
```

#### 从尾到头打印链表

##### 题目描述

　　输入一个链表，按链表从尾到头的顺序返回一个ArrayList。

##### 题解 1

　　借助列表，将链表节点的值存到列表中，再反转列表即可。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    # 返回从尾部到头部的列表值序列，例如[1,2,3]
    def printListFromTailToHead(self, listNode):
        result = []
        while listNode:
            result.append(listNode.val)
            listNode = listNode.next
        result.reverse()
        return result
```

　　也可以借助栈：

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    # 返回从尾部到头部的列表值序列，例如[1,2,3]
    def printListFromTailToHead(self, listNode):
        stack = []
        while listNode:
            stack.append(listNode.val)
            listNode = listNode.next
        
        result = []
        while stack:
            result.append(stack.pop())
        return result
```

##### 题解 2

　　先反转链表，然后再遍历链表。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    # 返回从尾部到头部的列表值序列，例如[1,2,3]
    def printListFromTailToHead(self, listNode):
        pHead = None
        while listNode:
            tmp = listNode.next
            listNode.next = pHead
            pHead = listNode
            listNode = tmp

        result = []
        while pHead:
            result.append(pHead.val)
            pHead = pHead.next
        return result
```

#### 链表中倒数第k个结点

##### 题目描述

　　输入一个链表，输出该链表中倒数第k个结点。

##### 题解 1

　　借助列表，遍历链表，将链表元素存入列表，再从列表中取出倒数第 k 个元素即可。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def FindKthToTail(self, head, k):
        if not head or k == 0:
            return None
        result = []
        while head:
            result.append(head)
            head = head.next
        if k > len(result):
            return None
        return result[len(result)-k]
```

##### 题解 2

　　快慢指针走法。快指针先走 k 步，然后快慢指针再同时往前走，当快指针走到尽头时，慢指针刚好在倒数第 k 个节点的位置上。这样只需要遍历一次链表即可。唯一需要注意的问题是小心参数 k 值大于链表长度。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def FindKthToTail(self, head, k):
        fast = slow = head
        for i in range(k):
            if fast == None:	# 如果 k 大于链表长度，返回空
                return None
            fast = fast.next
        
        while fast:
            fast = fast.next
            slow = slow.next
        return slow
```