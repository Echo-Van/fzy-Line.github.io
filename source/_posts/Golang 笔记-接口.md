---
title: Golang 笔记-接口
tags: Golang
categories:
  - Coding
  - Golang
abbrlink: 40865
date: 2018-09-02 20:16:21
---

<center>Golang 接口学习。</center>

<!--more-->

#### 定义与使用

　　Go 语言中没有类和继承的概念，但是它里有非常灵活的 **接口** 概念，通过它可以实现很多面向对象的特性。接口提供了一种方式来 **说明** 对象的行为：如果谁能搞定这件事，它就可以用在这儿。接口定义了一组方法（方法集），但是这些方法不包含实现代码。并且，接口里也不能包含变量。

```go
type Namer interface {
    Method1(param_list) return_type
    Method2(param_list) return_type
    ...
}
```

　　一般情况下，接口的名字由方法名加 `[e]r` 后缀组成，例如 `Printer`、`Reader`、`Writer` 等等。当后缀 `er` 不合适时，接口名也可以以 `able` 结尾，或者以 `I` 开头。Go 语言中的接口都很简短，通常它们会包含 0 个、最多 3 个方法。

　　类型（比如结构体）实现接口方法集中的方法，每一个方法的实现说明了此方法是如何作用于该类型的：**即实现接口**，同时方法集也构成了该类型的接口。实现了 `Namer` 接口类型的变量可以赋值给接收者值，此时方法表中的指针会指向被实现的接口方法。当然，如果另一个类型（也实现了该接口）的变量被赋值给接收者值，这二者也会随之改变。

　　接口具有很大的灵活性的原因：

- 类型不需要显式声明它实现了某个接口：接口被隐式地实现。
- 多个类型可以实现同一个接口，一个类型也可以实现多个接口。
- 实现某个接口的类型，除了实现接口方法外，也可以有其他的方法。
- 接口类型可以包含一个实例的引用， 该实例的类型实现了此接口（接口是动态类型）。
- 即使接口在类型之后才定义，二者处于不同的包中，被单独编译：**只要类型实现了接口中的方法，它就实现了此接口**。

```go
type School struct { // 结构体
	name string
}

type Valuer interface { // 接口
	getName() string
}

func (s *School) getName() string {
	return s.name
}

func main() {
	var v Valuer = &School{"CSU"} // 结构体变量赋值给接口变量
	fmt.Println(v.getName())      // 调用方法
}
```

　　输出结果：

```
CSU
```

　　如上，定义了一个结构体 `School` 和 一个接口 `Value` ，接口有两个方法 `getName()` 和 `getId()`，在 `main()` 函数中创建了一个 `School` 实例并赋值给了接口类型的变量，现在接口变量包含一个指向 `School` 变量的引用，通过它可以调用 `School` 上的方法 `getName()` 和 `getId()`。

　　在接口上调用方法时，必须有和方法定义时相同的接收者类型或者是可以从具体类型 `P` 直接可以辨识的：

- 指针方法可以通过指针调用
- 值方法可以通过值调用
- 接收者是值的方法可以通过指针调用，因为指针会首先被解引用
- 接收者是指针的方法不可以通过值调用，因为存储在接口中的值没有地址

　　将一个值赋值给一个接口时，编译器会确保所有可能的接口方法都可以在此值上被调用，因此不正确的赋值在编译期就会失败。

　　多态：根据当前的类型选择正确的方法，或者说：同一种类型在不同的实例上似乎表现出不同的行为。

```go
type School struct { // 结构体
	name string
}

type Student struct { // 结构体
	name string
}

type Valuer interface { // 接口
	getName() string
}

func (s *School) getName() string { // 接收者为指针类型
	return s.name
}

func (s Student) getName() string { // 接收者为值类型
	return s.name
}

func main() {
	sc := &School{"CSU"}	// 指针类型
	st := Student{"fzy"}	// 值类型
	v := []Valuer{sc, st}
	for _, vi := range v {
		fmt.Println(vi.getName())
	}
}
```

　　如上，在调用 `vi.getName()` 时，只知道 `vi` 是一个 `Valuer` 接口， 实际却是 `School` 和 `Student` 变量，并且可以调用他们所实现的方法。

#### 类型断言

##### 使用 if-type

```go
if v, ok := vi.(T); ok {  // 例如检查上面例子中的接口vi是否是类型T
    Process(v)
    return
}
// vi 不是类型 T
```

　　如果转换合法，`v` 是 `vi` 转换到类型 `T` 的值，`ok` 会是 `true`；否则 `v` 是类型 `T` 的零值，`ok` 是 `false`，也没有运行时错误发生。

##### 使用 type-switch

　　接口变量的类型也可以使用一种特殊形式的 `switch` 来检测：**type-switch**

```go
switch t := vi.(type) {
case *School:
	fmt.Printf("Type School %T with value %v\n", t, t)
case *Student:
	fmt.Printf("Type Student %T with value %v\n", t, t)
case nil:
	fmt.Printf("nil value: nothing to check?\n")
default:
	fmt.Printf("Unexpected type %T\n", t)
}
```

　　其中，变量 `t` 得到了 `vi` 的类型，然后通过 `switch` 匹配进行相应的处理。也可以用 `type-switch` 进行运行时类型分析，但是在 `type-switch` 不允许有 `fallthrough` 。

#### 测试一个值是否实现了某个接口

　　假定 `v` 是一个值，然后我们想测试它是否实现了上面的 `Valuer` 接口，可以这样做：

```GO
type Valuer interface {
    getName() string
	getId() int
}

if _, ok := v.(Valuer); ok {
    // v 实现了 Valuer 接口
    fmt.Println(v.getName(), v.getId())
}
```

　　接口是一种契约，实现类型必须满足它，它描述了类型的行为，规定类型可以做什么。接口彻底将类型能做什么，以及如何做分离开来，使得相同接口的变量在不同的时刻表现出不同的行为，这就是多态的本质。

#### 空接口

　　**空接口或者最小接口** 不包含任何方法，它对实现不做任何要求：

```go
type Any interface {}
```

　　任何其他类型都实现了空接口（它不仅仅像 `Java/C#` 中 `Object` 引用类型），`any` 或 `Any` 是空接口一个很好的别名或缩写。

　　空接口类似 `Java/C#` 中所有类的基类： `Object` 类，二者的目标也很相近。可以给一个空接口类型的变量赋任何类型的值。

　　构建通用类型或包含不同类型变量的数组：

```go
type Element interface{}

type Vector struct {
	a [10]Element
}

func (p *Vector) At(i int) Element {
	return p.a[i]
}

func (p *Vector) Set(i int, e Element) {
	p.a[i] = e
}

func main() {
	v := new(Vector)
	v.Set(0, "fzy")
	v.Set(1, 111)
	fmt.Println(v.At(0), v.At(1))
}
```

　　输出结果：

```
fzy 111
```