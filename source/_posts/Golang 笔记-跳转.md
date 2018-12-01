---
title: Golang 笔记-跳转
tags: Golang
categories:
  - Coding
  - Golang
abbrlink: 23548
date: 2018-08-23 20:48:56
---

<center> Golang 跳转学习。</center>

<!--more-->

#### break 与 continue

##### break

　　`break` 的作用范围为该语句出现后的最内部的结构，它可以被用于任何形式的 `for` 循环（计数器、条件判断等）。但在 `switch` 或 `select` 语句中，`break` 语句的作用结果是跳过整个代码块，执行后续的代码。

　　`break` 只会退出最内层的循环： 

```go
for i := 0; i < 3; i++ {
    for j := 0; j < 8; j++ {
        if j > 4 {
        	break
        }
        fmt.Print(j)
    }
    fmt.Println("")
}
```

　　输出结果：

```
01234
01234
01234
```

##### continue

　　关键字 `continue` 忽略剩余的循环体而直接进入下一次循环的过程，但不是无条件执行下一次循环，执行之前依旧需要满足循环的判断条件。 注意：`continue` 关键字只能用在 `for` 循环中。

```go
for i := 0; i < 10; i++ {
    if i == 5 {
    	continue
    }
    fmt.Print(i)
    fmt.Print(" ")
}
```

　　输出结果：

```
0 1 2 3 4 6 7 8 9
```

#### label 与 goto

　　`for、switch` 或 `select` 语句都可以配合标签（`LABEL`）形式的标识符使用，即某一行第一个以冒号（:）结尾的单词（`gofmt` 会将后续代码自动移至下一行）。

```go
// LABEL: 标签放在这里会造成死循环
	for i := 0; i < 3; i++ {
		for j := 0; j < 8; j++ {
			if j > 4 {
				goto LABEL
			}
			fmt.Print(j)
		}
		fmt.Println("")
	}
LABEL:
	fmt.Println("\nLABEL......")
```

　　输出结果：

```
01234
LABEL......
```

　　`goto LABEL`的 `LABEL` (标签) 既可以定义在for循环前面，也可以定义在for循环后面，当跳转到标签地方时，继续执行标签下面的代码。

　　**特别注意：** 使用标签和 `goto` 语句是不被鼓励的：它们会很快导致非常糟糕的程序设计，而且总有更加可读的替代方案来实现相同的需求。 如果必须使用 `goto`，应当只使用正序的标签（标签位于 `goto` 语句之后），但注意标签和 `goto` 语句之间不能出现定义新变量的语句，否则会导致编译失败。 

　　`break` 、 `continue` 也可以和 `LABEL` 结合来使用实现跳转到指定的目标层级：

　　`break` + `LABEL` 跳出外层循环，`break` 的跳转标签( `LABEL` )必须放在循环语句 `for` 前面，并且在`break` `LABEL` 跳出循环不再执行 `for` 循环里的代码：

```go
LABEL:
	for i := 0; i < 3; i++ {
		for j := 0; j < 10; j++ {
			if j > 5 {
				break LABEL
			}
			fmt.Print(j)
		}
		fmt.Println("")
	}
	fmt.Println("\nLABEL......")
```

　　输出结果：

```
012345
LABEL......
```

　　`break` + `LABEL` 实现跳出内层循环：

```go
LABEL:
	for i := 0; i < 3; i++ {
		for j := 0; j < 8; j++ {
			if j > 4 {
				continue LABEL
			}
			fmt.Print(j)
		}
		fmt.Println("")	// LABEL在外层，该语句不会被执行
	}
	fmt.Println("\nLABEL......")
```

　　输出结果：

```
012340123401234
LABEL......
```

　　`continue` 的跳转标签( `LABEL` )也必须放在循环语句 `for` 前面，`continue` + `LABEL` 实现与 `break` 一样的功能：

```go
for i := 0; i < 3; i++ {
    LABEL:
    for j := 0; j < 8; j++ {
        if j > 4 {
            continue LABEL
        }
        fmt.Print(j)
    }
    fmt.Println("")	// LABEL在这一层，该语句会执行
}
fmt.Println("\nLABEL......")
```

　　输出结果：

```
01234
01234
01234

LABEL......
```