---
title: Python 数据结构-栈
tags:
  - Python
  - Stack
categories: 
  - Algorithm
  - Data structure
abbrlink: 33516
date: 2019-03-09 10:22:39
---

<center>Python 数据结构-栈回顾。</center>
<!--more-->

　　栈（stack），有些地方称为堆栈，是一种容器，可存入数据元素、访问元素、删除元素，它的特点在于只能允许在容器的一端（称为栈顶端指标）进行加入数据（push）和输出数据（pop）的运算。没有了位置概念，保证任何时候可以访问、删除的元素都是此前最后存入的那个元素，确定了一种默认的访问顺序。由于栈数据结构只允许在一端进行操作，因而按照后进先出（LIFO, Last In First Out）的原理运作。如图所示：

![10-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/2/10-1.jpg)

　　在 Python 中，列表的方法使得可以把列表当成元素后进先出的堆栈来用。使用 `append()` 来把一个元素加到堆栈的顶部。使用不显示携带索引参数的 `pop()` 方法来把一个元素从堆栈顶部移除。

#### 基本操作

- Stack() 创建一个新的空栈
- push(item) 添加一个新的元素item到栈顶
- pop() 弹出栈顶元素
- peek() 返回栈顶元素
- is_empty() 判断栈是否为空
- size() 返回栈的元素个数

```python
class Stack(object):
    """栈"""

    def __init__(self):
        self.items = []

    def is_empty(self):
        """判断是否为空"""
        return self.items == []

    def push(self, item):
        """加入元素"""
        self.items.append(item)

    def pop(self):
        """弹出元素"""
        return self.items.pop()

    def peek(self):
        """返回栈顶元素"""
        return self.items[len(self.items) - 1]

    def size(self):
        """返回栈的大小"""
        return len(self.items)
```

#### 栈的应用

##### 逆序输出 

```python
nums = [1, 2, 3, 4, 5, 6]
stack = Stack()
for i in nums:
    stack.push(i)  # 入栈
for i in range(len(nums)):
    nums[i] = stack.pop()  # 出栈
print(nums)

# 输出
[6, 5, 4, 3, 2, 1]
```

##### 括号匹配

　　遇到左半边括号时，进行入栈操作；遇到右半边括号时，检查是否与栈顶元素匹配，如果是，则将栈顶元素出栈，否则，返回匹配失败。最后，如果栈为空，则返回匹配成功，否则，返回匹配失败。

```python
def check_parens(exp):
    open_parens = "([{"  # 左半边括号
    opposite = {')': '(', ']': '[', '}': '{'}  # 括号对
    s = Stack()
    for i in exp:
        if i in open_parens:  # 左半边括号入栈
            s.push(i)
        elif s.peek() == opposite[i]:  # 遇到右半边括号，且栈顶元素与之匹配
            s.pop()
        else:  # 匹配失败
            return False
    if s.is_empty():
        return True  # 全部是匹配的
    else:
        return False
```

##### 数制转换

　　通过求余法，可以将十进制数转换为其他进制，比如要转为二进制，将十进制数除以2，记录余数，然后继续将商除以2，一直到商等于0为止，最后将余数倒着写数来就可以了。

```python
# 递归形式
def convert(stack, n, base):
    digit = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
    if n:
        stack.push(digit[n%base]) # 余数入栈
        convert(stack, int(n/base), base)

# 非递归形式
def convert(stack, n, base):
    digit = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
    while n:
        stack.push(digit[n%base]) # 余数入栈
        n //= base

# 将十进制的 8 转换成二进制
s = Stack()
n = 8
base = 2
convert(s, 8, 2)
res = ''
for i in range(s.size()):
    res += s.pop()
print(res)
```

##### 递归

　　栈还有一个重要应用就是在程序设计语言中实现函数调用。当一个函数在运行期间调用另一个函数时，在运行被调用函数之前，系统需要将实际参数和返回值地址等数据传递给被调函数，当函数调用时，这些数据与局部变量一起构成一条“工作记录”，被压入系统提供的栈。
