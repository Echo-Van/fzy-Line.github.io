---
title: LeetCode 856. Score of Parentheses
tags:
  - LeetCode
  - Stack
categories:
  - Algorithm
  - LeetCode
abbrlink: 32164
date: 2019-02-03 18:32:06
---

<center>LeetCode 856. Score of Parentheses 题解</center>

<!--more-->

##### 题目描述

- **英文：**

Given a balanced parentheses string `S`, compute the score of the string based on the following rule:

- `()` has score 1
- `AB` has score `A + B`, where A and B are balanced parentheses strings.
- `(A)` has score `2 * A`, where A is a balanced parentheses string.
- **中文：** 

给定一个平衡括号字符串 `S`，按下述规则计算该字符串的分数：

- `()` 得 1 分。
- `AB` 得 `A + B` 分，其中 A 和 B 是平衡括号字符串。
- `(A)` 得 `2 * A` 分，其中 A 是平衡括号字符串。

**提示：**

1. `S` 是平衡括号字符串，且只含有 `(` 和 `)` 。
2. `2 <= S.length <= 50`

##### 示例

- **示例 1：**

```
输入： "()"
输出： 1
```

- **示例 2：**

```
输入： "(())"
输出： 2
```

- **示例 3：**

```
输入： "()()"
输出： 2
```

- **示例 4：**

```
输入： "(()(()))"
输出： 6
```

##### 题解

- **题解 1**

　　利用栈解题，当遇到左半边括号时压进 -1 ，遇到右半边括号时，判断栈顶是否是 -1，如果不是则把栈顶的分数出栈，记录到结果 score 中。 如果栈顶是 -1 ，则判断 score 是否为 0，如果是，则证明是 () 这种情况，压入分数1。否则，压入 2 倍 score。

```python
class Solution:
    def scoreOfParentheses(self, S):
        """
        :type S: str
        :rtype: int
        """
        stack = []
        for i in S:
            if i == '(':  # "("入栈
                stack.append(-1)
            else:
                score = 0
                while stack[-1] != -1:  # 计分
                    score += stack.pop()
                stack.pop()
                if score == 0:  # "()"的情况
                    stack.append(1)
                else:  # "(A)" "AB" 的情况
                    stack.append(2 * score)
        return sum(stack)
```

- **题解 2**

　　依然是栈的思想，但没有用到栈。给定一个标记 flag，若 ‘（’ 则 flag 左移，若 ‘）’ 则 flag 右移，若遇到 () 则 将 flag 的值记录到结果中去。

```python
class Solution:
    def scoreOfParentheses(self, S):
        """
        :type S: str
        :rtype: int
        """
        score = 0
        flag = 0
        for i in range(len(S)):
            if S[i] == '(':
                if flag == 0:  # "()"的情况
                    flag = 1
                else:  # "(A)" "AB" 的情况
                    flag = flag << 1
            else:
                if S[i - 1] == '(':
                    score += flag  # 记录到结果中
                flag = flag >> 1
        return score
```

