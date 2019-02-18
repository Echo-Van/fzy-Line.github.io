---
title: LeetCode 20. Valid Parentheses
tags:
  - LeetCode
  - Stack
categories:
  - Algorithm
  - LeetCode
abbrlink: 22869
date: 2019-02-02 10:56:16
---

<center>LeetCode 20. Valid Parentheses 题解</center>

<!--more-->

##### 题目描述

- **英文：**

Given a string containing just the characters `'('`, `')'`, `'{'`, `'}'`, `'['` and `']'`, determine if the input string is valid.

An input string is valid if:

1. Open brackets must be closed by the same type of brackets.
2. Open brackets must be closed in the correct order.

Note that an empty string is also considered valid.

- **中文：** 

给定一个只包括 `'('`，`')'`，`'{'`，`'}'`，`'['`，`']'` 的字符串，判断字符串是否有效。

有效字符串需满足：

1. 左括号必须用相同类型的右括号闭合。
2. 左括号必须以正确的顺序闭合。

注意空字符串可被认为是有效字符串。

##### 示例

- **示例 1:**

```
输入: "()"
输出: true
```

- **示例 2:**

```
输入: "()[]{}"
输出: true
```

- **示例 3:**

```
输入: "(]"
输出: false
```

- **示例 4:**

```
输入: "([)]"
输出: false
```

- **示例 5:**

```
输入: "{[]}"
输出: true
```

##### 题解

- **题解 1**

　　使用栈来实现，检查字符串序列，如果遇到左半边括号，则入栈，如果遇到右半边括号，且栈不为空，则出栈，如果最后栈为空，则表示字符串有效。另外，需考虑特殊情况，即只有右半边括号的情况，这时采用标志位标识这种情况，一旦出现这种情况，字符串无效。

```python
class Solution:
    def isValid(self, s):
        """
        :type s: str
        :rtype: bool
        """
        stack = []
        flag = 1
        for i in s:
            if i == '(' or i == '{' or i == '[':  # 左半边括号入栈
                stack.append(i)
            elif stack and ((i == ')' and stack[-1] == "(") or (i == '}' and stack[-1] == "{") or (
                    i == ']' and stack[-1] == "[")):  # 遇到右半边括号，且栈不为空
                stack.pop()
            else:  # 标识只有右半边括号的情况
                flag = 0
        if flag == 0 or stack:
            return False
        else:
            return True
```

- **题解 2**

　　使用字典存储括号对，依然时左半边括号入栈，遇到右半边括号时，检查栈是否为空，如果为空则表示出现只有右半边括号的七情况，返回 False；如果右半边括号不等于栈顶元素，即括号不对称相等，也返回 False；如果最后栈为空，则表示字符串有效，返回 True，否则，返回 False。

```python
class Solution(object):
    def isValid(self, s):
        """
        :type s: str
        :rtype: bool
        """
        if len(s) % 2 != 0:  # 过滤括号数量不是偶数的情况
            return False
        lb = {'(': ')', '[': ']', '{': '}'}  # 括号对
        stack = []
        for x in s:
            if x in lb:  # 左半边括号入栈
                stack.append(x)
            else:  # 右半边括号
                if len(stack) == 0:  # 栈内没有左半边括号，字符串无效
                    return False
                top = stack.pop()
                if lb[top] != x:  # 括号不对称相等
                    return False
        return len(stack) == 0  # 栈为空时则表示字符串有效
```