---
title: Golang 笔记-JSON操作
tags: Golang
categories:
  - Coding
  - Golang
abbrlink: 4110
date: 2019-06-08 09:56:20
---

<center>Golang JSON操作学习</center>

<!--more-->

　　JSON 是一种轻量级的数据交换格式，它表示的对象就是标准的 JavaScript 语言的对象，采用完全独立于编程语言的文本格式来存储和表示数据。

#### JSON简介

　　如果想要在不同的编程语言之间传递对象，就必须把对象序列化为标准格式，比如 XML，但更好的方法是序列化为 JSON，因为 JSON 表示出来就是一个字符串，可以被所有语言读取，也可以方便地存储到磁盘或者通过网络传输。JSON 不仅是标准格式，并且比 XML 更轻量级、更快，而且可以直接在 Web 页面中读取，非常方便。

　　JSON 语法是 JavaScript 对象表示法语法的子集。数据在名称/值对中、数据由逗号分隔、花括号保存对象、方括号保存数组。JSON 值可以是：数字（整数或浮点数）、字符串（在双引号中）、逻辑值（true 或 false）、数组（在方括号中）、对象（在花括号中）、null。

#### 序列化

　　把变量从内存中变成可存储或传输的过程称之为序列化，即把对象转换为字节序列。把 struct 、map 或 slice 转换成 json 就是序列化操作。

- struct 转 json

```go
package main

import (
	"encoding/json"
	"fmt"
)

type Student struct {
	Name string
	School string
	Class string
	Number int
}

func main() {
	st := Student{"Peter", "CSU", "12",111111}

	result, err := json.Marshal(st)
	if err != nil {
		fmt.Println("序列化错误......")
		return
	}

	fmt.Println("struct序列化结果为：", string(result))
}

```

　　输出结果：

```
struct序列化结果为： {"Name":"Peter","School":"CSU","Class":"12","Number":111111}
```

- map 转 json

```go
package main

import (
	"encoding/json"
	"fmt"
)

func main() {
	mp := make(map[string]int)
	mp["chinese"] = 99
	mp["math"] = 90
	mp["english"] = 92
    
	result, err := json.Marshal(mp)
	if err != nil {
		fmt.Println("序列化错误......")
		return
	}
    
	fmt.Println("map序列化结果为：", string(result))
}
```

　　输出结果：

```
map序列化结果为： {"chinese":99,"english":92,"math":90}
```

- slice 转 json

```go
package main

import (
	"encoding/json"
	"fmt"
)

func main() {
	score := []int{88, 92, 98}
    
	result, err := json.Marshal(score)
	if err != nil {
		fmt.Println("序列化错误......")
		return
	}
    
	fmt.Println("slice序列化结果为：", string(result))
}
```

　　输出结果：

```
slice序列化结果为： [88,92,98]
```

#### 反序列化

　　把字节序列恢复为对象的过程称为对象的反序列化。反序列化时，要确保反序列化后的数据类型和原来序列化前的数据类型一致。

- json 转 struct

```go
package main

import (
	"encoding/json"
	"fmt"
)

type Student struct {
	Name   string
	School string
	Class  string
	Number int
}

func main() {
	str := "{\"Name\":\"Peter\",\"School\":\"CSU\",\"Class\":\"12\",\"Number\":111111}"
	var st Student
    
	err := json.Unmarshal([]byte(str), &st)
	if err != nil {
		fmt.Println("序列化错误......")
		return
	}
    
	fmt.Printf("json反序列化为struct, 类型为：%T, 值为：%v", st, st)
}
```

　　输出结果：

```
json反序列化为struct, 类型为：main.Student, 值为：{Peter CSU 12 111111}
```

- json 转 map

```go
package main

import (
	"encoding/json"
	"fmt"
)

func main() {
	str := "{\"chinese\":99,\"english\":92,\"math\":90}"
    // 反序列化map不需要make，因为make操作被封装到了Unmarshal中
	var mp map[string]int
    
	err := json.Unmarshal([]byte(str), &mp)
	if err != nil {
		fmt.Println("序列化错误......")
		return
	}
    
	fmt.Printf("json反序列化为map, 类型为：%T, 值为：%v", mp, mp)
}
```

　　输出结果：

```
json反序列化为map, 类型为：map[string]int, 值为：map[chinese:99 english:92 math:90]
```

- json 转 slice

```go
package main

import (
	"encoding/json"
	"fmt"
)

func main() {

	str := "[88,92,98]"
    // 反序列化slice也不需要make，因为make操作被封装到了Unmarshal中
	var sl []int
    
	err := json.Unmarshal([]byte(str), &sl)
	if err != nil {
		fmt.Println("序列化错误......")
		return
	}
    
	fmt.Printf("json反序列化为map，类型为：%T, 值为：%v", sl, sl)
}
```

　　