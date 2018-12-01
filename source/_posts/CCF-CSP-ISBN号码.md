---
title: CCF-CSP ISBN号码
tags:
  - CCF-CSP
  - 教女朋友学Python
categories:
  - Algorithm
  - CCF-CSP
abbrlink: 2026
date: 2018-10-14 16:44:29
---

<center>CCF-CSP 201312-2 ISBN号码 题解</center>

<!--more-->

#### 问题描述

```
试题编号：201312-2
试题名称：ISBN号码
时间限制：1.0s
内存限制：256.0MB

问题描述
    每一本正式出版的图书都有一个ISBN号码与之对应，ISBN码包括9位数字、1位识别码和3位分隔符，其规定格式如“x-xxx-xxxxx-x”，其中符号“-”是分隔符（键盘上的减号），最后一位是识别码，例如0-670-82162-4就是一个标准的ISBN码。ISBN码的首位数字表示书籍的出版语言，例如0代表英语；第一个分隔符“-”之后的三位数字代表出版社，例如670代表维京出版社；第二个分隔之后的五位数字代表该书在出版社的编号；最后一位为识别码。
    识别码的计算方法如下：
    首位数字乘以1加上次位数字乘以2……以此类推，用所得的结果mod 11，所得的余数即为识别码，如果余数为10，则识别码为大写字母X。例如ISBN号码0-670-82162-4中的识别码4是这样得到的：对067082162这9个数字，从左至右，分别乘以1，2，…，9，再求和，即0×1+6×2+……+2×9=158，然后取158 mod 11的结果4作为识别码。
    编写程序判断输入的ISBN号码中识别码是否正确，如果正确，则仅输出“Right”；如果错误，则输出是正确的ISBN号码。

输入格式
    输入只有一行，是一个字符序列，表示一本书的ISBN号码（保证输入符合ISBN号码的格式要求）。

输出格式
    输出一行，假如输入的ISBN号码的识别码正确，那么输出“Right”，否则，按照规定的格式，输出正确的ISBN号码（包括分隔符“-”）。

样例输入
0-670-82162-4

样例输出
Right

样例输入
0-670-82162-0

样例输出
0-670-82162-4
```

#### 题解1

　　这个题思路很简单，只要按照题目所给出的识别码的计算方法进行计算得出即可。但是，要注意，mod 11，所得的余数即为识别码，如果余数为10，则识别码为大写字母X。特别要处理余数为10的情况。

```python
s = input()
a = list(map(int, s[0:len(s) - 1].replace('-', '')))  # 处理输入
sum = 0
for i in range(1, 10):
    sum = sum + i * a[i - 1]  # 求和
m = sum % 11
if (str(m) == s[-1]) or (m == 10 and s[-1] == "X"):  # 识别码正确，输出Right
    print("Right")
elif m == 10 and s[-1] != "X":  # 处理余数为10且最后一位不为X的情况
    s = s[0:len(s) - 1] + "X"
    print(s)
else:  # 输出正确的识别码
    s = s[0:len(s) - 1] + str(m)
    print(s)
```

#### 题解2

　　由于题目结题思路比较简单，所以题解2与题解1没有本质区别，只是程序写法上有一些细节上的区别。

```python
s = input()
b = "".join(s.split('-'))  # 处理输入
c = int()
count = 0
while count < 9:
    c += int(b[count]) * (count + 1)
    count += 1
d = c % 11
if d == 10:  # 处理余数为10的情况
    if b[9] == 'X':
        print('Right')  # 识别码正确，输出Right
    else:
        print(s[0:12] + 'X')  # 输出正确的识别码
else:
    if str(d) == b[9]:
        print('Right')  # 识别码正确，输出Right
    else:
        print(s[0:12] + str(d))  # 输出正确的识别码
```

#### 知识点补充

##### 字符串切片

　　切片操作可以从一个字符串中获取子字符串，语法格式为：

```
[start:end:step]
```

- `[:]` 提取从开头（默认位置0）到结尾（默认位置-1）的整个字符串
- `[start:]` 从 `start` 提取到结尾
- `[:end]` 从开头提取到 `end - 1`
- `[start:end]` 从 `start` 提取到 `end - 1`
- `[start:end:step]` 从 `start` 提取到 `end - 1`，每 `step` 个字符提取一个
- 左侧第一个字符的位置/偏移量为 `0`，右侧最后一个字符的位置/偏移量为 `-1`

```python
>>> s = "abcdefgh"
>>> s[0:2]	# 前两个字符
'ab'
>>> s[0:]	# 整个字符串
'abcdefgh'
>>> s[:]	# 整个字符串
'abcdefgh'
>>> s[:-1]	# 去除字符串最后一个字符
'abcdefg'
>>> s[-2:]	# 倒数两个字符
'gh'
>>> s[::2]	# 步长为2
'aceg'
```

