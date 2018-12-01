---
title: Golang 笔记-结构体
tags: Golang
categories:
  - Coding
  - Golang
abbrlink: 9255
date: 2018-08-30 16:12:38
---

<center>Golang 结构体学习。</center>



<!--more-->

　　结构体将多个不同类型命名字段序列打包成一个复合类型，每个字段叫做结构体的成员。在 Go 语言中，结构体就像是类的一种简化形式 。

　　Go 语言中，结构体和它所包含的数据在内存中是以连续块的形式存在的，即使结构体中嵌套有其他的结构体，这在性能上带来了很大的优势。不像 Java 中的引用类型，一个对象和它里面包含的对象可能会在不同的内存空间中，这点和 Go 语言中的指针很像。

#### 定义与初始化

　　结构体定义需要使用 `type` 和 `struct` 关键字。`struct` 关键字定义一个新的数据类型，结构体有中有一个或多个成员。`type` 关键字设定了结构体的名称。结构体的格式如下：

```go
type identifier struct {
    field1 type1
    field2 type2
    ...
}
```

　　结构体的字段可以是任何类型，甚至是结构体本身，也可以是函数或者接口。例如：

```go
type Person struct {
	name string "name field"    // 标签
	age  int
}
```

　　结构体中的字段除了有名字和类型外，还可以有一个可选的标签（tag）：它是一个附属于字段的字符串，可以是文档或其他的重要标记。标签的内容不可以在一般的编程中使用，只有包 `reflect` 能获取它。

　　使用 `new()` 函数给一个新的结构体变量分配内存，它返回指向已分配内存的指针：

```go
var p *Person = new(Person)
```

　　惯用方法是：

```go
t := new(Person) 
```

　　变量 `t` 是一个指向 `T`的指针，此时结构体字段的值是它们所属类型的零值。 声明 `var t T` 也会给 `t` 分配内存，并零值化内存，但是这个时候 `t` 是类型T。在这两种方式中，`t` 通常被称做类型 T 的一个实例（instance）或对象（object）。 初始化一个结构体实例的更简短和惯用的方式如下： 

```go
p := &Person{"fzy", 23}	// 此时p的类型是 *Person
```

　　或者：

```go
var p Person
p = Person{"fzy", 23}
```

　　这种简写方式底层仍然会调用 `new ()`，这里值的顺序必须按照字段顺序来写。当然，也可以通过在值的前面放上字段名来初始化字段的方式，这样就可以不按顺序：

```go
p := &Person{age: 23, name: "fzy"}
```

　　表达式 `new(Type)` 和 `&Type{}` 是等价的。 

- 使用 new 初始化：

 ![new](https://github.com/Unknwon/the-way-to-go_ZH_CN/blob/master/eBook/images/10.1_fig10.1-1.jpg?raw=true)

- 作为结构体字面量初始化： 

![](https://github.com/Unknwon/the-way-to-go_ZH_CN/blob/master/eBook/images/10.1_fig10.1-2.jpg?raw=true)

#### 成员访问与赋值

　　访问结构体成员，需要使用点号 . 操作符，在 Go 语言中这叫 **选择器（selector）**。无论变量是一个结构体类型还是一个结构体类型指针，都使用同样的 **选择器符（selector-notation）** 来访问结构体的字段并赋值：

```go
type Person struct {
    name string
    age  int
}

func main() {
    p := new(Person)
    p.name = "fzy"	// 访问并赋值
    p.age = 23
    fmt.Println(p.name, p.age)
}
```

　　输出结果：

```
fzy 23
```

#### 递归结构体

　　结构体类型可以通过引用自身来定义。这在定义链表或二叉树的元素（通常叫节点）时特别有用，此时节点包含指向临近节点的链接（地址）。如下所示，链表中的 `su`，树中的 `ri` 和 `le` 分别是指向别的节点的指针。

```go
type Node struct {
    data    float64
    su      *Node
}
```

　　同样地可以定义一个双向链表，它有一个前趋节点 `pr` 和一个后继节点 `su`：

```go
type Node struct {
    pr      *Node
    data    float64
    su      *Node
}
```

　　二叉树中每个节点最多能链接至两个节点：左节点（le）和右节点（ri），这两个节点本身又可以有左右节点，依次类推。树的顶层节点叫根节点（**root**），底层没有子节点的节点叫叶子节点（**leaves**），叶子节点的 `le` 和 `ri` 指针为 nil 值。在 Go 中可以如下定义二叉树：

```go
type Tree strcut {
    le      *Tree
    data    float64
    ri      *Tree
}
```

#### 内嵌结构体

　　结构体可以包含一个或多个 **匿名（或内嵌）字段**，即这些字段没有显式的名字，只有字段的类型是必须的，此时类型就是字段的名字。但是，在一个结构体中对于每一种数据类型只能有一个匿名字段。

```go
type Person struct {
    name string
    int
}

func main() {
    p := Person{"fzy", 23}
    fmt.Println(p.name, p.int)
}
```

　　输出结果：

```
fzy 23
```

　　匿名字段本身可以是一个结构体类型，即 **结构体可以包含内嵌结构体**。Go 语言中的继承是通过内嵌或组合来实现的，所以可以说，在 Go 语言中，相比较于继承，组合更受青睐。

```go
type Person struct {
    name string
    age  int
}

type Student struct {
    Person
    number int
}

func main() {
    s := Student{Person{"fzy", 23}, 111}
    fmt.Println(s.name, s.age, s.number)
}
```

　　输出结果：

```
fzy 23 111
```

　　外层结构体通过 `s.name直接进入内层结构体的字段，内嵌结构体甚至可以来自其他包。内层结构体被简单的插入或者内嵌进外层结构体。这个简单的“继承”机制提供了一种方式，使得可以从另外一个或一些类型继承部分或全部实现。

　　当两个字段拥有相同的名字（可能是继承来的名字）时：

- 外层名字会覆盖内层名字（但是两者的内存空间都保留），这提供了一种重载字段或方法的方式；
- 如果相同的名字在同一级别出现了两次，如果这个名字被程序使用了，将会引发一个错误。没有办法来解决这种问题引起的二义性，必须由程序员自己修正。