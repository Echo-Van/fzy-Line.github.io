---
title: CCF-CSP 日期计算
tags:
  - CCF-CSP
  - 教女朋友学Python
categories:
  - Algorithm
  - CCF-CSP
abbrlink: 52353
date: 2018-10-28 10:06:32
---

<center>CCF-CSP 201509-2 日期计算 题解</center>

<!--more-->

#### 问题描述

```
试题编号：201509-2
试题名称：日期计算
时间限制：1.0s
内存限制：256.0MB

问题描述
    给定一个年份y和一个整数d，问这一年的第d天是几月几日？
    注意闰年的2月有29天。满足下面条件之一的是闰年：
    1） 年份是4的整数倍，而且不是100的整数倍；
    2） 年份是400的整数倍。

输入格式
    输入的第一行包含一个整数y，表示年份，年份在1900到2015之间（包含1900和2015）。
    输入的第二行包含一个整数d，d在1至365之间。

输出格式
    输出两行，每行一个整数，分别表示答案的月份和日期。

样例输入
2015
80

样例输出
3
21

样例输入
2000
40

样例输出
2
9
```

#### 题解1

　　这个题目还是比较简单的，首先可以构建一个数组，用于存储每个月的天数，通过输入的年份可以判断出是闰年还是平年，然后根据判断的结果修改天数列表中2月的天数，这样就得到了这一年每个月的天数列表。然后，依次遍历这个列表，用输入的天数减去当前月份的天数，如果结果大于0，则说明第d天至少还在下个月，所以将月份加1，总天数减去当前月份的天数。直到总天数减去当前月份的天数小于0，说明第d天就在这个月，输出月份和日期。

```python
year = int(input())  # 输入的年份
day = int(input())  # 输入的天数
base = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]  # 每个月的天数

if (year % 4 == 0 and year % 100 != 0) or year % 400 == 0:  # 判断是闰年还是平年
    base[1] = 29  # 闰年的2月有29天

month = 1  # 至少是1月
for i in base:
    if day - i > 0:  # 计算月份与日期
        month += 1  # 月份加1
        day = day - i  # 天数减去当前月份的天数
    else:  # 输出结果
        print(month)
        print(day)
        break
```

#### 题解2

　　使用内部的库 `datetime` ，将输入年份的第一天转换成 datetime，然后将天数转换成 datetime 的时间增量，第 1 天加上时间增量即为 y 年的第 d 天，推算完成后输出结果即可。

```python
import datetime

y = int(input())  # 输入的年份
day_of_year = int(input())  # 输入的天数
date0 = datetime.datetime(y, 1, 1)  # 初始时间
delta = datetime.timedelta(days=day_of_year - 1)  # 增量
date1 = date0 + delta  # 日期推算
print(date1.month)  # 输出月份
print(date1.day)  # 输出日期
```

#### 知识补充

##### datetime 库

- date 类

　　`date` 对象表示理想化日历中的日期（年，月和日），当前格里高利历在两个方向上无限延伸。 1年1月1日称为第1天，1年1月2日称为第2天，依此类推。`date` 类有三个参数，`datetime.date(year,month,day)`，返回 `year-month-day`

```python
>>> import datetime
>>> d = datetime.date(2018, 10, 28)  # 将日期转换为 date 对象
>>> datetime.date.weekday(d)  # 返回日期的星期
6  # 2018年10月28日是星期天，返回的值是从0开始的数
>>> datetime.date.isoformat(d)  # 返回格式为 YYYY-MM-DD 的日期
'2018-10-28'
>>> datetime.date.today()  # 返回当前系统日期
datetime.date(2018, 10, 28)
```

- datetime 类

　　`datetime` 对象是包含日期对象和时间对象的所有信息的单个对象。与日期对象一样，日期时间假定当前公历在两个方向上延伸；像时间对象一样，日期时间假设每天都有3600 * 24秒。

```python
>>> import datetime
>>> datetime.datetime(2018, 1, 1)  # 将时间转换成 datetime 对象
datetime.datetime(2018, 1, 1, 0, 0)
>>> datetime.datetime.now()  # 返回当前系统时间
datetime.datetime(2018, 10, 27, 21, 55, 18, 292266)
>>> datetime.datetime.now().strftime('%b-%d-%Y %H:%M:%S')  # 由日期格式转化为字符串格式
'Oct-27-2018 21:57:16'
>>> datetime.datetime.now().date()  # 返回当前日期时间的日期部分
datetime.date(2018, 10, 27)
>>> datetime.datetime.now().time()  # 返回当前日期时间的时间部分
datetime.time(21, 58, 11, 927696)
>>> datetime.datetime.today()  # 返回当前系统时间
datetime.datetime(2018, 10, 27, 22, 1, 21, 935058)
```

- timedelta 类

　　`timedelta` 对象表示持续时间，两个日期或时间之间的差异，用于计算两个日期之间的差值。

```python
>>> a = datetime.datetime.now()
>>> b = datetime.datetime.now()
>>> b-a  # 计算差值
datetime.timedelta(seconds=4, microseconds=352740)
>>> (b-a).seconds  # 计算秒数差值
4
>>> (b-a).days  # 计算天数差值
0
```