##### 字符串替换

- **切片实现替换**

　　最简单的办法是通过字符串切片与连接操作来实现字符串替换：

```python
>>> s = 'abcd'
>>> s[:2] + 'ef'	# 替换后两个字符
'abef'
```

- **replace() 方法**

　　`replace()` 方法把字符串中的 旧字符串替换成新字符串，如果指定第三个参数 `max`，则替换不超过 `max` 次。语法格式：

```python
str.replace(old, new[, max])
```

　　参数说明：

- `old` 将被替换的子字符串。
- `new` 用于替换 `old` 子字符串的新字符串。
- `max` 可选参数, 替换不超过 `max` 次。

　　返回值：

　　返回字符串中的 `old`（旧字符串） 替换成 `new` （新字符串）后生成的新字符串，如果指定第三个参数`max`，则替换不超过 `max` 次。

　　使用示例：

```python
>>> s = "a-b-c-d"
>>> s.replace('-', '')
'abcd'
>>> s.replace('-', '', 2)	# 指定只替换两次
'abc-d'
```

- **正则表达式**

　　使用正则表达式模块也可以实现替换。

```
re.sub(pattern, repl, string, count)
```

　　参数说明：

- `pattern` 为正则表达式需要被替换的参数
- `repl` 是替换后的字符串
- `string` 为输入的字符串
- `count` 指替换个数。默认为0，表示每个匹配项都替换。

　　使用示例：

```python
import re
s = "Hello World!"
print(re.sub('[A-Z]', '*', s))	# 将s中的大写字母替换为*号
```

　　输出结果：

```
*ello *orld!
```

- 替换指定位置的字符**

　　将字符串转换成列表后修改值，然后用 `join()` 方法组成新字符串。替换单个位置的字符：

```python
def replace_by_index(string, index, c):
    new = []
    for i in string:
        new.append(i)
    new[index] = c
    return ''.join(new)

# 将索引为2的字符替换为f
res = replace_by_index("abcd", 2, 'f')
print(res)
```

　　输出结果：

```
abfd
```

　　替换字符串中多个指定位置为指定字符：

```python
# 替换字符串中多个指定位置的字符
# pos:位置列表，chr:对应替换的字符列表
def multi_replace_by_index(s, pos, chr):
    new = []
    for i in s:
        new.append(i)
    for index in pos:
        new[index] = chr[index-1]
    return ''.join(new)


res = multi_replace_by_index("abcd", [1, 2], ['f', 'm'])
print(res)
```

　　输出结果：

```
afmd
```

##### 字符串拼接

- **+号**

　　使用加号可以直接连接两个字符串，返回新的字符串。

```python
>>> s1 = "ab"
>>> s2 = "cd"
>>> s1 + s2
'abcd'
```

- **join() 方法**

　　`join()` 方法用于将序列中的元素以指定的字符连接生成一个新的字符串。

```python
str.join(sequence)
```

　　参数说明：`sequence` -- 要连接的元素序列。`sequence` 中的元素必须是字符或字符串，否则会报错。

　　返回值：返回通过指定字符连接序列中元素后生成的新字符串。

　　使用示例：

```python
>>> s1 = "-"
>>> seq = ['a', 'b', 'c', 'd']	#连接的序列是列表
>>> s1.join(seq)
'a-b-c-d'
>>> seq = ('a', 'b', 'c', 'd')	#连接的序列是元组
>>> s1.join(seq)
'a-b-c-d'
>>> seq = "ijkl"	#连接的序列是字符串
>>> s1.join(seq)
'i-j-k-l'
>>> seq = {"m":1, "n":2, "o":3, "p":4}	#连接的序列是字典，会将所有key连接起来
>>> s1.join(seq)
'm-n-o-p'
>>> s1 = "---"	#使用多字符连接序列
>>> seq = "abcd"
>>> s1.join(seq)
'a---b---c---d'
```

- **format() 方法**

　　`str.format()` 为格式化字符串的函数。基本语法是通过 {} 和 : 来代替以前的 % 。`format()` 函数可以接受不限个参数，位置可以不按顺序。

```python
>>> a = "I"
>>> b = "Love"
>>> c = "You"
>>> '{} {} {}'.format(a, b, c)	# 按默认顺序
'I Love You'
>>> '{2} {1} {0}'.format(a, b, c)	# 指定位置
'You Love I'
>>> '{0} {1[0]} {1[1]}'.format(a, [b, c])	# 传入参数为列表
'I Love You'
```

