---
title: Android 数据存储之文件存储
tags:
  - Android
  - 文件
categories: Android
abbrlink: 52791
date: 2016-07-29 22:12:16
---

　　前面两篇博客分别介绍了 Android 的 SharedPreferences 数据存储和 SQLite 数据库存储，此篇博客介绍 Android 数据存储的第三种方式：文件存储，这也是我们平时最为常用的，他的很多操作与 Java 文件操作基本一致，只是因为 Android 是基于 Linux 操作系统，所以需要对于文件目录结构需要有更深入的理解。

<!--more-->

#### 内部存储与外部存储

　　Android 本身基于 Linux 操作系统，所以它的内部存储空间，对于应用程序和用户来讲就是 “/data/data" 目录。它与其他的（外部存储）相比有着存储方便，操作简单，更加稳定、安全等优点。但是它比较有限，比较可贵。

##### 内部存储（internal storage）

　　内部存储不是内存。内部存储位于系统中很特殊的一个位置，如果你想将文件存储于内部存储中，那么文件默认只能被你的应用访问到，且一个应用所创建的所有文件都在和应用包名相同的目录下。也就是说应用创建于内部存储的文件，与这个应用是关联起来的。当一个应用卸载之后，内部存储中的这些文件也被删除。

　　内部存储空间十分有限，因而显得可贵，另外，它也是系统本身和系统应用程序主要的数据存储所在地，一旦内部存储空间耗尽，手机也就无法使用了。所以对于内部存储空间，我们要尽量避免使用。

内部存储目录/data/data/包名/ |  说明
---|---
/data/data/包名/shared_prefs |  sharedpreferrence文件存放目录
/data/data/包名/databases | 数据库文件存放目录
/data/data/包名/files | 应用程序默认的数据存储目录
/data/data/包名/cache | 应用程序默认的缓存文件存放目录

##### 外部存储（external storage）

　　外部存储一般就是 storage 文件夹或者 mnt 文件夹，在 storage 文件夹中有一个 sdcard 文件夹，这个文件夹中的文件又分为两类，一类是公有目录，还有一类是私有目录

　　由于内部存储空间有限，在开发中我们一般都是操作外部存储空间，Google 官方建议我们 App 的数据应该存储在外部存储的私有目录中该 App 的包名下，这样当用户卸载掉 App 之后，相关的数据会一并删除，如果你直接在 /storage/sdcard 目录下创建了一个应用的文件夹，那么当你删除应用的时候，这个文件夹就不会被删除。

　　外部存储目录 storage/sdcard，它又分为公有目录和私有目录，其中的公有目录有九大类，比如 DCIM、DOWNLOAD 等这种系统为我们创建的文件夹，私有目录就是 Android 这个文件夹，这个文件夹打开之后里边有一个 data 文件夹，打开这个 data 文件夹，里边有许多包名组成的文件夹。

　　注：所有的这些目录结构都可以通过打开 Android 模拟器，然后使用 DDMS 中的 File Explorer 进行查看。

#### res/raw 和 assets

##### res/raw 和 assets的相同点

　　两者目录下的文件在打包后会原封不动的保存在 apk 包中，不会被编译成二进制。

##### res/raw 和 assets的不同点

1. res/raw 中的文件会被映射到 R.java 文件中，访问的时候直接使用资源 ID 即 R.id.filename；assets 文件夹下的文件不会被映射到 R.java 中，访问的时候需要 AssetManager 类。

2. res/raw 不可以有目录结构，而 assets 则可以有目录结构，也就是 assets 目录下可以再建立文件夹。


　　**另外：**

- assets：用于存放需要打包到应用程序的静态文件，以便部署到设备中。与 res/raw 不同点在于，ASSETS 支持任意深度的子目录。这些文件不会生成任何资源 ID，必须使用 /assets 开始（不包含它）的相对路径名。

- res：用于存放应用程序的资源（如图标、GUI 布局等），将被打包到编译后的 Java 中。不支持深度子目录。

- res/raw：存放通用的文件， 该文件夹内的文件将不会被编译成二进制文件，按原样复制到设备上。

#### 文件存储操作

##### 读写 /data/data/<应用程序名>/files/ 目录的文件

1. 文件权限

- **MODE_PRIVATE** : 默认操作模式，代表该文件是私有数据，只能被应用本身访问，在该模式下，写入的内容会覆盖原文件的内容。

- **MODE_APPEND** : 该模式会检查文件是否存在，存在就往文件追加内容，否则就创建新文件。

- **MODE_WORLD_READABLE和MODE_WORLD_WRITEABLE** : 用来控制其他应用程序是否有权限读写该文件。

2. 读文件

