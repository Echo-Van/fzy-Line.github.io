---
title: Golang笔记-方法
tags: Golang
categories:
  - Programming language
  - Golang
abbrlink: 7143
date: 2018-09-02 15:08:47
---

<center>Golang 方法学习</center>

<!--more-->

　　上一篇博客，我们介绍了 Go 语言中的结构体，它就像是类的一种简化形式。这篇博客要介绍的是 Go 语言中的方法，类似于面向对象语言中类的。Go 方法是作用在接收者（receiver）上的一个函数，接收者是某种类型的变量。因此方法是一种特殊类型的函数。 

　　**一个类型加上它的方法等价于面向对象中的一个类**。一个重要的区别是：在 Go 语言中，类型的代码和绑定在它上面的方法的代码可以不放置在一起，它们可以存在在不同的源文件，唯一的要求是：它们必须是同一个包的。 

#### 方法定义

　　方法的定义与普通函数的定义类似，只是在函数名字前面多了个参数，这个参数就是接收者，它将方法绑定到接收者对应的类型。定义方法的一般格式如下：

```go
func (recv receiver_type) methodName(parameter_list) (return_value_list) { ... }
```

　　`receiver_type` 叫做 （接收者）基本类型，这个类型必须在和方法同样的包中被声明。在方法名之前，`func` 关键字之后的括号中指定接收者。示例：

```go
type Student struct {
	name   string
	number int
}

func (s *Student) Name() {	// 方法
	fmt.Println(s.name)
}
```

　　接收者类型可以是（几乎）任何类型， 但是接收者不能是一个接口类型，因为接口是一个抽象定义，但是方法却是具体实现。 接收者也不能是一个指针类型，但是它可以是任何其他允许类型的指针。 

　　类型 T（或 *T）上的所有方法的集合叫做类型 T（或 *T）的方法集。因为方法是函数，所以同样的，不允许方法重载，即对于一个类型只能有一个给定名称的方法。但是如果基于接收者类型，是有重载的：具有同样名字的方法可以在 2 个或多个不同的接收者类型上存在：

```go
func (s *Student) Name() {	// 接收者为Student
	fmt.Println(s.name)
}

func (s *School) Name() {	// 接收者为School
	fmt.Println(s.name)
}
```

#### 方法调用

　　如果 `recv` 是 `receiver` 的实例，`Method` 是它的方法名，那么方法调用遵循传统的 `object.name` 选择器符号：

```go
recv.Method()
```

　　如果 `recv` 是一个指针，Go 会自动解引用。

```go
type Student struct {
	name   string
	number int
}

func (s *Student) Name() {	// 方法
	fmt.Println(s.name)
}

func main() {
	s1 := Student{"fzy", 11}	// 值
	s2 := new(Student)	// 指针
	s2.name = "fzy"	// 赋值
	s2.number = 11
	s1.Name()	// 方法调用
	s2.Name()	// 方法调用
}
```

　　输出结果：

```
fzy
fzy
```

#### 指针或值作为接收者

　　鉴于性能的原因，`recv` 最常见的是一个指向 receiver_type 的指针（因为我们不想要一个实例的拷贝，如果按值调用的话就会是这样），特别是在 receiver 类型是结构体时，就更是如此了。**指针方法和值方法都可以在指针或非指针上被调用：**

```go
type Student struct {
	name   string
	number int
}

func (s *Student) Name() {	// 指针方法
	fmt.Println(s.name)
}

func (s Student) Number() {	// 值方法
	fmt.Println(s.number)
}

func main() {
	s1 := Student{"fzy", 11}	// 值
	s2 := new(Student)	// 指针
	s2.name = "fzy"
	s2.number = 11
	s1.Name()	// 值类型调用指针方法
	s1.Number()	// 值类型调用值方法
	s2.Name()	// 指针类型调用指针方法
	s2.Number()	// 指针类型调用值方法
}
```

