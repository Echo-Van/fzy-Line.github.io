---
title: Golang笔记-循环结构
tags: Golang
categories:
  - Programming language
  - Golang
abbrlink: 35077
date: 2018-08-23 15:56:59
---

<center> Golang 循环结构学习。</center>

<!--more-->

　　虽然 Go语言中没有 `while` 关键字，但是它的 `for` 语句更加灵活，可以实现其它语言中 `while` 和 `do while` 的功能。

#### 基于计数器的 for

　　基本形式：

```
for 初始化语句; 条件语句; 修饰语句 {}
```

　　这三部分组成的循环的头部，它们之间使用分号` ;` 相隔，但并不需要括号 `()` 将它们括起来。同样的，左花括号 `{` 必须和 `for` 语句在同一行，计数器的生命周期在遇到右花括号` }` 时便终止。

　　单层循环：

```go
for i := 0; i < 3; i++ {
	fmt.Println(i)
}
```

　　还可以在循环中同时使用多个计数器： 

```go
for i, j := 0, 3; i < j; i, j = i+1, j-1 {
	fmt.Println(i, j)
}
```

　　其中，`i, j = 0, 3` 是平行赋值操作。

　　多层（嵌套）循环：

```Go
for i := 0; i < 3; i++ {
    for j := 2; j > 0; j-- {
    	fmt.Println(i, j)
    }
}
```

#### 基于条件判断的 for

　　基于计数器的 `for` 也可以省略修饰语句，将其移到循环体内：

```go
for i := 0; i < 3; {
   i++
   fmt.Println(i)
}
```

　　还可以把初始化语句提到循环体前，变成没有初始化语句和修饰语句的 for 结构，那么 `;;` 便可以省略：

```go
var i = 0
for i < 3 {
	i = i + 1
	fmt.Println(i)
}
```

#### 无限循环

　　如果 for 循环的头部没有条件语句，那么就会认为条件永远为 true，因此循环体内必须有相关的条件判断以确保会在某个时刻退出循环。

```go
for {
    // 循环体
}
```

　　想要直接退出循环体，可以使用 break 语句或 return 语句直接返回 。但这两者之间有所区别，break 只是退出当前的循环体，而 return 语句提前对函数进行返回，不会执行后续的代码。

#### for-range 结构

　　Go 特有的一种的迭代结构， 可以迭代任何一个集合，包括 `array` 和 `map` 。例如，迭代 `array` ：

```go
for i, v := range 数组名{	
    // 输出索引和值，i代表索引, v代表索引位置对应的值
}
for _, v := range 数组名{
    // 仅输出值，不要使用索引时用下划线
}
```

　　示例：

```go
var array = [3]int{1, 2, 3}
for i, v := range array {
	fmt.Println(i, v)
}
```

　　输出结果：

```
0 1
1 2
2 3
```

　　要注意的是，**v 始终为集合中对应索引的值拷贝**，因此它一般只具有只读性质，对它所做的任何修改都不会影响到集合中原有的值（如果 v 为指针，则会产生指针的拷贝，依旧可以修改集合中的原值）。

　　一个字符串是 Unicode 编码的字符（或称之为 `rune`）集合，因此您也可以用它迭代字符串：

```go
var str = "abcd"
for i, v := range str {
	fmt.Printf("%d, %c\n", i, v)
}
```

　　输出结果：

```
0, a
1, b
2, c
3, d
```

　　每个 rune 字符和索引在 for-range 循环中是一一对应的。它能够自动根据 UTF-8 规则识别 Unicode 编码的字符。 