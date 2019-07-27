---
title: Python ORM框架-SQLAlchemy
tags:
  - Python
categories:
  - Coding
  - Python
abbrlink: 14360
date: 2019-06-26 21:33:12
---

<center>Python ORM 框架 SQLAlchemy 学习与总结。</center>

<!--more-->

#### ORM

　　ORM：Object Relation Mapping，描述程序中对象和数据库中数据记录之间的映射关系的统称，是一种进行程序和数据库之间数据持久化的一种编程思想。ORM 常用操作就是：增、删、改、查。一般在 Python 程序中ORM 操作都是对 mysqldb 和 pymysql 这样的底层模块进行的封装处理。SQLAlchemy 是 Python 中最著名的ORM 框架。

#### SQLAlchemy

##### 安装

```SHELL
# 安装ORM框架
$ pip install sqlalchemy

# 安装数据库驱动
$ pip install pymysql
```

##### 创建数据库和表

```sql
# 创建test数据库
create database test;

# 切换到test数据库
use test;

# 创建user表，包含id、name和age字段
create table user (id INT primary key, name VARCHAR(20), age TINYINT)
```

##### 连接引擎

```python
# 引入建立引擎的模块
from sqlalchemy import create_engine

# 创建一个和mysql数据库之间的连接引擎对象
engine = create_engine("mysql+pymysql://root:root@localhost/test", encoding="utf-8", echo=True)
# 数据库+数据库连接框架://用户名:密码@IP地址:端口号/数据库名称。
```

##### 连接会话

```python
# 引入创建session连接会话需要的处理模块
from sqlalchemy.orm import sessionmaker

# 创建一个连接会话对象；需要指定是和那个数据库引擎之间的会话
Session = sessionmaker(bind=engine)
session = Session()
```

##### 数据模型基础类

```python
# 引入需要的模块
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, String, Integer

# 创建基础类
BaseModel = declarative_base()

# 创建用户模型
class User(BaseModel):
    # 定义和指定数据库表之间的关联
    __tablename__ = “user”
    # 创建字段类型
    id = Column(Integer, primary_key=True)
    name = Column(String(20))
    age = Column(Integer)
```

#### 基本操作

##### 增加

```python
user1 = User(id=1, name="fzy", age=24)
user2 = User(id=2, name="xxy", age=22)
user3 = User(id=2, name="asd", age=22)
session.add(user1)
session.add(user2)
session.add(user3)
session.commit()
session.close()
```

##### 查询

- 基本查询

```python
user_list = session.query(User)
for user in user_list:
    print(user.name, user.age)
session.close()
```

　　查询结果：

```
fzy 25
xxy 22
asd 22
```

- 条件查询

```python
user_list = session.query(User).filter(User.age==22)
for user in user_list:
    print(user.name, user.age)
session.close()
```

　　查询结果：

```
xxy 22
asd 22
```

　　对比 `filter()` 和 `filter_by()` 方法的区别：

- `filter()` 的参数是一个 boolean 类型，所以它的参数不是一个表达式。
- `filter_by()`的参数是一个表达式，而不是 boolean 值。

- 查询结果排序

```python
user_list = session.query(User).order_by(User.id) 
user_list = session.query(User).order_by(-User.id) 
user_list = session.query(User).order_by(User.age)	# 默认顺序
for user in user_list:
    print(user.name, user.age)

print('------')
    
user_list = session.query(User).order_by(-User.age)	# 指定倒序
for user in user_list:
    print(user.name, user.age)

session.query(User).order_by(-User.id, User.name)	# 根据多字段排序
session.close()
```

　　查询结果：

```
xxy 22
asd 22
fzy 25
------
fzy 25
xxy 22
asd 22
```

　　其他查询结果处理：

- `all()` 函数返回查询列表
- `filter()` 函数返回单项数据的列表生成器
- `one()/one_or_none()/scalar()` 返回单独的一个数据对象

##### 修改

```python
update_user = session.query(User).filter_by(id=1).first()
update_user.age = 25
session.commit()

user = session.query(User).filter_by(id=1).one()
print(user.name, user.age)
session.close()
```

　　修改结果：

```
fzy 25
```

##### 删除

```
del_user = session.query(User).filter_by(id=1).first()
session.delete(del_user)
session.commit()
session.close()
```

##### 回滚

```python
session.rollback()
```

