---
title: Python文件操作
date: 2016-08-03 10:26:21
tags: [Python,文件]
categories: Python
---

　　上一篇博文中我们介绍了Python使用Mysql数据库进行数据存储，数据库存储的数据需要特定的工具进行打开，而普通的数据文件是一般的电脑都能打开进行查看的，因此数据库存储的通用性没有文件存储那么好，文件存储也是Python网络爬虫的常用存储方式之一，特别是csv文件，所以我们对于文件的输入输出流操作、缓存、基本的读写方式、文件迭代器等我们都需要有一些基本的了解，并熟练掌握文件的读写操作，为我们的爬虫实战打下坚实的基础。

<!--more-->

#### 打开文件

打开文件使用open函数，其中文件名是必选参数，文件模式和缓冲是可选参数

```
open(name[,mode[,buffering]])
```
<!-- more --> 

##### 参数1：文件名

文件名一般采用绝对路径，其中会包含\字符，所以可在字符串前加r。

'r'是防止字符转义的，如果路径中出现'\t'的话，不加r的话\t就会被转义 而加了'r'之后'\t'就能保留原有的样子。例如：

```
>>> s = 'C:\Python27\tcl'
>>> print s
C:\Python27     cl  #解释器将\t识别成一个制表符的间隔
>>> s = r'C:\Python27\tcl'
>>> print s
C:\Python27\tcl     #不进行转义，正常输出
```
可见在字符串前加'r'才能正确使用文件路径

##### 参数2：文件模式

值 | 描述 | 值 | 描述
---|--- | ---|---
'r' | 读模式 | 'a' | 追加模式
'w' | 写模式 | 'b' | 二进制模式
'+' | 读/写模式

##### 参数3：缓冲

参数是0或者False，输入输出是无缓冲的

参数是1或者True，输入输出是有缓冲的

#### 文件读写

##### 写入数据

（1）以字符串形式写入

```
#以写模式打开py.txt文件，若文件不存在，则会创建，若存在则覆盖文件原来的内容
f = open(r'D:\Python\py.txt','w')
#写入Python之禅的前两句
f.write('Beautiful is better than ugly.\n')
f.write('Explicit is better than implicit.\n') 
f.flush()
f.close()
```

    成功写入之后，txt文件内容为以下两行：

    Beautiful is better than ugly.
    Explicit is better than implicit.

（2）写入行

writelines()将传递进来的一个字符串列表中的所有的字符串写入文件，但是不会增加新行，需要自己手动添加。

```
#采用追加模式，再向py.txt文件写入Python之禅的三四句
f = open(r'D:\Python\py.txt','a')
content = ['Simple is better than complex.\n','Complex is better than complicated.\n']
f.writelines(content)   
f.flush()
f.close()
```
    成功写入之后，txt文件内容为以下四行：

    Beautiful is better than ugly.
    Explicit is better than implicit.
    Simple is better than complex.
    Complex is better than complicated.
    
##### 读取数据

（1）以字符串形式读取
```
f = open(r'D:\Python\py.txt','r')
print f.read(6)   #读取6个字符
print f.read()  #读取整个文件
f.close()
```
    运行结果如下：

    Beauti
    ful is better than ugly.
    Explicit is better than implicit.
    Simple is better than complex.
    Complex is better than complicated.
    
    可以看出，f.read(6)先读出了6个字符，然后f.read()将其余的内容全部读出来了。

（2）读取行

```
f = open(r'D:\Python\py.txt','r')
print f.readline()  #读取一行数据
f.close()
```
    readline()函数，读取一行，运行结果如下：
    Beautiful is better than ugly.

```
f = open(r'D:\Python\py.txt','r')
print f.readlines()   #读取文件的所有行
f.close()
```

    readlines()函数，读取一个文件的所有行，并将其作为列表返回，运行结果如下：
    ['Beautiful is better than ugly.\n', 'Explicit is better than implicit.\n', 'Simple is better than complex.\n', 'Complex is better than complicated.\n']
    
#### 对文件内容进行迭代

##### 按字节处理

```
filename = r'D:\Python\py.txt'
f = open(filename)
while True:
    char = f.read(1)    #每次读取一个字符
    if not char: break  #没有字符可读了则停止
    print char  #打印字符
f.close()
```

##### 按行处理

```
filename = r'D:\Python\py.txt'
f = open(filename)
while True:
    line = f.readline().strip()  #读取一行，并去除空行
    if not line: break  #如果没有下一行了则停止
    print line  #打印读取到的一行
f.close()
```

    程序运行结果如下：
    Beautiful is better than ugly.
    Explicit is better than implicit.
    Simple is better than complex.
    Complex is better than complicated.

##### 使用fileinput实现懒惰行迭代

```
import fileinput
filename = r'D:\Python\py.txt'
for line in fileinput.input(filename):
    print line.strip()  #打印读取到的行，并去除空行
```
    程序运行结果同2
    
##### 文件迭代器

```
filename = r'D:\Python\py.txt'
f = open(filename)
for line in f:
    print line.strip()  #打印读取到的行，并去除空行
f.close()
```
    程序运行结果同2
    
#### 关闭文件

写入过的文件总应该关闭，因为Python可能会缓存写入的数据，如果程序奔溃了，那么数据就不会被写入到文件，为了安全起见，在使用完文件后要进行关闭操作。

```
#打开文件
try:
    #写入数据
finally:
    file.close()
```

#### csv文件处理

逗号分隔值（Comma-Separated Values，CSV，有时也称为字符分隔值，因为分隔字符也可以不是逗号），其文件以纯文本形式存储表格数据（数字和文本）。csv文件经常用于网络数据爬取的数据存储。csv文件可以用记事本和excel打开进行查看。

```
# -*- coding: utf-8 -*-
import csv

csvFile = open("D:/Python/data.csv",'wb+' )
try:
    writer = csv.writer(csvFile)
    writer.writerow(('Id','Name','Age'))    #写入一行数据做列名

    data = [(20160001,'fzy','21'),(20160002,'lyj','21'),(20160003,'ljj','20')]
    writer.writerows(data)  #写入多行
    writer.writerow((20160004,'cyx','24'))  #写入一行数据
finally:
    csvFile.close()

csvFile = open("D:/Python/data.csv",'rb+' )
try:
    reader = csv.reader(csvFile)
    for line in reader:
        print line
finally:
    csvFile.close()

```

    程序运行结果：
    ['Id', 'Name', 'Age']
    ['20160001', 'fzy', '21']
    ['20160002', 'lyj', '21']
    ['20160003', 'ljj', '20']
    ['20160004', 'cyx', '24']
    
