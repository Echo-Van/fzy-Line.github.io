---
title: Golang 笔记-分支结构
tags: Golang
categories:
  - Coding
  - Golang
abbrlink: 47017
date: 2018-08-22 21:39:08
---

<center>Golang 分支结构学习。</center>

<!--more-->

#### if-else

　　与其它语言的 `if-else` 没有什么区别。其中，条件语句不需要括号。

```go
if condition1 {
	// do something	
} else if condition2 {
	// do something else	
} else {
	// catch-all or default
}
```

　　需要注意的是：

- 即使当代码块之间只有一条语句时，大括号也不可被省略 
- **关键字 if 和 else 之后的左大括号 `{` 必须和关键字在同一行**，如果你使用了 `else-if` 结构，则前段代码块的右大括号 `}` 必须和 `else-if` 关键字在同一行。这两条规则都是被编译器强制规定的。
- 当条件比较复杂时，则可以使用括号让代码更易读。条件允许是符合条件，需使用 `&&、|| 或 !`，你可以使用括号来提升某个表达式的运算优先级，并提高代码的可读性。 

　　`if` 可以包含一个初始化语句。这种写法具有固定的格式（在初始化语句后方必须加上分号）： 

```go
if initialization; condition {
	// do something
}
```

　　例如：

```go
val := 10
if val > max {
	// do something
}

可以写为:

if val := 10; val > max {
	// do something
}
```

　　**注意**：使用简短方式 `:=`声明的变量的作用域只存在于 `if` 结构中（在 `if` 结构的大括号之间，如果使用 `if-else` 结构则在 `else` 代码块中变量也会存在）。如果变量在 `if` 结构之前就已经存在，那么在 `if` 结构中，该变量原来的值会被隐藏。最简单的解决方案就是不要在初始化语句中声明变量。

#### switch

　　相比较 C 和 Java 等其它语言而言，Go 语言中的 `switch` 结构使用上更加灵活。首先，`case` 中不需要`break` ，其次，它接受任意形式的表达式：

```go
switch var1 {
	case val1:
		...
	case val2:
		...
	default:
		...
}
```

　　变量 var1 可以是任何类型，而 val1 和 val2 则可以是同类型的任意值。类型不被局限于常量或整数，但必须是相同的类型；或者最终结果为相同类型的表达式。前花括号 { 必须和 `switch` 关键字在同一行。也可以同时测试多个可能符合条件的值，使用逗号分割它们，例如：`case val1, val2, val3`。

　　每一个 `case` 分支都是唯一的，从上至下逐一测试，直到匹配为止。一旦成功地匹配到某个分支，在执行完相应代码后就会退出整个 `switch` 代码块，也就是说您**不需要特别使用 break 语句**来表示结束。如果在执行完每个分支的代码后，还**希望继续执行后续分支的代码，可以使用 fallthrough 关键字**来达到目的。注意，相邻的空 `case` 块不构成多条件匹配。如下：

```go
switch i {
	case 0: // 空分支，只有当 i == 0 时才会进入分支
	case 1:
		f() // 当 i == 0 时函数不会被调用
}


switch i {
	case 0: fallthrough
	case 1:
		f() // 当 i == 0 时函数也会被调用
}
```

　　`switch` 语句也可以不提供任何被判断的值（实际上默认为判断是否为 true），然后在每个 case 分支中进行测试不同的条件。当任一分支的测试结果为 true 时，该分支的代码会被执行。这看起来非常像链式的 `if-else 语句，但是在测试条件非常多的情况下，提供了可读性更好的书写方式。

```go
switch {
	case condition1:
		...
	case condition2:
		...
	default:
		...
}
```

　　`switch` 语句还包含一个初始化语句：

```go
switch initialization {
	case val1:
		...
	case val2:
		...
	default:
		...
}
```

　　与其他语言一样，用 `default` 可以指定当其他所有分支都不匹配的时候的行为。