#### 函数与方法的区别

- 函数将变量作为参数：`Function(recv)`
- 方法在变量上被调用：`recv.Method()`
- 在接收者是指针时，方法可以改变接收者的值（或状态），当参数作为指针传递，即通过引用调用时，函数也可以改变参数的状态。
- 接收者必须有一个显式的名字，这个名字必须在方法中被使用。而函数的参数则可以没有显式的名字，并且不一定要在函数中使用。

#### Get 和 Set 方法

　　可以通过面向对象语言一个众所周知的技术：提供 `getter` 和 `setter` 方法，来实现对未导出字段的访问。在 Go 语言中，对于 `setter` 方法使用 `Set` 前缀，对于 `getter` 方法只使用成员名。

　　例如，在下面的程序中，`person` 包中定义了 `Person` 结构体，由于首字母大写，是可以被外部包调用的，但是其中的字段都是小写字母开头，所以并不能被访问。此时，就需要提供 `getter` 和 `setter` 方法：

　　person/person.go：

```go
package person

type Person struct {	// 外部可见
	name string	// 外部不可见
	age  int	// 外部不可见
}

func (p *Person) Name() string {	// getter
	return p.name
}

func (p *Person) SetName(newName string) {	// setter
	p.name = newName
}

func (p *Person) Age() int {	// getter
	return p.age
}

func (p *Person) SetAge(newAge int) {	// setter
	p.age = newAge
}

```

　　main.go：

```GO
package main

import (
	"fmt"
	"person"	// 导包
)

func main() {
	p := new(person.Person)	// 使用外部包类型
	p.SetName("fzy")
	p.SetAge(23)
	fmt.Println(p.Name(), p.Age())	// 调用外部包的方法
}
```

#### 继承与多重继承

　　当一个匿名类型被内嵌在结构体中时，匿名类型的可见方法也同样被内嵌，这在效果上等同于外层类型 **继承** 了这些方法：**将父类型放在子类型中来实现亚型**。

　　内嵌将一个已存在类型的字段和方法注入到了另一个类型里：匿名字段上的方法“晋升”成为了外层类型的方法。当然类型可以有只作用于本身实例而不作用于内嵌“父”类型上的方法，可以覆写方法（像字段一样）：和内嵌类型方法具有同样名字的外层类型的方法会覆写内嵌类型对应的方法。

```go
type Student struct {
	Person	// 内嵌，继承
}

type Person struct {
	name   string
	number int
}

func (P *Person) Name() {
	fmt.Println("Person: ", P.name)
}

func (s *Student) Name() {	// 覆写Name方法
	fmt.Println("Student: ", s.name)
}

func main() {
	s := Student{Person{"fzy", 11}}
	s.Name() // 调用的是接收者为Student的Name方法
}
```

　　输出结果：

```
Student:  fzy
```

　　多重继承指的是类型获得多个父类型行为的能力，它在传统的面向对象语言中通常是不被实现的（C++ 和 Python 例外）。因为在类继承层次中，多重继承会给编译器引入额外的复杂度。但是在 Go 语言中，通过在类型中嵌入所有必要的父类型，可以很简单的实现多重继承。

```go
type Person struct {
	name string
	age  int
}

type School struct {
	names string
	id    int
}

type Student struct {	// 继承Person，又继承School
	Person
	School
}

func (P *Person) Name() {	// Person的方法
	fmt.Println(P.name)
}

func (s *School) Names() {	// School的方法
	fmt.Println(s.names)
}

func main() {
	s := Student{Person{"fzy", 11}, School{"csu", 111}}
	s.Name() // 内嵌结构体上的方法可以直接在外层类型的实例
	s.Names()
}
```

　　输出结果：

```
fzy
csu
```

　　上面的例子中，定义了三个结构体，并实现了一些方法，结构体 `Student` 继承了 `Person` 和 `School` 结构体，然后也就可以调用 `Person` 和 `School` 的方法。