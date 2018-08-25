---
title: Golang笔记-函数
tags: Golang
categories:
  - Programming language
  - Golang
abbrlink: 41153
date: 2018-08-25 17:46:23
---

<center>Golang 函数学习</center>

<!--more--> 

#### 定义与声明

　　函数是基本的代码块。Go 是编译型语言，所以函数编写的顺序是无关紧要的；鉴于可读性的需求，最好把 `main()` 函数写在文件的前面，其他函数按照一定逻辑顺序进行编写（例如函数被调用的顺序）。 Go 语言函数定义格式如下：

```go
func function_name( [parameter list] ) [return_types]
{
   // 函数体
}
```

　　函数由关键字 `func` 开始声明，参数列表指定的是参数类型、顺序、及参数个数。参数是可选的，也就是说函数也可以不包含参数。返回类型，函数返回一列值。return_types 是该列值的数据类型。例如：

```go
func sum(a int, b int) int{
	return a + b
}
```

　　Go 里面有三种类型的函数：

- 普通的带有名字的函数
- 匿名函数或者lambda函数（后续博客介绍）
- 方法（后续博客介绍）

　　函数被调用的基本格式如下： 

```go
pack.Function(arg1, arg2, …, argn)
```

　　其中，Function 是 pack 包中的函数，括号里的是被调用函数的实参。同文件内函数调用不要加包名。

　　**注意**：函数重载指的是可以编写多个同名函数，只要它们拥有不同的形参与/或者不同的返回值，在 Go 里面函数重载是不被允许的。

#### 参数与返回值

　　除了main()、init()函数外，其它所有类型的函数都可以有参数与返回值。

##### 参数列表

　　函数如果使用参数，该变量可称为函数的形参。形参就像定义在函数体内的局部变量。

```go
func sum(a int, b int) int{
	return a + b
}
```

　　参数类型相同的情况：

```go
func sum(a, b int) int{
	return a + b
}
```

　　可变长参数：

```go
func main() {
	var x, y, z = 1, 2, 3
	a := sum(x)
	b := sum(x, y)
	c := sum(x, y, z)
	fmt.Println(a, b, c) // 输出1 3 6
}

func sum(a ...int) (sum int) {	// 使用可变长参数
	for _, v := range a {	// 使用for range迭代可变长参数
		sum += v
	}
	return
}
```

##### 值传递

　　Go 默认使用按值传递来传递参数，也就是传递参数的副本。函数接收参数副本之后，在使用变量的过程中可能对副本的值进行更改，但不会影响到原来的变量。

```go
func main() {
	var x, y = 1, 2
	a, b := exchange(x, y) // 传值
	fmt.Println(a, b)      // 输出2, 1
}

func exchange(a, b int) (x, y int) {
	x, y = b, a
	return
}
```



##### 引用传递

　　如果需要直接修改参数的值，而不是对参数的副本进行操作，你需要将参数的地址（变量名前面添加 `&` 符号）传递给函数，这就是按引用传递。

```go
func main() {
	var x, y = 1, 2
	exchange(&x, &y)  // 传地址
	fmt.Println(x, y) // 输出2 1
}

func exchange(a, b *int) {
	// 由于传入的是地址，所以如果在函数内修改a,b的值，x,y的值也会改变
	*a, *b = *b, *a
}
```



　　传递指针给函数不但可以节省内存（因为没有复制变量的值），而且赋予了函数直接修改外部变量的能力，所以被修改的变量不再需要使用 `return` 返回。**几乎在任何情况下，传递指针（一个32位或者64位的值）的消耗都比传递副本来得少。** （具体案例将在后续博客中介绍）



##### 返回值

　　有返回值的函数，一般必须有明确的 `return` 语句。返回值可命名也可不命名，命名的返回值和参数一样可以当作局部变量使用。例如：

```gO
func sum(a, b int) int {
	return a + b
}
```

　　返回值命名后，`return` 可以写成显式也可以隐式。

```go
func sum(a, b int) (z int) {
	z = a + b
	return z	// 显式
    // return 也可以没有z 隐式返回
}
```

　　Go 语言可以返回零个或多个值，相比与 C、C++、Java 和 C#，多值返回是 Go 的一大特性，为我们判断一个函数是否正常执行提供了方便。Go 语言的函数经常使用两个返回值来表示执行是否成功：返回某个值以及 `true` 表示成功；返回零值（或 `nil`）和 `false` 表示失败。

```go
var orig string = "ABC"
// var orig string	// 会发生错误
an, err := strconv.Atoi(orig)
if err != nil {	// 判断是否转换成功
	fmt.Printf("orig %s is not an integer - exiting with error\n", orig)
	return
} 
```

　　如上，我们使用 `strconv` 包中的 `Atoi` 函数将一个字符串转换为一个整数，如果转换成功则 `err` 返回 `nil` 否则返回具体的错误类型。那么我们就可以通过判断 `err` ，如果确实存在错误，则会打印相应的错误信息然后通过 return 提前结束函数的执行。

#### defer

　　关键字 `defer` 允许我们推迟到函数返回之前（或任意位置执行 `return` 语句之后）一刻才执行某个语句或函数。

```go
func main() {
	defer fmt.Println("world")
	fmt.Println("Hello")
}    
```

　　输出结果：

```
Hello
world
```

　　关键字 `defer` 允许我们进行一些函数执行完成后的收尾工作，一般用于释放某些已分配的资源：

- 关闭文件流
- 解锁一个加锁的资源
- 关闭数据库连接
- ......

　　当有多个 defer 行为被注册时，它们会以逆序执行（类似栈，即后进先出）：

```go
for i := 0; i < 5; i++ {
	defer fmt.Printf("%d ", i)
}
```

　　输出结果：

```
4 3 2 1 0
```

#### 内置函数

　　Go 语言拥有一些不需要进行导入操作就可以使用的内置函数：

| 名称               | 说明                                                         |
| ------------------ | ------------------------------------------------------------ |
| close              | 用于管道通信                                                 |
| len、cap           | len 用于返回某个类型的长度或数量（字符串、数组、切片、map 和管道）；cap 是容量的意思，用于返回某个类型的最大容量（只能用于切片和 map） |
| new、make          | new 和 make 均是用于分配内存：new 用于值类型和用户定义的类型，如自定义结构，make 用于内置引用类型（切片、map 和管道）。它们的用法就像是函数，但是将类型作为参数：new(type)、make(type)。new(T) 分配类型 T 的零值并返回其地址，也就是指向类型 T 的指针。它也可以被用于基本类型：`v := new(int)`。make(T) 返回类型 T 的初始化之后的值，因此它比 new 进行更多的工作**new() 是一个函数，不要忘记它的括号** |
| copy、append       | 用于复制和连接切片                                           |
| panic、recover     | 两者均用于错误处理机制                                       |
| print、println     | 底层打印函数，在部署环境中建议使用 fmt 包                    |
| complex、real imag | 用于创建和操作复数                                           |