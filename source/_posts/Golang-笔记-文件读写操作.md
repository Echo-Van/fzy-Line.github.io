---
title: Golang 笔记-文件读写操作
tags: Golang
categories:
  - Coding
  - Golang
abbrlink: 40570
date: 2019-06-10 23:25:24
---

<center>Golang 文件读写操作学习</center>

<!--more-->

#### 使用 os 包

##### 创建文件

```go
func Create(name string) (file *File, err error)
```

　　`Create` 采用模式0666（任何人都可读写，不可执行）创建一个名为 name 的文件，如果文件已存在会截断它（为空文件）。如果成功，返回的文件对象可用于 `I/O` ；对应的文件描述符具有 `O_RDWR` 模式。如果出错，错误底层类型是 `*PathError`。

　　示例：

```go
import (
	"os"
	"fmt"
)

func main() {

	file, err := os.Create("xxx.txt")
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("文件创建成功！")
	defer file.Close()
    
}
```

##### 打开文件

```go
func Open(name string) (file *File, err error)
```

　　`Open` 打开一个文件**用于读取**。如果操作成功，返回的文件对象的方法可用于读取数据；对应的文件描述符具有 `O_RDONLY` 模式。如果出错，错误底层类型是 `*PathError`。

```
func OpenFile(name string, flag int, perm FileMode) (file *File, err error)
```

　　`OpenFile` 是一个更一般性的文件打开函数，大多数调用者都应用 `Open` 或 `Create` 代替本函数。它会使用指定的选项（如 `O_RDONLY` 等）、指定的模式（如0666等）打开指定名称的文件。如果操作成功，返回的文件对象可用于 `I/O` 。如果出错，错误底层类型是 `*PathError` 。

　　flag 有：

```go
const (
    //只读模式
    O_RDONLY    int    = syscall.O_RDONLY    // open the file read-only.
    //只写模式
    O_WRONLY    int    = syscall.O_WRONLY    // open the file write-only.
    //可读可写
    O_RDWR        int    = syscall.O_RDWR    // open the file read-write.
    //追加内容
    O_APPEND    int    = syscall.O_APPEND    // append data to the file when writing.
    //创建文件,如果文件不存在
    O_CREATE    int    = syscall.O_CREAT    // create a new file if none exists.
    //与创建文件一同使用,文件必须存在
    O_EXCL        int    = syscall.O_EXCL    // used with O_CREATE, file must not exist
    //打开一个同步的文件流
    O_SYNC        int    = syscall.O_SYNC    // open for synchronous I/O.
    //如果可能,打开时缩短文件
    O_TRUNC        int    = syscall.O_TRUNC    // if possible, truncate file when opened.
)
```

　　fileMode 有:

```go
const (
    // 单字符是被String方法用于格式化的属性缩写。
    ModeDir        FileMode = 1 << (32 - 1 - iota) // d: 目录
    ModeAppend                                     // a: 只能写入，且只能写入到末尾
    ModeExclusive                                  // l: 用于执行
    ModeTemporary                                  // T: 临时文件（非备份文件）
    ModeSymlink                                    // L: 符号链接（不是快捷方式文件）
    ModeDevice                                     // D: 设备
    ModeNamedPipe                                  // p: 命名管道（FIFO）
    ModeSocket                                     // S: Unix域socket
    ModeSetuid                                     // u: 表示文件具有其创建者用户id权限
    ModeSetgid                                     // g: 表示文件具有其创建者组id的权限
    ModeCharDevice                                 // c: 字符设备，需已设置ModeDevice
    ModeSticky                                     // t: 只有root/创建者能删除/移动文件
    // 覆盖所有类型位（用于通过&获取类型位），对普通文件，所有这些位都不应被设置
    ModeType = ModeDir | ModeSymlink | ModeNamedPipe | ModeSocket | ModeDevice
    ModePerm FileMode = 0777 // 覆盖所有Unix权限位（用于通过&获取类型位）
)
```

##### 写文件

　　常用函数：

```go
func (f *File) Write(b []byte) (n int, err error)
func (f *File) WriteString(s string) (ret int, err error)
func (f *File) WriteAt(b []byte, off int64) (n int, err error)
```

- Write 向文件中写入 len(b) 字节数据。它返回写入的字节数和可能遇到的任何错误。如果返回值 `n!=len(b)`，本方法会返回一个非 nil 的错误。
- WriteString 类似 Write，但接受一个字符串参数。
- WriteAt 在指定的位置（相对于文件开始位置）写入 len(b) 字节数据。它返回写入的字节数和可能遇到的任何错误。

```GO
import (
	"os"
	"fmt"
)

func main() {

	file, err := os.OpenFile("xxx.txt", os.O_WRONLY, 0666)
	if err != nil {
		fmt.Println(err)
	}

	s1 := "This is a new file\r\n"
	cnt, err := file.WriteString(s1)
	if err == nil {
		fmt.Println("WriteString 写入字节数为：", cnt)
	}

	s2 := "This is a new line\r\n"
	cnt, err = file.Write([]byte(s2))
	if err == nil {
		fmt.Println("Write 写入字节数为：", cnt)
	}

	s3 := "Write at offset 100\r\n"
	cnt, err =file.WriteAt([]byte(s3), 100)
	if err == nil {
		fmt.Println("WriteAt 写入字节数为：", cnt)
	}

	defer file.Close()

}
```

　　上面的方式写入内容会将原文件中的内容覆盖掉，因为使用的是 `O_WRONLY` 模式，如果要追加内容，我们可以使用追加模式即 `O_APPEND` ，示例：

