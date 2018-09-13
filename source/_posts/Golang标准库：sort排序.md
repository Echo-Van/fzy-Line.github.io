---
title: Golang标准库：sort排序
tags: Golang
categories:
  - Programming language
  - Golang
abbrlink: 55136
date: 2018-09-13 15:27:40
---

<center>Golang 标准库 sort 排序学习。</center>

<!--more-->

<br>

　　sort包中实现了３种基本的排序算法：插入排序．快排和堆排序，但是这三种方式都只在sort包内部使用，所以用户在使用sort包进行排序时无需考虑使用那种排序方式，sort包会根据实际数据自动选择高效的排序算法。

#### 基本方法

　　排序(接口)的三个要素： 

- 待排序元素个数 n ； 
- 第 i 和第 j 个元素的比较函数 cmp ；
- 第 i 和 第 j 个元素的交换 swap ；

　　sort 包中有一个 sort.Interface 接口，该接口有三个方法 `Len()`  、 `Less(i,j int) `和 `Swap(i,j int) ` ，如下：

```Go
type Interface interface {
    // Len方法返回集合中的元素个数
    Len() int
    // Less方法报告索引i的元素是否比索引j的元素小
    Less(i, j int) bool
    // Swap方法交换索引i和j的两个元素
    Swap(i, j int)
}
```

　　任何实现了 `sort.Interface` 的类型（一般为集合），均可调用该包的 `Sort()` 方法进行排序。这些方法要求集合内列出元素的索引为整数。通用排序函数 `sort.Sort` 可以排序任何实现了 `sort.Inferface` 接口的对象(变量)。方法定义如下：

```go
func Sort(data Interface)	# 排序data，不保证稳定性
func Stable(data Interface)	# 排序data，保证稳定性
func Reverse(data Interface) Interface	# Reverse包装一个Interface接口并返回一个新的Interface接口，对该接口排序可生成递减序列
func IsSorted(data Interface) bool	# 报告data是否已经被排序
func Search(n int, f func(int) bool) int	# 采用二分法搜索找到[0, n)区间内最小的满足f(i)==true的值i
```

#### 基本类型排序

　　`sort` 包原生支持 `[]int` 、 `[]float64` 和 `[]string` 三种内建数据类型切片的排序操作，不仅提供了一些特殊的方法，还针对每种类型实现了相应的 `sort.Interface` 接口，即不必我们自己实现相关的 `Len()`、`Less()` 和 `Swap()` 方法。

##### 整型切片排序

　　`sort` 包提供了针对整型切片的如下方法：

```go
func Ints(a []int)	# 将 a 排序为递增顺序
func IntsAreSorted(a []int) bool	# 判断 a 是否已排序为递增顺序。
func SearchInts(a []int, x int) int	# 在递增顺序的 a 中搜索 x，返回 x 的索引。如果查找不到，返回值是 x 应该插入 a 的位置（以保证 a 的递增顺序），返回值可以是len(a)。
```

　　排序示例：

```go
s := []int{5, 2, 6, 3, 1, 4}
fmt.Println("是否已排序：", sort.IntsAreSorted(s))
sort.Ints(s)
fmt.Println("元素 3 的升序排序后索引为：", sort.SearchInts(s, 3))
fmt.Println("是否已排序：", sort.IntsAreSorted(s))
fmt.Println(s)
```

　　输出结果：

```
是否已排序： false
元素 1 的升序排序后索引为： 2
是否已排序： true
[1 2 3 4 5 6]
```

　　除了使用特殊指定的函数外，还可以使用改装过的类型 `IntSclice` 类型， 然后直接调用它们对应的`Sort() `方法，因为这种类型也实现了 ` sort.Interface` 接口：

```go
type IntSlice []int
    - func (p IntSlice) Len() int
    - func (p IntSlice) Less(i, j int) bool
    - func (p IntSlice) Search(x int) int
    - func (p IntSlice) Sort()
    - func (p IntSlice) Swap(i, j int)
```

　　排序示例：

```go
s := sort.IntSlice{5, 2, 6, 3, 1, 4}
s.Sort()
fmt.Println(s)
```

　　输出结果：

```
[1 2 3 4 5 6]
```

##### 浮点型切片排序

　　与整型切片排序相同，`sort` 包提供了针对浮点型切片的如下方法：

```go
func Float64s(a []float64)
func Float64sAreSorted(a []float64) bool
func SearchFloat64s(a []float64, x float64) int
```

　　同样，也可以使用实现了 ` sort.Interface` 接口的 `Float64Slice` 类型，并实现了其中的方法：

```go
type Float64Slice []float64
    - func (p Float64Slice) Len() int
    - func (p Float64Slice) Less(i, j int) bool
    - func (p Float64Slice) Search(x float64) int
    - func (p Float64Slice) Sort()
    - func (p Float64Slice) Swap(i, j int)
```

##### 字符串切片排序

　　与整型切片排序相同，`sort` 包提供了针对字符串切片的如下方法：

