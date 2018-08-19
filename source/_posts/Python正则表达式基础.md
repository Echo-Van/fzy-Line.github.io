---
title: Python正则表达式基础
tags:
  - Python
  - 正则表达式
categories: Python
abbrlink: 45114
date: 2017-01-20 17:36:25
---

　　正则表达式是一种小型的、高度专业化的编程语言，在Python中通过re模块实现。

　　正则表达式使用单个字符串来描述、匹配一系列匹配某个句法规则的字符串。

<!--more-->

#### 简介

　　正则表达式是由普通字符（例如字符 a 到 z）以及特殊字符（称为"元字符"）组成的文字模式。模式描述在搜索文本时要匹配的一个或多个字符串。正则表达式作为一个模板，将某个字符模式与所搜索的字符串进行匹配。

使用正则表达式可以：

（1）测试字符串内的模式。

　　例如，可以测试输入字符串，以查看字符串内是否出现电话号码模式或信用卡号码模式。这称为数据验证。

（2）替换文本。

　　可以使用正则表达式来识别文档中的特定文本，完全删除该文本或者用其他文本替换它。

（3）基于模式匹配从字符串中提取子字符串。

　　可以查找文档内或输入域内特定的文本。

#### 普通字符

　　大多数字母和字符一般都会和自身匹配

```
>>> import re
>>> r = r"abc"
>>> re.findall(r,'abckkkabc')
['abc', 'abc']
```

#### 元字符

##### 常用元字符

- . 匹配除换行符以外的任意字符

```
>>> import re
>>> r = r".a"
>>> re.findall(r,'aabaca')
['aa', 'ba', 'ca']
>>> re.findall(r,'aabacadd')
['aa', 'ba', 'ca']
```

- [...] 字符集

　　常用来指定一个字符集：[abc],[a-z]

```
>>> import re
>>> r = r't[io]p'
>>> re.findall(r,'top tip ttp tmp')
['top', 'tip']
```

　　元字符在字符集中不起作用：[...$]

```
>>> import re
>>> r = r't[io$]p'
>>> re.findall(r,'top tip ttp tmp t$p')
['top', 'tip', 't$p']
```

　　补集匹配不在区间范围内的字符：[^...]

```
>>> import re
>>> r = r't[^io]p'
>>> re.findall(r,'top tip ttp tmp t$p')
['ttp', 'tmp', 't$p']
```

- ^ 匹配行的开始

　　匹配行首除非设置MULTILINE标志，它只是匹配字符串的开始。在MULTILINE模式里，它也可以直接匹配字符串中的每个换行。

```
>>> import re
>>> r = r'^hi'
>>> re.findall(r,'hi, how are you? hi what are you doing?')
['hi']
>>> re.findall(r,'how are you? hi what are you doing?')
[]
```

- $ 匹配行的结束

　　匹配行尾，行尾被定义为要么是字符串尾，要么是一个换行字符后面的任何位置。

```
>>> import re
>>> r = r'you$'
>>> re.findall(r,'how are you')
['you']
>>> re.findall(r,'how are')
[]
```

- \ 将下一字符标记为特殊字符、愿意字符、反向引用或八进制转义符。

　　反斜线后面可以接不同的字符以表示不同特殊意义，也可以用于取消所有元字符。

```
>>> import re
>>> r = r"\n"
>>> re.findall(r,'abc\n')
['\n']
>>> re.findall(r,'abc\\n')
[]
```

- | 指示在两个或多个项之间进行选择。


```
>>> import re
>>> r = r"ab|ac"
>>> re.findall(r,'abacad')
['ab', 'ac']
```

##### 预定义字符集

- \d 匹配任何十进制数，相当于[0-9]

- \D 匹配任何非数字字符，相当于[^0-9]

- \s 匹配任何空白字符，相当于[\t\n\r\f\v]

- \S 匹配任何非空白字符，相当于[^\t\n\r\f\v]

- \w 匹配任何字母数字字符，相当于[a-zA-Z0-9]

- \W 匹配任何非字母数字字符，相当于[^a-zA-Z0-9]

