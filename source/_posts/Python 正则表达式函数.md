---
title: Python 正则表达式函数
tags:
  - Python
  - 正则表达式
categories:
  - Coding
  - Python
abbrlink: 53852
date: 2017-01-21 10:56:33
---

　　Python 的 re 模块（Regular Expression 正则表达式）提供各种正则表达式的匹配操作，在文本解析、复杂字符串分析和信息提取时是一个非常有用的工具。本博客介绍了 re 模块的一些常用函数。

<!--more-->

#### re.compile()函数

　　re 模块提供了一个正则表达式引擎的接口，可以把正则表达式编译成一个正则表达式对象并用它们来进行匹配。

```python
re.compile(strPattern[, flag])
```

　　把那些经常使用的正则表达式编译成正则表达式对象，这样可以提高一定的效率。

```python
>>> import re
>>> p = re.compile('a{1,3}')
>>> print p
<_sre.SRE_Pattern object at 0x033992C0>
>>> p.findall('babaabaaa')
['a', 'aa', 'aaa']
>>> p.findall('abaababa')
['a', 'aa', 'a', 'a']
```

**编译标志**

　　编译标志让你可以修改正则表达式的一些运行方式。在 re 模块中标志可以使用两个名字，一个是全名如 IGNORECASE，一个是缩写，一字母形式如 I。

**标志含义:**

- DOTALL, S使 . 匹配包括换行在内的所有字符

- IGNORECASE, I使匹配对大小写不敏感

- LOCALE, L做本地化识别（locale-aware）匹配

- MULTILINE, M多行匹配，影响 ^ 和 $

- VERBOSE, X能够使用 REs 的 verbose 状态，使之被组织得更清晰易懂

- I，IGNORECASE，使匹配对大小写不敏感；字符类和字符串匹配字母时忽略大小写。举个例子，[A-Z]也可以匹配小写字母，Spam 可以匹配 "Spam", "spam", 或 "spAM"。这个小写字母并不考虑当前位置。

#### re.match()函数

　　re.match 尝试从字符串的起始位置匹配一个模式，如果不是起始位置匹配成功的话，match()就返回None。

```python
re.match(pattern, string, flags=0)
```

　　第 1 个参数是正则表达式，这里为"(\w+)\s"，如果匹配成功，则返回一个Match，否则返回一个None；

　　第 2 个参数表示要匹配的字符串；

　　第 3 个参数是标志位，用于控制正则表达式的匹配方式，如：是否区分大小写，多行匹配等等。


　　**MatchObject 实例也有几个方法和属性：**

- group() 返回被 RE 匹配的字符串

- start() 返回匹配开始的位置

- end() 返回匹配结束的位置

- span() 返回一个元组包含匹配 (开始,结束) 的位置

　　我们可以使用 group(num) 或 groups() 匹配对象函数来获取匹配表达式。

```python
>>> import re
>>> m = re.match(r"www",'www.fzyLine.com')
>>> print m,m.span(),m.group()
<_sre.SRE_Match object at 0x02897E58> (0, 3) www
>>> m = re.match(r"com",'www.fzyLine.com')
>>> print m,m.span(),m.group()
None
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'NoneType' object has no attribute 'span'
```

#### re.search()函数

　　re.search 扫描整个字符串并返回第一个成功的匹配。

```
re.search(pattern, string, flags=0)
```

　　参数含义与 re.match() 一样。

　　匹配成功 re.search() 方法返回一个匹配的对象，否则返回 None。我们可以使用 group(num) 或 groups() 匹配对象函数来获取匹配表达式。

```python
>>> import re
>>> m = re.search(r"www",'www.fzyLine.com')
>>> print m,m.span(),m.group()
<_sre.SRE_Match object at 0x02897E58> (0, 3) www
>>> m = re.search(r"com",'www.fzyLine.com')
>>> print m,m.span(),m.group()
<_sre.SRE_Match object at 0x0284DDB0> (12, 15) com
```

　　**re.match() 与 re.search() 的区别：**

　　re.match() 只匹配字符串的开始，如果字符串开始不符合正则表达式，则匹配失败，函数返回 None；而re.search 匹配整个字符串，直到找到一个匹配。

#### re.sub()函数

```python
re.sub(pattern, repl, string, count)
```

其中，

- pattern : 正则中的模式字符串。

- repl : 替换的字符串，也可为一个函数。

- string : 要被查找替换的原始字符串。

- count : 模式匹配后替换的最大次数，默认 0 ，表示替换所有的匹配。

　　re.sub 还允许使用函数对匹配项的替换进行复杂的处理。如：re.sub(r'\s', lambda m: '[' + m.group(0) + ']', text, 0)；将字符串中的空格' '替换为'[ ]'。

```python
>>> import re
>>> r = r"\."
>>> re.sub(r,'-','www.fzyLine.com')
'www-fzyLine-com'
```

#### re.subn()函数

　　subn() 与 sub() 相同，但会返回新的字符串和替换次数。

```python
>>> import re
>>> r = r"\."
>>> re.subn(r,'-','www.fzyLine.com')
('www-fzyLine-com', 2)
```

#### re.split()函数

　　re.split可以用来分割字符串，如：re.split(r'\s+', text)；将字符串按空格分割成一个单词列表。

```python
>>> import re
>>> r = r"\."
>>> re.split(r,'www.fzyLine.com')
['www', 'fzyLine', 'com']
```

#### re.findall()函数

　　re.findall() 可以获取字符串中所有匹配的字符串。如：re.findall(r'\w*oo\w*', text)；获取字符串中，包含'oo'的所有单词。

```python
>>> import re
>>> r = r"a\dc"
>>> re.findall(r,'a2cka4cka8c')
['a2c', 'a4c', 'a8c']
```

#### re.finditer()函数

　　finditer() 找到 RE 匹配的所有子串，并把它们作为一个迭代器返回.

```python
>>> import re
>>> r = r"a\dc"
>>> m = re.finditer(r,'a2cka4cka8c')
>>> print m
<callable-iterator object at 0x0292A4B0>
>>> for i in m:
...     print i.group()
...
a2c
a4c
a8c
```

#### group函数

##### group([group1,…])

　　返回匹配到的一个或者多个子组。如果是一个参数，那么结果就是一个字符串，如果是多个参数，那么结果就是一个参数一个 item 的元组。

```python
>>> import re
>>> m = re.match(r"(\d+),(\d+)",'123,456')
>>> m.group()
'123,456'
>>> m.group(1)
'123'
>>> m.group(2)
'456'
>>> m.group(1,2)
('123', '456')
```

##### groups([default])

　　返回一个包含所有子组的元组。Default 是用来设置没有匹配到组的默认值的。Default 默认是 None。

```python
>>> import re
>>> m = re.match(r"(\d+),(\d+)",'123,456')
>>> m.groups()
('123', '456')
>>> m = re.match(r"(\d+),?(\d+)?",'123')
>>> m.groups()
('123', None)
>>> m.groups("0")
('123', '0')
```

##### groupdict([default])

　　返回匹配到的所有命名子组的字典。Key 是 name 值，value 是匹配到的值。参数 default 是没有匹配到的子组的默认值。这里与 groups() 方法的参数是一样的。默认值为 None。groupdict() 对没有 name 的子组不起作用，如下：

```python
>>> import re
>>> m = re.match(r"(\d+),(\d+)",'123,456')
>>> m.groupdict()
{}
>>> m = re.match(r"(?P<first>\d+),(?P<second>\d+)",'123,456')
>>> m.groupdict()
{'second': '456', 'first': '123'}
```
