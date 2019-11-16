---
title: 剑指offer-栈和队列(下)
categories:
  - Algorithm
  - Exercise
tags:
  - Algorithm
  - 剑指offer
  - Python
abbrlink: 48697
date: 2019-08-28 19:23:57
---

<center>秋招，来了！</center>
<!--more-->

#### 翻转单词顺序列

##### 题目描述

　　牛客最近来了一个新员工Fish，每天早晨总是会拿着一本英文杂志，写些句子在本子上。同事Cat对Fish写的内容颇感兴趣，有一天他向Fish借来翻看，但却读不懂它的意思。例如，“student. a am I”。后来才意识到，这家伙原来把句子单词的顺序翻转了，正确的句子应该是“I am a student.”。Cat对一一的翻转这些单词顺序可不在行，你能帮助他么？

##### 题解 1

　　把字符串按照空格切分成字符串列表，然后将列表反转，再使用 join 方法组合成新的字符串即可。

```python
# -*- coding:utf-8 -*-
class Solution:
    def ReverseSentence(self, s):
        if not s:
            return ""
        src = s.strip().split()
        if not src:
            return s
        src.reverse()
        return " ".join(src)
```

##### 题解 2

　　利用栈，把字符串按照空格切分成字符串列表，把列表当作栈，然后依次弹出最后一个元素。

```python
# -*- coding:utf-8 -*-
class Solution:
    def ReverseSentence(self, s):
        if not s:
            return ""
        stack = []
        stack = s.strip().split()
        if not stack:
            return s
        result = ""
        while stack:
            result += stack.pop()
            result += " "
        return result.strip()
```

　　需要特别注意全是空格的字符串。

#### 滑动窗口的最大值

##### 题目描述

　　给定一个数组和滑动窗口的大小，找出所有滑动窗口里数值的最大值。例如，如果输入数组{2,3,4,2,6,2,5,1}及滑动窗口的大小3，那么一共存在6个滑动窗口，他们的最大值分别为{4,4,6,6,6,5}； 针对数组{2,3,4,2,6,2,5,1}的滑动窗口有以下6个： {[2,3,4],2,6,2,5,1}， {2,[3,4,2],6,2,5,1}， {2,3,[4,2,6],2,5,1}， {2,3,4,[2,6,2],5,1}， {2,3,4,2,[6,2,5],1}， {2,3,4,2,6,[2,5,1]}。

##### 题解 1

　　暴力法。通过切片得到每个窗口内的元素，然后使用内置函数 max 求每个窗口内的最大值。

```python
# -*- coding:utf-8 -*-
class Solution:
    def maxInWindows(self, num, size):
        max_value = []
        if num is None or size == 0:
            return max_value
        if size == 1:
            return num
        for i in range(len(num) - size + 1):
            max_value.append(max(num[i:i + size]))
        return max_value
```

##### 题解 2

　　使用双端队列，即可以在队列的两端实现插入和删除操作。让队列的队首元素始终是当前窗口的最大值的索引，且队列的长度始终小于等于 size。在这个队列中，从两端删除元素：

- 从队首删除元素：因为长度超了，必须删掉当前最左的元素。
- 从队尾删除元素：把队列中比新元素小的元素的下标弹出，保证队列队头是窗口元素值最大的下标。

```python
# -*- coding:utf-8 -*-
class Solution:
    def maxInWindows(self, num, size):
        # write code here
        max_value = []
        if num is None or size == 0:
            return max_value
        deque = []
        for i in range(len(num)):
            while deque and num[i] >= num[deque[-1]]:  # 弹出队列中比新元素小的元素的下标
                deque.pop()
            deque.append(i)
            if i - deque[0] + 1 > size:  # 超过最大长度
                deque.pop(0)
            if i + 1 >= size:  # 保存当前最大值
                max_value.append(num[deque[0]])
        return max_value
```