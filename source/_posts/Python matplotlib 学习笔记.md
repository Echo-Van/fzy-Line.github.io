---
title: Python matplotlib 学习笔记
tags:
  - Python
  - Matplotlib
categories:
  - Coding
  - Python
abbrlink: 58871
date: 2017-06-18 15:44:52
---

　　Python 数据分析与展示课程之 Matplotlib 绘图库学习。

<!--more-->

#### 简介

　　Matplotlib 是一个 Python 的 2D 绘图库，它以各种硬拷贝格式和跨平台的交互式环境生成出版质量级别的图形。它能让使用者很轻松地将数据图形化，并且提供多样化的输出格式。

##### pyplot

　　matplotlib.pyplot 是绘制各类可视化图形的命令子库，它是是命令行式函数的集合，相当于快捷方式，每一个函数都对图像作了修改，比如创建图形，在图像上创建画图区域，在画图区域上画线，在线上标注等。

　　安装 matplot 之前先要安装 Numpy，Numpy 也是 python 的一个扩展包，提供基础的科学计算。

##### 安装

```shell
$ python -m pip install -U pip setuptools
$ python -m pip install matplotlib
```

##### 测试

　　使用 matplotlib 绘制了 x 平方在区间 [-6，6] 的图像：

```python
#coding=utf-8

import numpy as np
import matplotlib.pyplot as plt

x = np.arange(-6,7,1)
y = x**2

plt.plot(x,y,'b--')

plt.show()
```

![18-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/6/18-1.png)

#### plot函数

##### 函数定义

　　plt.plot(x, y, format_string, **kwargs)

　　参数说明：

- x ： X轴数据，列表或数组，可选

- y ： Y轴数据，列表或数组

- format_string ： 控制曲线的格式字符串，可选

- **kwargs ：第二组或更多(x,y,format_string)

　　plt.plot() 只有一个输入列表或数组时，参数被当作Y轴，X轴以索引自动生成

　　plt.plot(x,y) 当有两个以上参数时，按照X轴和Y轴顺序绘制数据点

　　**注意：当绘制多条曲线时，各条曲线的x不能省略**

##### format_string

　　format_string：由颜色字符、风格字符和标记字符组成

- 颜色设置

　　plot 方法的关键字参数 color(或c) 用来设置线的颜色。

颜色字符 | 说明 | 颜色字符 | 说明
:---:|:---:|:---:|:---:
'b' | blue 蓝色 | 'y' | yellow 黄色
'g' | green 绿色 | 'k' | black 黑色
'r' | red 红色 | 'w' | white 白色
'c' | cyan 青绿色 | '#rrggbb' | RGB颜色
'm' | magenta 洋红色 | '0.8' | 灰度值

　　其中，

　　**RGB 颜色字符串：**(r, g, b) 或 (r, g, b, a)，其中 r g b a 取均为[0, 1]之间

　　**灰度值字符串：**[0, 1]之间的浮点数的字符串形式，表示灰度值。0表示黑色，1表示白色

- 样式设置

　　plot 方法的关键字参数 linestyle(或ls) 用来设置线条的样式。

样式字符 | 说明 | 样式字符 | 说明
:---:|:---:|:---:|:---:
'-'  |  实线风格 | '--' |   虚线风格
'-.' |  点划线风格 | ':'  |  虚线风格
'' ' ' | 无线条

- 标记设置

　　plot 方法的关键字参数 marker 用来设置标记风格。

标记字符 | 说明 | 标记字符 | 说明
:---:|:---:|:---:|:---:
'.'  |  点标记 | ','    |  像素标记
'o'  |  圆圈标记 | 'v'   |  下三角标记
'^'  |  上三角标记 | '<'  |  左三角标记
'>'  |  右三角标记 | '1'  |  下花三角标记
'2'  |  上花三角标记 | '3'     |  左花三角标记
'4'  |  右花三角标记 | 's'     |  正方形标记
'p'  |  五边形标记 | '*'  |  星标记
'h'  |  六边形1标记 | 'H'     |  六边形2标记
'+'  |  十字标记 | 'x'   |  x标记
'D'  |  菱形标记 | 'd'   |  瘦菱形标记
'|'  |  垂直线标记 | '_'  |  _标记

　　markersize(ms) 设置标记大小

　　markerfacecolor(mfc) 设置标记颜色

　　markeredgecolor(mec) 设置标记边缘的颜色

　　markeredgewidth(mew) 设置标记边缘的宽度

