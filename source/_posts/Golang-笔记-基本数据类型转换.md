---
title: Golang 笔记-基本数据类型转换
tags: Golang
categories:
  - Coding
  - Golang
abbrlink: 37715
date: 2019-05-30 09:33:54
---

<center>Golang 基本数据类型转换学习</center>

<!--more-->

#### 基本数据类型之间的转换

　　Go 在不同类型的变量之间赋值时需要显示转换，即 Go 语言中数据类型不能自动转换。

```go
T(v) // 将值v转换为类型T
```

　　注意事项：

- 数据类型转换可以从表示范围小--->表示范围大，也可以范围大到范围小。
- 范围大到范围小的转换时，可能会出现结果溢出，但是不会报错。因此转换时，需要考虑范围。

　　示例：

```go
package main
import "fmt"

func main() {
	var i = 1000
	i64 := int64(i)
	fmt.Printf("%T %d\n", i64, i64)
	f := float64(i)
	fmt.Printf("%T %f\n", f, f)
	i8 := int8(i)
	fmt.Printf("%T %d\n", i8, i8)
}
```

　　结果：

```
int64 1000
float64 1000.000000
int8 -24
```

#### 基本数据类型转 String

##### fmt.Sprintf

　　格式化函数 Sprintf 根据 format 参数生成格式化的字符串并返回该字符串：

```go
func Sprintf(format string, a ...interface{}) string
```

- 格式化样式：字符串形式，格式化动词以`%`开头。
- 参数列表：多个参数以逗号分隔，个数必须与格式化样式中的个数一一对应，否则运行时会报错。

　　示例：

```go
package main
import "fmt"

func main() {
	// 整型转字符串
	var i = 10
	iTos := fmt.Sprintf("%v", i)
	fmt.Printf("%T, %q\n", iTos, iTos)

	// 浮点型转字符串
	var f = 23.23
	fTos := fmt.Sprintf("%v", f)
	fmt.Printf("%T, %q\n", fTos, fTos)

	// 字节型转字符串
	var c byte = 'a'
	cTos := fmt.Sprintf("%v", c)
	fmt.Printf("%T, %q\n", cTos, cTos)

	// 布尔型转字符串
	var b bool = true
	bTos := fmt.Sprintf("%v", b)
	fmt.Printf("%T, %q\n", bTos, bTos)
}
```

　　结果：

```
string, "10"
string, "23.23"
string, "97"
string, "true"
```

##### strconv

　　使用 `strconv` 包中的函数：

- 整型转字符串

```go
func FormatInt(i int64, base int) string
func Itoa(i int) string	// FormatInt的缩写
func FormatUint(i uint64, base int) string
```

　　返回 `i` 的 `base` 进制的字符串表示。`base` 必须在 2 到 36 之间，结果中会使用小写字母 `'a'` 到 `'z'` 表示大于 10 的数字。

- 浮点型转字符串

```go
func FormatFloat(f float64, fmt byte, prec, bitSize int) string
```

　　函数将浮点数表示为字符串并返回。`bitSize` 表示 `f` 的来源类型（32：float32、64：float64），会据此进行舍入。`fmt` 表示格式：`'f'（-ddd.dddd）`、`'b'（-ddddp±ddd，指数为二进制）`、`'e'（-d.dddde±dd，十进制指数）`、`'E'（-d.ddddE±dd，十进制指数）`、`'g'（指数很大时用'e'格式，否则'f'格式）`、`'G'（指数很大时用'E'格式，否则'f'格式）`。`prec` 控制精度（排除指数部分）：对 `'f'、'e'、'E'`，它表示小数点后的数字个数；对 `'g'、'G'`，它控制总的数字个数。如果 `prec` 为 -1，则代表使用最少数量的、但又必需的数字来表示 `f`。

- 布尔型转字符串

```GO
func FormatBool(b bool) string
```

　　示例：

```go
package main
import "strconv"

func main() {
	// 整型转字符串
	var i = 10	// 默认类型为int
	iTos := strconv.FormatInt(int64(i), 10)	// 注意，传入参数的类型必须匹配
	fmt.Printf("%T, %q\n", iTos, iTos)

	// 浮点型转字符串
	var f = 23.23	// 默认类型为float64
	fTos := strconv.FormatFloat(f, 'f', 4, 64)
	fmt.Printf("%T, %q\n", fTos, fTos)

	// 布尔型转字符串
	var b = true
	bTos := strconv.FormatBool(b)
	fmt.Printf("%T, %q\n", bTos, bTos)
}
```

　　结果：

```
string, "10"
string, "23.2300"
string, "true"
```

#### String 转基本数据类型

##### strconv

　　使用 `strconv` 包中的函数：

- 字符串转整型

```go
func ParseInt(s string, base int, bitSize int) (i int64, err error)
func ParseUint(s string, base int, bitSize int) (n uint64, err error)
func Atoi(s string) (i int, err error)
```

　　`ParseInt` 返回字符串表示的整数值，接受正负号。`ParseUint` 则不接受正负号，用于无符号整型。`base` 指定进制（2 到 36），如果 base 为 0，则会从字符串前置判断，"0x" 是 16 进制，"0"是 8 进制，否则是 10 进制；`bitSize` 指定结果必须能无溢出赋值的整数类型，`0、8、16、32、64` 分别代表 `int、int8、int16、int32、int64`；返回的 err 是 *NumErr 类型的，如果语法有误，err.Error = ErrSyntax；如果结果超出类型范围err.Error = ErrRange。

- 字符串转浮点型

```GO
func ParseFloat(s string, bitSize int) (f float64, err error)
```

　　`ParseFloat` 解析一个表示浮点数的字符串并返回其值。`bitSize` 指定转换结果的类型，32 是 `float32`（返回值可以不改变精确值的赋值给 float32），64 是 `float64`；返回值 err 是 *NumErr 类型的，语法有误的，err.Error=ErrSyntax；结果超出表示范围的，返回值 f 为 ±Inf，err.Error= ErrRange。

- 字符串转布尔型

```go
func ParseBool(str string) (value bool, err error)
```

　　`ParseBool` 返回字符串表示的 `bool` 值。它接受 `1、0、t、f、T、F、true、false、True、False、TRUE、FALSE`，否则返回错误。

　　示例：

```go
package main
import "strconv"

func main() {
	// 字符串转整型
	var is = "100"
	sToi, _ := strconv.ParseInt(is, 10, 32)
	fmt.Printf("%T, %d\n", sToi, sToi)

	// 字符串转浮点型
	var fs = "23.23"
	sTof, _ := strconv.ParseFloat(fs, 32)
	fmt.Printf("%T, %f\n", sTof, sTof)

	// 字符串转布尔型
	var bs = "true"
	sTob, _ := strconv.ParseBool(bs)
	fmt.Printf("%T, %t\n", sTob, sTob)
}
```

　　结果：

```
int64, 100
float64, 23.230000
bool, true
```