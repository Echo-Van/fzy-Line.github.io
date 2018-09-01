---
title: Golang笔记-切片
tags: Golang
categories:
  - Programming language
  - Golang
abbrlink: 44929
date: 2018-08-26 23:13:38
---

<center>Golang 切片学习</center>

<!--more-->

#### 简介

　　切片（slice）是对数组一个连续片段的引用，所以切片是一个引用类型（因此更类似于 C/C++ 中的数组类型，或者 Python 中的 list 类型）。这个片段可以是整个数组，或者是由起始和终止索引标识的一些项的子集。需要注意的是，终止索引标识的项不包括在切片内。

　　切片在内存中的组织方式实际上是一个有 3 个域的结构体：指向相关数组的指针，切片长度以及切片容量。给定项的切片索引可能比相关数组的相同元素的索引小。和数组不同的是，切片的长度可以在运行时修改，最小为 0 最大为相关数组的长度：切片是一个 **长度可变的数组**。

　　切片是可索引的，并且可以由 `len()` 函数获取长度。因为切片是引用，所以它们不需要使用额外的内存并且比使用数组更有效率，所以在 **Go 语言中切片比数组更常用**。

#### 声明与初始化

　　声明切片的格式：

```go
var identifier []type
```

　　`[]` 中不需要指定长度值，如果指定长度即为数组。一个切片在未初始化之前默认为 nil，长度为 0。声明的同时初始化：

```go
var slice []type = arr1[start:end]
```

　　这表示 `slice` 是由数组 `arr` 从 `start` 索引到 `end-1` 索引之间的元素构成的子集（切分数组，`start:end` 被称为 `slice` 表达式）。所以 `slice[0]` 就等于 `arr[start]`。

　　切片也可以用类似数组的方式初始化：

```go
var slice = []int{1, 2, 3}
```

　　另外，也可以使用简短声明并进行初始化：

```go
slice := []int{1, 2, 3}
```

　　也可以使用内置函数 `make` 创建切片，make 的使用方式是：`func make([]T, len, cap)`，其中 cap 是容量（可选参数），当只指定切片的长度时：

```go
slice := make([]string, 3)	// 长度和容量均为3
```

　　如果只指定长度，那么切片的容量和长度相等。也可以长度和容量都指定：

```go
slice := make([]string, 3, 5)	// 长度为3，容量为5
```

　　空切片与 `nil` 切片：

```go
slice := make([]int, 0)	// 长度为0的切片
var slice []int	// 初始化值为nil的切片
```

#### 切片处理

##### 赋值和切片

　　赋值操作：

```go
slice := []int{1, 2, 3, 4, 5}
slice[1] = 6	// 改变索引为1的元素的值
```

　　使用切片创建切片：

```go
slice := []int{1, 2, 3, 4, 5}
newSlice := slice[1:3]	// 长度为2，容量为4
for i, v := range newSlice {
    fmt.Println(i, v)
}
```

　　输出结果：

```
0 2
1 3
```

　　`slice` 底层数组有5个元素 , 而 `newSlice` 的底层数组容量只有4个元素，`newSlice` 看不到。但是，由于两个切片共享了底层数组，所以如果一个切片修改了底层数组的共享部分，另一个切片也会感知到。

```go
slice := []int{1, 2, 3, 4, 5}
newSlice := slice[1:3] // 长度为2，容量为4
newSlice[0] = 6
for i, v := range slice {
    fmt.Println(i, v)
}
```

　　输出结果：

```
0 1
1 6
2 3
3 4
4 5
```

##### 复制

　　如果想增加切片的容量，我们必须创建一个新的更大的切片并把原分片的内容都拷贝过来。`copy` 函数提供了这样的功能：

```go
func copy(dst, src []T) int
```

　　它将类型为 T 的切片从源地址 src 拷贝到目标地址 dst，覆盖 dst 的相关元素，并且返回拷贝的元素个数。源地址和目标地址可能会有重叠。拷贝个数是 src 和 dst 的长度最小值。如果 src 是字符串那么元素类型就是 byte。如果你还想继续使用 src，在拷贝结束后执行 `src = dst`。

```go
s := []int{1, 2, 3}
slice := make([]int, 5)
copy(slice, s)
for i, v := range slice {
    fmt.Println(i, v)
}
```

　　输出结果：

```
0 1
1 2
2 3
3 0
4 0
```

##### 增长

　　内置函数 `append` 会处理增加长度时的所有操作细节：

```GO
func append(s[]T, x ...T) []T
```

　　它将0 个或多个具有相同类型 s 的元素追加到切片后面并且返回新的切片；追加的元素必须和原切片的元素同类型。

```go
slice := make([]int, 3, 5)
slice[0] = 1
slice[1] = 2
slice[2] = 3
slice = append(slice, 4, 5) // 添加两个元素
for i, v := range slice {
    fmt.Println(i, v)
}
```

　　输出结果：

```
0 1
1 2
2 3
3 4
4 5
```

　　如果 s 的容量不足以存储新增元素，append 会分配新的切片来保证已有切片元素和新增元素的存储。因此，返回的切片可能已经指向一个不同的相关数组了。append 方法总是返回成功，除非系统内存耗尽了。

```go
slice := []int{1, 2, 3}	// 长度和容量均为3
slice = append(slice, 4, 5)	// 添加两个元素后，slice拥有一个全新的底层数组
for i, v := range slice {
	fmt.Println(i, v)
}
```

　　输出结果同上。

##### 合并

　　与增长类似，我们也可以合并两个 `slice` ，其本质是将一个 `slice` 追加到另一个的后面：

```go
slice := []int{1, 2, 3}
slice2 := []int{4, 5}
slice = append(slice, slice2...)
for i, v := range slice {
    fmt.Println(i, v)
}
```

　　输出结果同上。

#### 迭代切片

##### 传统for循环

　　内置函数 `len()` 和 `cap()` 可以用于处理数组、切片和通道，分别获取长度和容量。于是，可以使用传统 `for` 循环迭代切片：

```go
slice := []int{1, 2, 3, 4, 5}
for i := 0; i < len(slice); i++ {
    fmt.Println(i, slice[i])
}
```

　　输出结果：

```
0 1
1 2
2 3
3 4
4 5
```

##### for range

```go
slice := []int{1, 2, 3, 4, 5}
for i, v := range slice {
    fmt.Println(i, v)
}
```

　　输出结果：

```
0 1
1 2
2 3
3 4
4 5
```