```java
public String readFile(String fileName) throws IOException {
    String res = "";
    try {
        FileInputStream fis = openFileInput(fileName);
        int length = fis.available();
        byte[] bytes = new byte[length];
        fis.read(bytes);
        res = EncodingUtils.getString(bytes, "UTF-8");
        fis.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    return res;
}
```

3. 写文件

```java
public void writeFile(String fileName, String str) throws IOException {
    try {
        FileOutputStream fos = openFileOutput(fileName, MODE_PRIVATE);
        byte[] bytes = str.getBytes();
        fos.write(bytes);
        fos.close();
    }catch (Exception e) {
        e.printStackTrace();
    }
}
```


##### 读写 SD 卡文件

　　目录 /mnt/sdcard 和目录 /sdcard 没有区别，它们都是指向目录 /storage/sdcard 的快捷方式。

1. 添加权限

```xml
<!-- SDCard中创建与删除文件权限 -->  
<uses-permission android:name="android.permission.MOUNT_UNMOUNT_FILESYSTEMS"/>  
<!-- 向SDCard写入数据权限 -->  
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>  
```

2. 判断 SDCard 是否存在

```java
public boolean isSdCardExist() {  
    return Environment.getExternalStorageState().equals(  
            Environment.MEDIA_MOUNTED);  
}  
```

3. 获取 SD 卡根目录

```java
public File getSdCardPath() {
    boolean exist = isSdCardExist();
    File dir;
    if (exist) {
        dir = Environment.getExternalStorageDirectory();
    } else {
        dir = null;
    }
    return dir;
}
```

4. 写文件


```java
public void writeSDCardFile(String fileName, String str) {

    File myfile = new File(getSdCardPath(), fileName);
    try {
        if(!myfile.exists()){   //如果文件不存在则创建新文件
            myfile.createNewFile();
        }
        FileOutputStream fos = new FileOutputStream(myfile);
        byte[] bytes = str.getBytes("UTF-8");   //将字符串转换成字节序列，并制定编码为UTF-8
        fos.write(bytes);   
        fos.flush();    //将缓冲区中的数据强制写出
        fos.close();    //关闭数据流
    } catch (FileNotFoundException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}
```

5. 读文件

```java
public String readSDCardFile(String fileName) {
        
    String res = null;
    File myfile = new File(getSdCardPath(), fileName);
    try {
        FileInputStream fis = new FileInputStream(myfile);
        int length = fis.available();   //得到数据长度
        byte[] bytes = new byte[length];    //开辟一个字节数组
        fis.read(bytes);    //读出数据
        fis.close();    //关闭数据流
        res = new String(bytes, "UTF-8");   //将字符数组转换成字符串，指定编码为UTF-8
    } catch (FileNotFoundException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
    return res;
}
```

6. 删除文件

```java
public void deleteSDCardFile(String fileName) {
    File myfile = new File(getSdCardPath(), fileName);
    myfile.delete();
}
```

　　除了上面讲到的读文件、写文件、删除文件外，File 对象还有创建文件、设置可读可写等方法，具体的可以自己取查看相应的文档。

##### 从 res/raw 中读取文件数据

　　读取文本文件时需要考虑编码格式的问题。在简体中文 Windows 操作系统中，ANSI 编码代表 GBK 编码，文本文件保存时默认使用 ANSI 编码，所以在读取文件获取字符串时要使用 GBK 进行编码。以下代码以读取 txt 文件为例。

```java
public String getRawFile(int resId) {

    String res = "";
    try {
        // 得到资源中的Raw数据流
        InputStream in = getResources().openRawResource(resId);
        int length = in.available();
        byte[] bytes = new byte[length];
        // 读取数据
        in.read(bytes);
        // 依test.txt的编码类型选择合适的编码，如果不调整会乱码
        res = EncodingUtils.getString(bytes, "GBK");
        in.close();
    } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
    return res;
}
```

##### 从 assets 中读取文件数据

　　以下代码同样以读取 txt 文件为例。

```java
public String getAssertFile(String fileName) {

    String res = null;  
    try {
        // 得到资源中的asset数据流
        InputStream in = getResources().getAssets().open(fileName);
        int length = in.available();
        byte[] bytes = new byte[length];
        in.read(bytes);
        in.close();
        res = EncodingUtils.getString(bytes, "GBK");
    } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
        return res;
}
```

　　参考博客：

[1][android中的文件操作详解以及内部存储和外部存储](http://blog.csdn.net/androidwifi/article/details/17725989/)

[2] [android资源目录---assets与res/raw区别](http://blog.csdn.net/hshm20517/article/details/6461890/)

[3] [Android - 文件读写操作 总结](http://blog.csdn.net/ztp800201/article/details/7322110/)