```
>>> import re
>>> r = r"[0-9]"
>>> re.findall(r,'12ab34cd .;-!')
['1', '2', '3', '4']
>>> r = r"\d"
>>> re.findall(r,'12ab34cd .;-!')
['1', '2', '3', '4']
>>> r = r"\D"
>>> re.findall(r,'12ab34cd .;-!')
['a', 'b', 'c', 'd', ' ', '.', ';', '-', '!']
>>> r = r"\s"
>>> re.findall(r,'12ab34cd .;-!')
[' ']
>>> r = r"\S"
>>> re.findall(r,'12ab34cd .;-!')
['1', '2', 'a', 'b', '3', '4', 'c', 'd', '.', ';', '-', '!']
>>> r = r"\w"
>>> re.findall(r,'12ab34cd .;-!')
['1', '2', 'a', 'b', '3', '4', 'c', 'd']
>>> r = r"\W"
>>> re.findall(r,'12ab34cd .;-!')
[' ', '.', ';', '-', '!']
```

##### 常用重复限定符

- * 字符

　　表示前一个字符可以被匹配零次或者任意多次，而不是只有一次。匹配引擎会试着重复尽可能多的次数。

```
>>> import re
>>> r = r"ab*"
>>> re.findall(r,'a')
['a']
>>> re.findall(r,'ab')
['ab']
>>> re.findall(r,'abb')
['abb']
```

- + 字符

　　表示前一个字符可以被匹配一次或任意多次。

```
>>> import re
>>> r = r"ab+"
>>> re.findall(r,'a')
[]
>>> re.findall(r,'ab')
['ab']
>>> re.findall(r,'abb')
['abb']
```

**注意：**


\* 与 + 之间的不同：* 匹配零次或任意多次，所以可以根本就不出现，但是 + 则要求至少出现一次。

- ? 字符

　　表示前一个字符可以被匹配一次或零次：可以认为它用于标识某事物是可选的。

```
>>> import re
>>> r = r"ab?"
>>> re.findall(r,'a')
['a']
>>> re.findall(r,'ab')
['ab']
>>> re.findall(r,'abb')
['ab']
```

**贪婪模式与非贪婪模式：**

贪婪匹配:正则表达式一般趋向于最大长度匹配，也就是所谓的贪婪匹配。

非贪婪匹配：就是匹配到结果就好，最少的匹配字符。

默认是贪婪模式；在量词后面直接加上一个问号？就是非贪婪模式。

```
>>> import re
>>> r = r"ab+"
>>> re.findall(r,'ab')
['ab']
>>> re.findall(r,'abbb')
['abbb']
>>> r = r"ab+?"
>>> re.findall(r,'ab')
['ab']
>>> re.findall(r,'abbb')
['ab']
```

- {m, n}限定范围

　　其中 m 和 n 是十进制整数。该限定符的意思是至少有 m 个重复，至多到 n 个重复。

　　忽略 m 会认为下边界是0，而忽略n的结果将是上边界为无穷大

　　{0,}等同于 * ，{1,}等同于 + ，而{0,1}则与?相同。如果可以的话，最好用 * , + 或 ?

```
>>> import re
>>> r = r"a{1,3}"
>>> re.findall(r,'a')
['a']
>>> re.findall(r,'aa')
['aa']
>>> re.findall(r,'aaa')
['aaa']
>>> re.findall(r,'aaaa')
['aaa', 'a']
>>> re.findall(r,'ab')
['a']
>>> re.findall(r,'b')
[]
>>> r = r"a{0,}"
>>> re.findall(r,'aaaaa')
['aaaaa', '']
>>> r = r"a{1,}"
>>> re.findall(r,'aaaaa')
['aaaaa']
>>> r = r"a{0,1}"
>>> re.findall(r,'aaaaa')
['a', 'a', 'a', 'a', 'a', '']
```

#### 特殊应用

##### 忽略大小写

(?i) 用于忽略大小写匹配

```
>>> import re
>>> r = r"(?i)ab"
>>> re.findall(r,'AbABabcd')
['Ab', 'AB', 'ab']
```

##### 单词分界符

\b 表示单词分界符

```
>>> import re
>>> r = r"\bhi\b"
>>> re.findall(r,'his him hi history')
['hi']
```