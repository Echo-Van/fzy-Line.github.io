---
title: Golang 笔记-栈和队列
tags: Golang
categories:
  - Coding
  - Golang
abbrlink: 7400
date: 2019-06-27 21:49:10
---

<center>Golang 栈和队列实现复习与总结</center>
<!---more-->

#### 栈

　　栈是一种只能从表的一端存取数据且遵循”先进后出“原则的线性存储结构。

```go
package stack

import (
	"sync"
	"errors"
	"fmt"
)

type item interface{}

type Stack struct {
	items []item
	lock  sync.Mutex
}

// 创建栈
func (stack *Stack) New() *Stack {
	stack.items = []item{}
	return stack
}
```

##### 入栈

```go
// 入栈
func (stack *Stack) Push(t item) {
	stack.lock.Lock()
	defer stack.lock.Unlock()

	stack.items = append(stack.items, t)
}
```

##### 出栈

```go
// 出栈
func (stack *Stack) Pop() (interface{}, error) {
	stack.lock.Lock()
	defer stack.lock.Unlock()

	if stack.IsEmpty() {
		return nil, errors.New("stack is Empty")
	}

	t := stack.items[len(stack.items)-1]
	stack.items = stack.items[:len(stack.items)-1 ]
	return t, nil
}
```

##### 栈大小

```go
// 栈大小
func (stack *Stack) Size() int {
	stack.lock.Lock()
	defer stack.lock.Unlock()

	return len(stack.items)
}
```

##### 判断栈空

```go
// 判断栈空
func (stack *Stack) IsEmpty() bool  {
	return len(stack.items) == 0
}
```

　　注意：这里不能再加锁。因为其他方法中有调用这个方法，会导致未解锁时进行加锁，出现死锁的情况。

##### 取栈顶元素

```go
// 取栈顶元素
func (stack *Stack)Top() (interface{}, error) {
	stack.lock.Lock()
	defer stack.lock.Unlock()

	if stack.IsEmpty() {
		return nil, errors.New("stack is Empty")
	}

	t := stack.items[len(stack.items)-1]
	return t, nil
}
```

##### 清空栈

```go
// 清空栈
func (stack *Stack)Clear() (bool, error){
	stack.lock.Lock()
	defer stack.lock.Unlock()

	if stack.IsEmpty() {
		return false, errors.New("queue is empty")
	}

	stack.items = nil
	return true, nil
}
```

##### 打印栈中元素

```go
// 从栈低->栈顶
func (stack *Stack)Print()  {
	stack.lock.Lock()
	defer stack.lock.Unlock()

	for _, v := range stack.items{
		fmt.Print(v, " ")
	}

	fmt.Println()
}
```

##### 测试

```go
package main

import (
    "fmt"
    "stack"
)

func main() {
    var s stack.Stack
    s.New()

    s.Push(1)
    s.Push(2)
    s.Push(3)

    s.Print()

    fmt.Println(s.Size())

    v, err := s.Top()
    fmt.Println(v, err)

    v, err = s.Pop()
    fmt.Println(v, err)

    s.Clear()

    fmt.Println(s.IsEmpty())

}
```

　　输出结果：

```
1 2 3 
3
3 <nil>
3 <nil>
true
```

#### 队列

　　队列只允许在一端进行插入操作、而在另一端进行删除操作的线性表，它是一种先进先出的数据结构，

```go
package queue

import (
    "sync"
    "errors"
    "fmt"
)

// 队列元素
type item interface{}

// 定义队列
type Queue struct {
    items []item
    lock  sync.Mutex
}

// 创建队列
func (queue *Queue) New() *Queue {
    queue.items = []item{}
    return queue
}
```

##### 入队

```go
// 入队
func (queue *Queue) EnQueue(e item) {
    queue.lock.Lock()
    defer queue.lock.Unlock()

    queue.items = append(queue.items, e)
}
```

##### 出队

```go
// 出队
func (queue *Queue) DeQueue() (interface{}, error) {
    queue.lock.Lock()
    defer queue.lock.Unlock()

    if queue.IsEmpty() {
        return nil, errors.New("queue is empty")
    }

    t := queue.items[0]
    queue.items = queue.items[1:len(queue.items)]

    return t, nil
}
```

##### 取队头元素

```go
// 取队列第一个元素
func (queue *Queue) Front() (interface{}, error) {
    queue.lock.Lock()
    defer queue.lock.Unlock()

    if queue.IsEmpty() {
        return nil, errors.New("queue is empty")
    }

    t := queue.items[0]

    return t, nil
}
```

##### 判断队列是否为空

```go
// 判断队列是否为空
func (queue *Queue) IsEmpty() bool {
    return len(queue.items) == 0
}
```

##### 获取队列长度

```go
// 获取队列的长度
func (queue *Queue) Len() int {
    queue.lock.Lock()
    defer queue.lock.Unlock()

    return len(queue.items)
}
```

##### 清空队列

```go
// 清空队列
func (queue *Queue) Clear() (bool, error) {
    queue.lock.Lock()
    defer queue.lock.Unlock()

    if queue.IsEmpty() {
        return false, errors.New("queue is empty")
    }

    queue.items = nil

    return true, nil
}
```

##### 打印队列元素

```go
// 从队头->队尾
func (queue *Queue) Print() {
    queue.lock.Lock()
    defer queue.lock.Unlock()

    for _, v := range queue.items {
        fmt.Print(v, " ")
    }

    fmt.Println()
}
```

##### 测试

```go
package main

import (
    "Myproject/queue"
    "fmt"
)

func main() {
    var q queue.Queue
    q.New()

    q.EnQueue(1)
    q.EnQueue(2)
    q.EnQueue(3)

    q.Print()

    fmt.Println(q.Len())

    v, err := q.DeQueue()
    fmt.Println(v, err)

    v, err = q.Front()
    fmt.Println(v, err)

    q.Clear()

    fmt.Println(q.IsEmpty())
}
```

