---
title: Python操作Mysql数据库
date: 2016-07-24 20:31:38
tags: [Python,Mysql]
categories: Python
---

　　在正式开始Python网络爬虫实战之前，我们需要先来了解一下Python的一些基础知识，包括网络请求、数据存储以及异常处理等，这篇博客主要讲解Python的Mysql数据库操作，我们使用爬虫爬取下来的数据需要存储，而数据库就是常用的存储方式之一，所以熟练地掌握数据库操作对于网络爬虫的学习是很有必要的。

<!--more-->

#### 安装访问数据库的类库

windows下cmd直接执行如下命令进行安装：
```
pip install pymysql
```
注：如果没有安装pip包管理器，请先安装pip才能用此命令安装pymysql

#### 基本操作

##### 导入库
```
import mysql
```

##### 连接数据库

```
conn = pymysql.connect(host = 'localhost', 
                       user = '你的用户名',
                       passwd = '你的密码',
                       charset='utf8')  #得到连接对象
cur=conn.cursor()   #得到游标对象
cur.execute("USE school")   #指定使用哪个数据库

```

##### 插入、查询等基本操作

###### 创建表：
```
cur.execute("CREATE TABLE student (id TINYINT, Sno VARCHAR(255) UNIQUE KEY, )")
```

###### 插入数据：

方式一：直接赋值

```
cur.execute("INSERT INTO Student (Sno, Sname, Sage, Ssex) VALUES ('20160001', 'xxx', 20, '男')")
conn.commit()   #更改数据后需进行提交
```

方式二：由变量赋值

```
Sno = '20160004'
Sname = 'lll'
Sage = '20'
Ssex = '男'
cur.execute("INSERT INTO Student (Sno, Sname, Sage, Ssex) VALUES (\"%s\",\"%s\",\"%s\",\"%s\")"%(Sno, Sname, Sage, Ssex))
conn.commit()   #更改数据后需进行提交
```

###### 查询数据：

```
cur.execute("SELECT * FROM Student")
```

###### 打印查询结果：

```
print cur.fetchone()    #打印第一条查询结果
print cur.fetchall()    #打印所有查询结果
```
##### 关闭连接

```
cur.close()
conn.close()
```

#### 完整示例

创建一张学生表，有id，学号、姓名、年龄、性别五列，然后插入四条数据，在进行查询并打印所有查询结果。

```
# -*- coding:utf8 -*-
import pymysql

conn = pymysql.connect(host = 'localhost', 
                       user = 'root',
                       passwd = 'fzy1686',
                       charset='utf8')

cur=conn.cursor()
cur.execute("USE school")

try:
    cur.execute("CREATE TABLE Student (id BIGINT(10) NOT NULL AUTO_INCREMENT,\
                                       Sno VARCHAR(20) NOT NULL,\
                                       Sname VARCHAR(20) NOT NULL,\
                                       Sage VARCHAR(10) NOT NULL,\
                                       Ssex VARCHAR(10) DEFAULT '男',\
                                       PRIMARY KEY(id))")
    
    cur.execute("INSERT INTO Student (Sno, Sname, Sage, Ssex) VALUES ('20160001', 'xxx', 20, '男')")
    cur.execute("INSERT INTO Student (Sno, Sname, Sage, Ssex) VALUES ('20160002', 'yyy', 18, '女')")
    cur.execute("INSERT INTO Student (Sno, Sname, Sage, Ssex) VALUES ('20160003', 'zzz', 22, '女')")
    
    Sno = '20160004'
    Sname = 'lll'
    Sage = '20'
    Ssex = '男'
    cur.execute("INSERT INTO Student (Sno, Sname, Sage, Ssex) VALUES (\"%s\",\"%s\",\"%s\",\"%s\")"%(Sno, Sname, Sage, Ssex))   
    conn.commit()
        
    cur.execute("select * from Student")
    print cur.fetchall()
finally:
    cur.close()
    conn.close()

```
