---
title: 剑指offer-链表(下)
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 9737
date: 2019-08-16 10:30:01
---

<center>秋招，来了！</center>

<!--more-->

#### 链表中环的入口结点

##### 题目描述

　　给一个链表，若其中包含环，请找出该链表的环的入口结点，否则，输出null。

##### 题解 1

　　使用快慢指针。快指针每次走两步，慢指针每次走一步。当两个指针相遇时，再让慢指针从头开始，两个指针都开始走，每次走一步，再次相遇时就是环的入口节点。

```python
# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution(object):
    def entryNodeOfLoop(self, head):
        """
        :type head: ListNode
        :rtype: ListNode
        """
        if head is None:
            return None

        fast = head
        slow = head
        while fast and fast.next:
            fast = fast.next.next  # 快指针走两步
            slow = slow.next  # 慢指针走一步
            if fast == slow:  # 快慢指针相遇
                slow = head  # 慢指针从头开始
                while fast != slow:  # 快慢指针一起走，每次走一步
                    fast = fast.next
                    slow = slow.next
                return fast

        return None
```

##### 题解 2

　　遍历链表，用一个列表记录节点值，如果当前节点的值已经存在于记录列表中，则直接返回当前节点。

```python
# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution(object):
    def entryNodeOfLoop(self, head):
        """
        :type head: ListNode
        :rtype: ListNode
        """
        if head is None:
            return None
        records = []
        while head:
            if head.val in records:
                return head
            else:
                records.append(head.val)
            head = head.next
```



#### 复杂链表的复制

##### 题目描述

　　输入一个复杂链表（每个节点中有节点值，以及两个指针，一个指向下一个节点，另一个特殊指针指向任意一个节点），返回结果为复制后复杂链表的 head。（注意，输出结果中请不要返回参数中的节点引用，否则判题程序会直接返回空）

##### 题解 1

　　这个题目的关键在于 random 指针的处理，如果遍历链表一个个节点复制，那么当前节点的random指针指向的节点在复制的链表中可能还不存在。所以，需要用一个字典来保存每个节点及其对应的克隆节点的地址，这样就可以通过查询这个哈希表在 O(1) 的时间内找到 random 指针所指向的节点。

```python
# -*- coding:utf-8 -*-
# class RandomListNode:
#     def __init__(self, x):
#         self.label = x
#         self.next = None
#         self.random = None

class Solution:
    # 返回 RandomListNode
    def Clone(self, pHead):
        # write code here
        if pHead is None:
            return pHead

        records = {}
        copy_head = RandomListNode(pHead.label)
        copy = copy_head
        head = pHead.next

        while head:  # 将原始链表复制出来，先忽略random指针，但是保存原始节点和复制节点的地址
            copy.next = RandomListNode(head.label)
            copy = copy.next
            records[id(head)] = copy
            head = head.next

        head = pHead
        copy = copy_head
        while head:  # 处理random指针
            if head.random:
                copy.random = records[id(head.random)]
            copy = copy.next
            head = head.next

        return copy_head
```

##### 题解 2

　　也可以不使用字典，拆成三步来处理：

- 遍历链表，复制每个结点，如复制结点 src 得到 copy，将结点 copy 插到结点 src 后面；

- 重新遍历链表，复制老结点的随机指针给新结点，如 src.random = copy.random.next;

- 拆分链表，将链表拆分为原链表和复制后的链表。

```python
# -*- coding:utf-8 -*-
# class RandomListNode:
#     def __init__(self, x):
#         self.label = x
#         self.next = None
#         self.random = None

class Solution:
    # 返回 RandomListNode
    def Clone(self, pHead):
        # write code here
        if pHead is None:
            return pHead
        head = pHead
        while head:  # 复制每个节点
            copy = RandomListNode(head.label)
            copy.next = head.next
            head.next = copy
            head = copy.next

        head = pHead
        while head:  # 处理random指针
            copy = head.next
            if head.random:
                copy.random = head.random.next
            head = copy.next

        cur, copy_head = pHead, pHead.next
        while cur:  # 拆分链表
            copy = cur.next
            cur.next = copy.next
            if copy.next:
                copy.next = cur.next.next
            cur = cur.next
        return copy_head
```