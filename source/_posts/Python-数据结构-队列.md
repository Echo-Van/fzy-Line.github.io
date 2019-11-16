---
title: Python 数据结构-队列
tags:
  - Python
  - Queue
categories: 
  - Algorithm
  - Data structure
abbrlink: 33331
date: 2019-03-10 10:23:12
---

<center>Python 数据结构-队列回顾。</center>
<!--more-->

#### 队列

　　队列（queue）是一种先进先出的（First In First Out）的线性表，只允许在一端进行插入操作，而在另一端进行删除操作。允许插入的一端为队尾，允许删除的一端为队头。可以使用列表作为队列，其中添加的第一个元素是检索的第一个元素（“先入，先出”）；然而，列表对于这一目的并不高效。虽然从列表末尾追加和弹出是高效的，但是从列表的开头开始插入或弹出就低效了（因为所有其他元素都必须移动一个位置）。

![12-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/2/12-1.png)

##### 基本操作

- `Queue()` 创建一个空的队列。
- `enqueue(item)` 往队列中添加一个item元素。
- `dequeue()` 从队列头部删除一个元素。
- `is_empty()` 判断一个队列是否为空。
- `size()` 返回队列的大小。

##### Python 实现

```python
class Queue(object):
    """队列"""
    def __init__(self):
        self.items = []

    def is_empty(self):
        return self.items == []

    def enqueue(self, item):
        """进队列"""
        self.items.insert(0,item)

    def dequeue(self):
        """出队列"""
        return self.items.pop()

    def size(self):
        """返回大小"""
        return len(self.items)

if __name__ == "__main__":
    q = Queue()
    q.enqueue("csu")
    q.enqueue("changsha")
    q.enqueue("china")
    print q.size()
    print q.dequeue()
    print q.dequeue()
    print q.dequeue()
```

#### 双端队列

　　双端队列（Deque，全名Double-ended Queue），是一种具有队列和栈的性质的数据结构。元素可以从两端弹出，其限定插入和删除操作在表的两端进行。双端队列可以在队列任意一端入队和出队。

![12-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/2/12-2.jpg)

　　要使用队列或者双端队列，都可以使用 collections 模块中的 deque： [`collections.deque`](https://docs.python.org/3/library/collections.html#collections.deque) ，它被设计为从两端都具有快速追加和弹出的能力。

##### 基本操作

- `Deque()` 创建一个空的双端队列。
- `add_front(item)`从队头加入一个item元素。
- `add_rear(item)` 从队尾加入一个item元素。
- `remove_front()` 从队头删除一个item元素。
- `remove_rear()` 从队尾删除一个item元素。
- `is_empty()` 判断双端队列是否为空。
- `size()` 返回队列的大小。

##### Python 实现

```python
class Deque(object):
    """双端队列"""
    def __init__(self):
        self.items = []

    def is_empty(self):
        """判断队列是否为空"""
        return self.items == []

    def add_front(self, item):
        """在队头添加元素"""
        self.items.insert(0,item)

    def add_rear(self, item):
        """在队尾添加元素"""
        self.items.append(item)

    def remove_front(self):
        """从队头删除元素"""
        return self.items.pop(0)

    def remove_rear(self):
        """从队尾删除元素"""
        return self.items.pop()

    def size(self):
        """返回队列大小"""
        return len(self.items)


if __name__ == "__main__":
    deque = Deque()
    deque.add_front(1)
    deque.add_front(2)
    deque.add_rear(3)
    deque.add_rear(4)
    print deque.size()
    print deque.remove_front()
    print deque.remove_front()
    print deque.remove_rear()
    print deque.remove_rear()
```

