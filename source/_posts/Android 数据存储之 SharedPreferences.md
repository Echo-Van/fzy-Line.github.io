---
title: Android 数据存储之 SharedPreferences
tags:
  - Android
  - SharedPreferences
categories: Android
abbrlink: 2470
date: 2016-07-21 22:11:35
---

　　SharedPreferences 是一种轻型的数据存储方式，它的本质是基于 xml 文件存储的 key-value 键值对数据，它的使用非常简单,能够轻松的存放数据和读取数据。App 都有相应的配置文件，但是由于 App 的配置信息并不多，如果采用数据库来存放并不划算，因为数据库连接跟操作等耗时大大影响了程序的效率，因此通常使用 SharedPreferences 来存储一些简单的配置信息。

<!--more-->

#### 使用SharedPreferences保存数据

##### 获得SharedPreferences对象

　　使用 getSharedPreferences 方法得到 SharedPreferences 对象，该方法有两个参数，第一个参数是文件名，第二个参数是权限模式。文件名不需要加后缀，系统在生成该文件时会自动加上 .xml 后缀。

　　SharedPreferences 的四种操作模式:

- **Context.MODE_PRIVATE：**为默认操作模式,代表该文件是私有数据,只能被应用本身访问,在该模式下,写入的内容会覆盖原文件的内容。

- **Context.MODE_APPEND：**模式会检查文件是否存在,存在就往文件追加内容,否则就创建新文件。

　　Context.MODE_WORLD_READABLE和Context.MODE_WORLD_WRITEABLE用来控制其他应用是否有权限读写该文件.

- **Context.MODE_WORLD_READABLE：**表示当前文件可以被其他应用读取.

- **Context.MODE_WORLD_WRITEABLE：**表示当前文件可以被其他应用写入.

##### 获取Editor对象，并使用相应的方法来创建、修和清除数据

　　调用该 SharedPreferences 对象的 Editor 接口得到一个 Editor 对象，使用该对象有 putInt，putString 等putXxx 方法来存储键值对信息，通过 remove() 方法来移除一个键值对，或者通过 clear() 方法来清除数据等。

##### 使用commit()方法提交数据。

```java
SharedPreferences sharedPreferences = getSharedPreferences("mysp",Context.MODE_PRIVATE);
Editor editor=sharedPreferences.edit();
editor.putString("name", "fzy");
editor.putString("age", "22");
editor.commit();    //提交数据
```

　　记得每次更改数据后都要调用 editor 对象的 commit() 方法提交数据，执行以上代码后，SharedPreferences将会把这些数据保存在 mysp.xml 文件中，可以打开 eclipse 的 DDMS 工具在 File Explorer 的 data/data/ 相应的包名 /shared_prefs/mysp.xml 下导出该文件，并查看。（如下图红色箭头标注）

![21-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/7/21-1.jpg)

　　我们可以将此 xml 文件导出来看看，点击右上角 pull a file from the device (如下图蓝色箭头标注)

![21-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/7/21-2.jpg)

#### 从SharedPreferences获取数据

```java
SharedPreferences sharedPreferences=getSharedPreferences("mysp", Context.MODE_PRIVATE);
String name=sharedPreferences.getString("name", "defaultname");
String age=sharedPreferences.getString("age", "0");
System.out.println("name: "+ name + ",age: " + age);
```

　　取出结果如下：

![21-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/7/21-3.jpg)