　　更多属性设置请参考 matplotlib 的官方文档。

　　**可以通过格式化参数指定线条的颜色和样式：**

　　例如：'b--*'表示蓝色，虚线，用星号标记点

- 线条宽度

　　设置 plot 方法的关键字参数 linewidth(或lw) 可以改变线条的粗细，其值为浮点数。

- 线条标签

　　label : 给所绘制的曲线一个名字

　　label标签指定的名字在图示(legend)中显示，需在 plt.show() 之前调用 plt.legend()。在字符串前后添加 "$" 符号，matplotlib 会使用其内嵌的 latex 引擎绘制的数学公式。

　　图示默认绘制于图的右下角，legend 方法可接受一个 loc 关键字参数来设定图例的位置，可取值为数字或字符串：


数字 | 字符串 | 说明 | 数字 | 字符串 | 说明
---:|:---:|:---:|:---|---|---
0  |  'best' | 默认 | 1  |  'upper right' | 右上角
2  |  'upper left' | 左上角 | 3  |  'lower left' | 左下角
4  |  'lower right' | 右下角 | 5  |  'right' | 右侧
6  |  'center left' | 左侧居中 | 7  |  'center right' | 右侧居中
8  |  'lower center' | 底部居中 | 9  |  'upper center' | 上方居中
10 |  'center' | 正中间

- 示例程序

```python
#coding=utf-8

import numpy as np
import matplotlib.pyplot as plt

x = np.arange(-6,7,1)
y = x**1
z = x**2

plt.title('x and x square')
plt.plot(x,y,'b--',marker='+',label="$x^2$")    #`b-`是`color="blue",linestyle="-"`的简写形式
plt.plot(x,z,color='r',linestyle='--',marker='*',label="$x^3$",linewidth=2)

plt.legend(loc=1)
plt.show()
```

![18-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/6/18-2.png)

#### 绘图区域设置

##### 绘图区域的概念

　　在 matplotlib 中，整个图像为一个 Figure 对象。在 Figure 对象中可以包含一个，或者多个 Axes 对象。每个 Axes 对象都是一个拥有自己坐标系统的绘图区域。其逻辑关系如下：

![18-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/6/18-3.png)

　　一个 Figure 对应一张图片。Title 为标题。Axis 为坐标轴，Label 为坐标轴标注。Tick 为刻度线，Tick Label 为刻度注释。

![18-4](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/6/18-4.png)

##### 绘制子图

　　plt.subplot(nrows, ncols, plot_number)

　　在全局绘图区域中创建一个分区体系，并定位到一个子绘图区域

　　参数说明：

- nrows ： 将整个绘图区域分成几行

- ncols ： 将整个绘图区域分成几列

- plot_number ： 当前绘制的区域编号

　　例如：

　　plt.subplot(3,2,4)，也可省略逗号 plt.subplot(324)

##### 示例程序1

```python
#coding=utf-8

import numpy as np
import matplotlib.pyplot as plt

x = np.arange(-6,7,1)
y = x**1
z = x**2

plt.subplot(2,1,1)
plt.plot(x,y)

plt.subplot(212)
plt.plot(x,z,'r--')

plt.show()
```

![18-5](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/6/18-5.png)

##### 设置图表标题

　　plt.title('标题字符串')用于设置图表的标题。

##### 设置坐标轴

- 轴区间设置

1. axis方法：axis([xmin,xmax,ymin,ymax])

2. 设置x轴的最大最小区间：xlim((xmin,xmax)) 

3. 设置y轴的最大最小区间：ylim((ymin,ymax))

- 轴标签设置

1. plt.xlabel()方法用于设置x轴的轴标签

2. plt.ylabel()方法用于设置x轴的轴标签

##### 设置网格线

　　plt.grid() 函数可以提供是否显示网格的选项，在 plot() 之后加上 grid(True) 即可在坐标上显示网格。

##### 保存图像

　　plt.savefig() 将输出图形存储为文件，存储位置为当前 Python 脚本所在目录，默认 PNG 格式，可以通过 dpi 修改输出质量。

##### 示例程序2

```python
#coding=utf-8
import numpy as np
import matplotlib.pyplot as plt

x = np.arange(-6,7,1)
y = x
plt.axis([-6,6,-6,6])  
plt.xlabel('x')
plt.ylabel('y')
plt.plot(x,y)
plt.grid(True)  #设置显示网格

plt.savefig('example2', dpi=600)
plt.show()
```

![18-6](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/6/18-6.png)

