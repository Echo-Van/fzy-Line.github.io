---
title: Golang 笔记-Map
tags: Golang
categories:
  - Coding
  - Golang
abbrlink: 2734
date: 2018-08-27 21:08:55
---

<center>Golang Map 学习。</center>

<!--more-->

#### map 简介

　　`map` 是一种特殊的数据结构：一种元素对（pair）的无序集合，pair 的一个元素是 `key`，对应的另一个元素是 `value`，所以这个结构也称为关联数组或字典。这是一种快速寻找值的理想结构：给定 `key`，对应的 `value` 可以迅速定位。在其他编程语言中 `map` 也称为字典（Python）、hash 和 HashTable 等。

　　`map` 中所有的 `key` 都拥有相同的数据类型，同时所有的 `value` 也拥有相同的数据类型，但 `key` 和 `value` 的类型不一定一样。

　　`key` 可以是任意可以用 `==` 或者 `!=` 操作符比较的类型，比如 `string`、`int`、`float`。所以数组、切片和结构体不能作为 `key` (含有数组切片的结构体不能作为 `key`，只包含内建类型的 `struct` 是可以作为 `key` 的），但是指针和接口类型可以。

　　通过 `key` 在 `map` 中寻找值是很快的，比线性查找快得多，但是仍然比从数组和切片的索引中直接读取要慢 100 倍。 

　　由于 `map` 使用了散列表，所以即使使用相同的顺序保存键值对，每次迭代 `map` 的时候顺序也有可能不一样。因此，`map` 是一个存储键值对的无序集合。

#### 声明与初始化

　　在声明的时候不需要知道 `map` 的长度，`map` 是可以动态增长的。未初始化的 `map` 的值是 `nil`。`map` 是 **引用类型** 的： 内存用 `make` 方法来分配。`map` 的初始化：

```go
var map1 = make(map[keytype]valuetype)
```

　　或者使用简短声明：

```go
map1 := make(map[keytype]valuetype)
```

　　也可以使用 `map` 的字面量来创建并初始化：

```go
map1 := map[keytype]valuetype{key:  value, key : value, ......}
```

　　举例：

- 使用 `make`：

```go
ages := make(map[string]int)
fmt.Println(ages["Tom"])	// 没有赋值，实际上根本不存在这个键
```

　　输出结果：

```
0
```

- 使用字面量：

```GO
ages := map[string]int{"Jack": 20, "Tom": 18}
fmt.Println(ages["Tom"])
```

　　输出结果：

```
18
```

　　和数组不同，`map` 可以根据新增的 `key-value` 对动态的伸缩，因此它不存在固定长度或者最大限制。但是你也可以选择标明 `map` 的初始容量 `capacity` ：

```
make(map[keytype]valuetype, cap)
```

　　当 `map` 增长到容量上限的时候，如果再增加新的 `key-value` 对，`map` 的大小会自动加 1。所以出于性能的考虑，对于大的 `map` 或者会快速扩张的 `map`，即使只是大概知道容量，也最好先标明。

#### map 操作

##### 赋值

```go
ages := make(map[string]int)
ages["Jack"] = 20	// 赋值
ages["Tom"] = 18
fmt.Println(ages["Tom"])
```

##### 测试键值对是否存在

```
value, isPresent := map[key]
```

　　`isPresent` 返回一个 `bool` 值：如果 `key` 存在于 `map`，`value` 就是 `key` 对应的 `value` 值，并且 `isPresent` 为 `true`；如果 `key` 不存在，`value` 就是一个空值，并且 `isPresent` 会返回 `false`。 

　　比如前面的例子中：

```go
ages := make(map[string]int)
value, isPresent := ages["Tom"]	// 没有赋值
fmt.Println(value, isPresent)
```

　　输出结果：

```go
0 false
```

　　和 if 混合使用： 

```go
if _, ok := map[key]; ok {
	// 如果存在...
}
```

##### 删除键值对

　　`delete()` 函数用于删除集合的元素, 参数为 `map` 和其对应的 `key`。

```go
delete(map, key)
```

　　即使键不在 `map` 中，上面的操作也是安全的。`map` 使用给定的键来查找元素，如果键对应的元素不存在，就返回值类型的零值。

#### map 迭代

　　使用 `for-range` 结构遍历 `map`，第一个返回值 `key` 是 `map` 中的 `key` 值，第二个返回值则是该 `key` 对应的 `value` 值；这两个都是仅 `for` 循环内部可见的局部变量。 

```GO
ages := map[string]int{"Jack": 20, "Tom": 18}
for key, value := range ages {
    fmt.Println(key, value)
}
```

　　输出结果：

```
Jack 20
Tom 18
```

　　只获取值：

```go
for _, value := range ages {
    fmt.Println(value)
}
```

　　输出结果：

```
18
20
```

　　注意 `map` 不是按照 `key` 的顺序排列的，也不是按照 `value` 的序排列的，有可能每次打印的输出结果顺序都不同，所以这里并没有按上面的顺序打印。

　　只获取键：

```go
for key := range ages {
    fmt.Println(key)
}
```

　　输出结果：

```
Jack
Tom
```

#### map 排序

　　`map` 默认是无序的，不管是按照 `key` 还是按照 `value` 默认都不排序。如果要为 `map` 排序，需要将 `key`（或者 `value`）拷贝到一个切片，再对切片排序，然后可以使用切片的 `for-range` 方法打印出所有的 `key` 和 `value`。

　　按值排序，即把值拷贝到切片，然后再对切片进行排序：

```go
ages := map[string]int{"Jack": 20, "Tom": 18, "Ada": 28, "Peter": 30}
keys := make([]string, len(ages))
i := 0
for k, _ := range ages {	// 把键拷贝到切片
    keys[i] = k
    i++
}
sort.Strings(keys)	// 按键排序
for _, k := range keys {	// 按键排序后的顺序输出
    fmt.Println(k, ages[k])
}
```

　　输出结果：

```
Ada 28
Jack 20
Peter 30
Tom 18
```

　　按键排序，即把键拷贝到切片，然后再对切片进行排序：

```go
ages := map[string]int{"Jack": 20, "Tom": 18, "Ada": 28, "Peter": 30}
values := make([]int, len(ages))
i := 0
for _, v := range ages {
    values[i] = v	// 把值拷贝到切片
    i++
}
sort.Ints(values)	// 按值排序
for _, v := range values {	// 输出排序结果
    fmt.Println(v)
}
```

　　输出结果：

```
18
20
28
30
```