---
title: 剑指offer-链表(中)
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 17939
date: 2019-08-10 09:29:39
---

<center>秋招，来了！</center>
<!--more-->

#### 两个链表的第一个公共结点

##### 题目描述

　　输入两个链表，找出它们的第一个公共结点。

##### 题解 1

　　暴力破解。在第一个链表上顺序遍历每一个结点，每遍历到一个结点，就在第二个链表上顺序遍历每个结点。如果在第二个链表上有一个结点与第一个链表上的结点一样，则说明两个链表在这个结点上重合，于是就找到了他们的公共结点。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def FindFirstCommonNode(self, pHead1, pHead2):
        while pHead1:
            tmp = pHead2
            while tmp:
                if tmp.val == pHead1.val:
                    return tmp
                tmp = tmp.next
            pHead1 = pHead1.next
        return None
```

##### 题解 2

　　利用栈结构。如果两个链表有公共结点，那么其公共结点之后的结点就是一样的。因此，可以从后往前遍历两个链表，将链表的每个结点依次压入栈（先进后出）中，再依次弹出。如果栈顶元素不相同，则公共结点就是前一个弹出的元素。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def FindFirstCommonNode(self, pHead1, pHead2):
        if pHead1 is None or pHead2 is None:
            return None
        stack1 = []
        stack2 = []
        while pHead1:  # 链表1入栈
            stack1.append(pHead1)
            pHead1 = pHead1.next
        while pHead2:  # 链表2入栈
            stack2.append(pHead2)
            pHead2 = pHead2.next
        result = None
        while stack1 and stack2 and stack1[-1] == stack2[-1]:  # 出栈
            result = stack1.pop()
            stack2.pop()
        return result
```

##### 题解 3

　　如果两个链表有公共结点，那么其公共结点之后的结点就是一样的。那么两个链表头到公共结点的距离差就是两个链表的长度差，因此，只需要求出两个链表的长度只差 k，让长的链表先走 k 个结点，再继续同时遍历两个链表，当两个链表的指针相等的时候，就是第一个相同的结点。 

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def FindFirstCommonNode(self, pHead1, pHead2):
        len1 = len2 = 0
        tmp1 = pHead1
        tmp2 = pHead2
        while tmp1:
            len1 += 1
            tmp1 = tmp1.next
        while tmp2:
            len2 += 1
            tmp2 = tmp2.next
        if len1 > len2:  # 先走k步
            k = len1 - len2
            while k:
                k -= 1
                pHead1 = pHead1.next
        else:
            k = len2 - len1
            while k:
                k -= 1
                pHead2 = pHead2.next
        while pHead1 and pHead2:
            if pHead1 == pHead2:
                return pHead1
            pHead1 = pHead1.next
            pHead2 = pHead2.next
        return None
```

#### 合并两个排序的链表

##### 题目描述

　　输入两个单调递增的链表，输出两个链表合成后的链表，当然我们需要合成后的链表满足单调不减规则。

##### 题解 1

　　找到两个链表中头节点值相对更小的链表，将其作为主链表，第二个链表中的元素则不断加入到主链表中。具体策略是：主链表定义两个指针，指向两个相邻的元素。当第二个链表中的元素值小于主链表中第二个指针时，将第二个链表的当前元素插入到主链表两个指针指向的元素中间，并调整指针指向。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    # 返回合并后列表
    def Merge(self, pHead1, pHead2):
        if pHead1 is None:
            return pHead2
        if pHead2 is None:
            return pHead1

        head = ListNode(0)
        if pHead1.val < pHead2.val:
            head.next = pHead1
            secHead = pHead2
        else:
            head.next = pHead2
            secHead = pHead1
        mainHead = head.next.next
        while mainHead and secHead:
            if mainHead.val <= secHead.val:
                mainHead = mainHead.next
            else:
                tmp = secHead
                tmp.next = mainHead.next
                mainHead.next = tmp
                secHead = secHead.next
       
        return head.next
```

##### 题解 2

　　递归解法。每次比较两个头节点，将较小的合并，再检查下一个节点，最后得到的就是合并后的链表。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    # 返回合并后列表
    def Merge(self, pHead1, pHead2):
        if pHead1 is None:
            return pHead2
        if pHead2 is None:
            return pHead1
        head = ListNode(0)
        if pHead1.val < pHead2.val:
            head = pHead1
            head.next = self.Merge(pHead1.next, pHead2)
        else:
            head = pHead2
            head.next = self.Merge(pHead1, pHead2.next)
        return head
```

#### 删除链表中重复的结点

##### 题目描述

　　在一个排序的链表中，存在重复的结点，请删除该链表中重复的结点，重复的结点不保留，返回链表头指针。 例如，链表1->2->3->3->4->4->5 处理后为 1->2->5

##### 题解

　　原本以为是去重的任务，即把重复的元素删除，也就是链表1->2->3->3->4->4->5 处理后为 1->2->3->4->5：

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def deleteDuplication(self, pHead):
        if pHead is None or pHead.next is None:
            return pHead
        head = ListNode(0)  # 指向pHead的结点
        head.next = pHead
        while pHead:
            while pHead.next and pHead.val == pHead.next.val:  # 去除重复
                pHead.next = pHead.next.next
            pHead = pHead.next  # 指针后移
        return head.next
```

　　但是，题目的意思是只要重复出现过的元素就都删掉，只保留没有重复出现的。因此，

- 在原链表之前链一个结点 `head`，用它的 `.next` 属性返回原列表去重后的链表头指针；
- 使用两个指针 `cur` 和 `pre`，分别指当前判断的结点和当前结点的前一个结点；
- 因为可能会出现连续重复的结点值，所以需要循环内再套循环判断。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def deleteDuplication(self, pHead):
        if pHead is None or pHead.next is None:
            return pHead
        head = ListNode(0)  # 指向pHead的结点
        head.next = pHead
        pre = head
        cur = pHead
        while cur:
            if cur.next and cur.val == cur.next.val:  # 处理重复
                tmp = cur.next
                while tmp and tmp.val == cur.val:
                    tmp = tmp.next
                pre.next = tmp
                cur = tmp
            else:  # 不是重复的，指针后移
                pre = cur
                cur = cur.next
        return head.next
```