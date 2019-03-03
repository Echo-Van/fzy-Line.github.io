---
title: CCF CSP 字符串匹配
tags:
  - CCF-CSP
  - 教女朋友学Python
categories:
  - Algorithm
  - CCF-CSP
abbrlink: 34224
date: 2019-02-01 22:57:43
---

<center>201409-3 字符串匹配 题解</center>

<!--more-->

#### 201409-3 字符串匹配

##### 问题描述

```
试题编号：201409-3
试题名称：字符串匹配
时间限制：1.0s
内存限制：256.0MB

问题描述
　　给出一个字符串和多行文字，在这些文字中找到字符串出现的那些行。你的程序还需支持大小写敏感选项：当选项打开时，表示同一个字母的大写和小写看作不同的字符；当选项关闭时，表示同一个字母的大写和小写看作相同的字符。
　　
输入格式
　　输入的第一行包含一个字符串S，由大小写英文字母组成。
　　第二行包含一个数字，表示大小写敏感的选项，当数字为0时表示大小写不敏感，当数字为1时表示大小写敏感。
　　第三行包含一个整数n，表示给出的文字的行数。
　　接下来n行，每行包含一个字符串，字符串由大小写英文字母组成，不含空格和其他字符。
　　
输出格式
　　输出多行，每行包含一个字符串，按出现的顺序依次给出那些包含了字符串S的行。
　　
样例输入
Hello
1
5
HelloWorld
HiHiHelloHiHi
GrepIsAGreatTool
HELLO
HELLOisNOTHello

样例输出
HelloWorld
HiHiHelloHiHi
HELLOisNOTHello

样例说明
　　在上面的样例中，第四个字符串虽然也是Hello，但是大小写不正确。如果将输入的第二行改为0，则第四个字符串应该输出。
　　
评测用例规模与约定
　　1<=n<=100，每个字符串的长度不超过100。
```

#### 题解 1

　　可以使用成员操作符 `in` 来判断，但是，这里要考虑大小写是否敏感的问题，特别是大小写不敏感时，我们将字符串全部转换成大写，再使用 `in` 来进行判断。

```python
target = input()  # 子串
flag = int(input())  # 大小写敏感标识
nums = int(input())  # 输入源字符串个数
for _ in range(nums):
    source = input()  # 源字符串
    if flag == 0:  # 大小写不敏感
        if str.upper(target) in str.upper(source):
            print(source)
    else:  # 大小写敏感
        if target in source:
            print(source)
```

#### 题解 2

　　使用 Python 字符串的 `find()` 方法来检测字符串中是否包含某个子串。同上，使用大小写转换的方式来处理大小写不敏感的情况。

```python
target = input()  # 子串
flag = int(input())  # 大小写敏感标识
nums = int(input())  # 输入源字符串个数
for _ in range(nums):
    source = input()
    if flag == 0:  # 大小写不敏感
        target = str.upper(target)
        source = str.upper(source)
    if source.find(target) != -1:  # 查找子串
        print(source)
```

#### 题解 3

　　使用最原始的方法，从源字符串的第一个字符开始，依次与目标字符串，即子串进行比较，若子串的所有字符都与字符串的某一段连续字符相等则目标字符串为源字符串的子串，直接输出。同时，考虑大小写敏感的问题。

```python
target = input()  # 子串
flag = int(input())  # 大小写敏感标识
nums = int(input())  # 输入源字符串个数
for _ in range(nums):
    source = input()
    for i in range(len(source)):
        j = i
        k = 0
        if flag == 0:  # 大小写不敏感
            while j < len(source) and k < len(target) and str.upper(source[j]) == str.upper(target[k]):  # 比较每个字符
                j += 1
                k += 1
        else:  # 大小写敏感
            while j < len(source) and k < len(target) and source[j] == target[k]:
                j += 1
                k += 1

        if k == len(target):  # 如果所有字符都相等
            print(source)
            break
```

#### 判断子串总结

##### in 方法

　　使用成员操作符 `in` ：

```python
>>> s = "Hello world"
>>> "llo" in s
True
>>> "lll" in s
False
```

##### 字符串对象方法

- **find 和 rfind 方法**

```python
>>> s = "Hello world"
>>> s.find("llo") # 返回子串的索引
2
>>> s.find("lll") # 找不到子字符串的时候会返回 -1
-1
>>> s.rfind("llo")
2
>>> s.rfind("lll")
-1
```

- **index 和 rindex 方法**

```python
>>> s = "Hello world"
>>> s.index("llo") # 返回子串的索引
2
>>> s.index("lll") # 找不到子字符串的时候会报一个ValueError异常
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ValueError: substring not found
>>> s.rindex("llo")
2
>>> s.rindex("lll")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ValueError: substring not found
```

- **count 方法**

```python
>>> s = "Hello world"
>>> s.count("llo") # 返回子串出现次数
1
>>> s.count("lll") # 不是子串
0
```

##### str 模块方法

- **find 和 rfind 方法**

```python
>>> s = "Hello world"
>>> str.find(s, "llo") # 返回子串的索引
2
>>> str.find(s, "lll") # 找不到子字符串的时候会返回 -1
-1
>>> str.rfind(s, "llo")
2
>>> str.rfind(s, "lll")
-1
```

- **index 和 rindex 方法**

```python
>>> s = "Hello world"
>>> str.index(s, "llo") # 返回子串的索引
2
>>> str.index(s, "lll") # 找不到子字符串的时候会报一个ValueError异常
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ValueError: substring not found
>>> str.rindex(s, "llo")
2
>>> str.rindex(s, "lll")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ValueError: substring not found
```

- **count 方法**

```python
>>> s = "Hello world"
>>> str.count(s, "llo") # 返回子串出现次数
1
>>> str.count(s, "lll") # 不是子串
0
```