```GO
import (
	"os"
	"fmt"
)

func main() {

	file, err := os.OpenFile("xxx.txt", os.O_APPEND, 0666)
	if err != nil {
		fmt.Println(err)
	}

	s1 := "Append new content\r\n"
	cnt, err := file.WriteString(s1)
	if err == nil {
		fmt.Println("WriteString 写入字节数为：", cnt)
	}
}
```

##### 读文件

　　基本方法：

```go
func (f *File) Read(b []byte) (n int, err error)
func (f *File) ReadAt(b []byte, off int64) (n int, err error)
```

- Read 方法从 f 中读取最多 `len(b)` 字节数据并写入 b。它返回读取的字节数和可能遇到的任何错误。文件终止标志是读取 0 个字节且返回值 err 为 io.EOF。 
- ReadAt 从指定的位置（相对于文件开始位置）读取 `len(b)` 字节数据并写入 b。它返回读取的字节数和可能遇到的任何错误。当 `n<len(b)` 时，本方法总是会返回错误；如果是因为到达文件结尾，返回值 err 会是io.EOF。

　　示例：

- 普通读取方式：

```go
import (
	"os"
	"fmt"
)

func main() {

	file, err := os.OpenFile("xxx.txt", os.O_RDONLY, 0666)
	if err != nil {
		fmt.Println(err)
	}
	
	buf := make([]byte, 1024)
	n, err := file.Read(buf)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println("读取字节数：", n)
		fmt.Println(string(buf))
	}
}
```

##### 检查文件是否存在

```go
func (f *File) Stat() (fi FileInfo, err error)
```

　　Stat 返回描述文件 f 的 FileInfo 类型值。如果出错，错误底层类型是 *PathError。示例：

```go
func checkFileIsExist(filename string) bool {
	var exist = true
	if _, err := os.Stat(filename); os.IsNotExist(err) {
		exist = false
	}
	return exist
}
```

#### 使用 io/ioutil 包

　　由于 `os.Open` 是打开一个文件并返回一个文件对象，因此其实可以结合 `ioutil.ReadAll(r io.Reader)` 来进行读取。 `io.Reader` 其实是一个包含 `Read` 方法的接口类型，而文件对象本身是实现了了 `Read` 方法的。

##### 写文件

```go
func WriteFile(filename string, data []byte, perm os.FileMode) error
```

　　WriteFile 函数向 filename 指定的文件中写入数据。如果文件不存在将按给出的权限创建文件，否则在写入数据之前清空文件。示例：

```go
package main

import (
    "io/ioutil"
)

func check(e error) {
    if e != nil {
        panic(e)
    }
}

func main() {

    d1 := []byte("hello\ngo\n")
    err := ioutil.WriteFile("test.txt", d1, 0644)
    check(err)
}
```

##### 读文件

```go
func ReadFile(filename string) ([]byte, error)
```

　　ReadFile 从 filename 指定的文件中读取数据并返回文件的内容。成功的调用返回的 err 为 nil 而非 EOF。因为本函数定义为读取整个文件，它不会将读取返回的 EOF 视为应报告的错误。示例：

```go
package main

import (
	"io/ioutil"
	"fmt"
)

func main()  {
    
	b, err := ioutil.ReadFile("xxx.txt")
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(string(b))
    
}
```

#### 使用 bufio

　　bufio 包实现了有缓冲的 I/O。它包装一个 `io.Reader` 或 `io.Writer` 接口对象，创建另一个也实现了该接口，且同时还提供了缓冲和一些文本 I/O 的帮助函数的对象。使用带缓冲区的 I/O 可以大幅提高文件读写的效率，因为它把文件读取进缓冲（内存）之后再读取的时候就可以避免文件系统频繁的 I/O 从而提高速度。此外，它还提供了多种读写函数，方便开发者使用。

- 写文件

```go
// NewWriter创建一个具有默认大小缓冲、写入w的*Writer。
func NewWriter(w io.Writer) *Writer

func (b *Writer) Write(p []byte) (nn int, err error)
func (b *Writer) WriteString(s string) (int, error)
func (b *Writer) WriteByte(c byte) error
......

// Flush方法将缓冲中的数据写入下层的io.Writer接口。
func (b *Writer) Flush() error
```

　　示例：

```go
import (
	"bufio"
	"os"
	"fmt"
	"strconv"
)

func main() {

    file, err := os.OpenFile("xxx.txt", os.O_APPEND, 0666)
	if err != nil {
		fmt.Println("文件打开错误：", err)
        return
	}
    
	writer := bufio.NewWriter(file)
	str := "write new line: "
	for i:=0; i<10; i++{
		_, err := writer.WriteString(str + strconv.Itoa(i) + "\r\n")
		if err != nil {
			fmt.Println("写入错误：", err)
			return
		}
	}
	writer.Flush()	// 将缓冲中的数据写入下层的 io.Writer 接口。
	defer file.Close()

}
```

- 读文件

```go
func (b *Reader) Read(p []byte) (n int, err error)
func (b *Reader) ReadLine() (line []byte, isPrefix bool, err error)
func (b *Reader) ReadString(delim byte) (line string, err error)
......
```

　　示例：

```go
import (
	"os"
	"fmt"
	"bufio"
	"io"
)

func main() {

	file, err := os.OpenFile("xxx.txt", os.O_RDONLY, 0666)
	if err != nil {
		fmt.Println(err)
	}

	reader := bufio.NewReader(file)
	for {
		str, err := reader.ReadString('\n')	// 按行读取
		if err == io.EOF {
			break
		}
		fmt.Print(str)
	}

}
```