```GO
func Strings(a []string)
func StringsAreSorted(a []string) bool
func SearchStrings(a []string, x string) int
```

　　同样，也可以使用实现了 ` sort.Interface` 接口的 `StringSlice` 类型，并实现了其中的方法：

```go
type StringSlice []string
    - func (p Float64Slice) Len() int
    - func (p Float64Slice) Less(i, j int) bool
    - func (p Float64Slice) Search(x string) int
    - func (p Float64Slice) Sort()
    - func (p Float64Slice) Swap(i, j int)
```

##### 稳定排序

　　`Sort` 排序 `data`，它调用 1 次 `data.Len` 确定长度，调用 O(n*log(n)) 次 `data.Less` 和 `data.Swap`。`Sort()` 函数不能保证排序的稳定性（即不保证相等元素的相对次序不变）。

　　而 `Stable()` 函数排序 `data` 则可以保证排序的稳定性，相等元素的相对次序不变。它调用 1 次  `data.Len`，O(n\*log(n)) 次 `data.Less`和 O(n\*log(n)\*log(n)) 次 `data.Swap`。

```go
func Stable(data Interface)
```

##### 降序排列

　　`sort` 包可以使用 `sort.Reverse(slice)` 来调换 `slice.Interface.Less `，也就是比较函数，所以，`int` 、`float64` 和 `string` 的逆序排序函数可以使用 `Reverse` 方法来实现。排序示例：

```go
s := sort.IntSlice{5, 2, 6, 3, 1, 4}
sort.Sort(sort.Reverse(s))
fmt.Println(s)
```

　　输出结果：

```
[6 5 4 3 2 1]
```

##### 排序搜索

　　`Search` 函数采用二分法搜索找到 [0, n) 区间内最小的满足 `f(i)==true` 的值 i 。也就是说，`Search` 函数希望 f 在输入位于区间 [0, n) 的前面某部分（可以为空）时返回假，而在输入位于剩余至结尾的部分（可以为空）时返回真；`Search` 函数会返回满足 `f(i)==true` 的最小值 i 。如果没有该值，函数会返回 n。注意，未找到时的返回值不是 -1，这一点和 `strings.Index` 等函数不同。`Search` 函数只会用区间[0, n)内的值调用 f。

```go
x := 11
s := []int{3, 6, 8, 11, 45} //注意：已经升序排序
pos := sort.Search(len(s), func(i int) bool { return s[i] >= x })
if pos < len(s) && s[pos] == x {
	fmt.Println(x, "在s中的位置为：", pos)
} else {
	fmt.Println("s不包含元素", x)
}
```

　　输出结果：

```
11 在s中的位置为： 3
```

　　如上，给定一个递增顺序的切片 s，调用 `Search(len(s), func(i int) bool { return S[i] >= x })` 会返回 `data` 中最小的索引i满足 `s[i] >= 11`。如果调用者想要知道 11 是否在切片里，它必须另外检查 `s[i] == 11`。搜索递减顺序的数据时，应使用 `<=` 运算符代替 `>=` 运算符。

#### 自定义类型的排序

　　如上所述，只要自定义类型实现了 `sort.Interface` 接口及其方法，该类型的排序就可以通过使用 `sort.Sort(slice)` 实现。如下，学生成绩排序的例子：

```go
package main

import (
	"fmt"
	"sort"
)

type StuScore struct {
	name  string
	score int
}

type StuScores []StuScore

//Len()
func (s StuScores) Len() int {
	return len(s)
}

//Less():成绩将有高到低排序
func (s StuScores) Less(i, j int) bool {
	return s[i].score < s[j].score
}

//Swap()
func (s StuScores) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func main() {

	students := StuScores{
		{"fzy", 95},
		{"qwe", 91},
		{"rty", 96},
		{"asd", 90}}

	fmt.Println("未排序:")

	for _, v := range students {
		fmt.Println(v.name, ":", v.score)
	}
	fmt.Println()
	//StuScores已经实现了sort.Interface接口
	sort.Sort(students)

	fmt.Println("按成绩升序排序后:")

	for _, v := range students {
		fmt.Println(v.name, ":", v.score)
	}

}
```

　　输出结果：

```
未排序:
fzy : 95
qwe : 91
rty : 96
asd : 90

按成绩升序排序后:
asd : 90
qwe : 91
fzy : 95
rty : 96
```

　　上面的示例实现的是升序排序，如果要得到降序排序结果，其实只要修改 `Less()` 函数：

```go
//Less():成绩降序排序,只将小于号修改为大于号
func (s StuScores) Less(i, j int) bool {
	return s[i].score < s[j].score
}
```

　　当然，也可以使用 `Reverse函数` 来实现：

```
将 sort.Sort(students) 更改为：
sort.Sort(sort.Reverse(StuScores(students)))    // 按照成绩的降序排序
```



参考资料：

[golang sort —— 排序算法](https://blog.csdn.net/gongpulin/article/details/80843921)

[go语言的排序、结构体排序](https://www.cnblogs.com/wangchaowei/p/7802811.html)

