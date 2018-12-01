---
title: Android 开发之 eclipse 快捷操作
tags:
  - Android
  - eclipse
categories: Android
abbrlink: 58180
date: 2016-06-18 11:38:27
---


　　本文总结了一些 eclipse 常用的快捷键以及快捷操作的小技巧，熟悉使用这些操作对于提高开发效率将会很有帮助。

<!--more-->

#### 快速注释

**（1）行注释：** `ctrl+/`

**（2）取消行注释：** `再按一次ctrl+/`

**（3）块注释:** `ctrl+shift+/`

**（4）取消块注释：** `ctrl+shift+\`

#### 快速编辑

**（1）快速删除当前行：** `ctrl+D`

**（2）代码编辑窗口缩放：** `ctrl+M`，再按一次则可以恢复

**（3）快速切换代码编辑窗口：** `ctrl+F6`

**（4）大小写切换：**

- `Ctrl+Shift+Y`  大写变小写

- `Ctrl+Shift+X`  小写变大写

**（5）复制行：**

- `Ctrl+Alt+向上`  复制当前行到上一行

- `Ctrl+Alt+向下`  复制当前行到下一行

**（6）移动行：**

- Alt+向下   快速提取某行到下边指定位置

- Alt+向上   快速提取某行到上边指定位置

**（7）下一个错误及快速修改：** `Ctrl+.` 及 `Ctrl+1`

**（8）快速跳转到申明：** `F3`

**（9）重命名：** `F2`

**（10）回到最后一次编辑的地方：** `Ctrl+Q`

**（11）快速查看当前类的方法或某个特定方法：** `Ctrl+O`

**（12）配置行号：**

　　点击菜单栏的 `Windows—>preference—>General—>Editors—>Text Editors` 将 `show line numbers` 选上

**（13）增强代码提示功能：**

　　点击菜单栏的 `Windows—>preference—>Java—>Editors—>Content Assist` 将 `Auto activation atriggers for java` 后面的 `“.”` 换成 `“abcdefghijklmnopqrstuvwxyz.”`


#### 快速生成

**（1）快速复写超类的方法：**

　　点击 `右键—>source—>Generate Constructors from Superclass`

**（2）批量生成get、set方法：**

　　点击 `右键—>source—>Generate Getters and Setters`

**（3）快速生成构造方法：**

　　点击 `右键—>source—>Generate Constructor using Fields `

**（4）使用代码模板（需选中代码）：** `Alt+Shift+Z`

**（5）快速导入包：** `Ctrl+Shift+O`

**（5）快速添加javadoc注释：** `Ctrl+Shift+J`    


#### 美化代码

**（1）快速格式化代码：** `Ctrl+Shift+F`

**（2）成员排序：**

　　选择 `菜单栏source—>Sort Members`，使变量名、方法名或者类名按首字母大小排序

**（3）整理导入的包：**

　　选择 `菜单栏Source—>Organize Imports` 或者使用 `Ctrl+Shift+O`，可以快速导入缺少的包以及删除不需要的包。

#### 代码重构(Refactor)

　　快速打开Refactor菜单：Alt+shift+T

**（1）Rename**

　　选中变量或者方法名等需要更改的名字，点击菜单栏 `Refactor——>Rename`（或者使用快捷键 `alt+shift+R`）即可实现代码中某一变量、方法或者类名进行全部重命名替换

**（2）Move**

　　点击菜单栏 `Refactor—>Move`（或者使用快捷键 `alt+shift+V`），将该java文件移动到其他的包

**（3）修改方法结构**

　　点击菜单栏 `Refactor—>Change Method Signature`（或者使用快捷键 `alt+shift+C`），不管有多少个函数调用了这个方法，修改一次就能全部搞定

**（4）抽取方法** 

　　选中需要单独生成方法的代码，点击菜单栏（或者右键）`Refactor—>Extract Method`（或者使用快捷键`alt+shift+M`）,这是重构里面最常用的方法之一

**（5）抽取本地变量**

　　选中数字或字符串，点击菜单栏（或者右键）`Refactor—>Extract Local Variable`（或者使用快捷键 `alt+shift+L`）， 可以直接把数字和字符串抽取成一个变量

**（6）撤销重构：** `alt+shift+Z` 或者 `ctrl+Z`