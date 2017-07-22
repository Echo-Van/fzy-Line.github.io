---
title: Android SQLite基本操作详解
date: 2016-07-26 22:11:59
tags: ［Android,SQLite］
categories: Android
---

　　SQLite 是一个开源的嵌入式关系数据库，实现自包容、零配置、支持事务的SQL数据库引擎。 其特点是高度便携、使用方便、结构紧凑、高效、可靠。之前写过一个简单的Android记事本程序，使用过SQLite数据库，但是并没有真正理解并消化。前段时间认真学习了Mysql数据库的相关知识，对数据库有了更深入的认识，于是，也准备把Android这一块的SQLite数据库好好整理一下。

<!--more-->

SQLite支持的数据类型：

NULL(空值)、INTEGER(整型值)、REAL(浮点值)、TEXT(字符串值)、BLOB(二进制对象)

#### 数据库创建与管理

使用辅助类SQLiteOpenHelper来管理数据库的创建和版本更新，在工程中新建一个类SQLiteUtil用于管理数据库，继承自SQLiteOpenHelper。

##### 必须实现构造方法

public DatabaseHelper(Context context, String name, CursorFactory factory, int version) 

##### 重写两个抽象方法

public void onCreate(SQLiteDatabase db)，方法当数据库第一次被建立的时候被执行，一般把创建表,初始化数据等操作放在这里。

public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion)方法，当数据库版本更新时会自动执行。

```
public class SQLiteUtil extends SQLiteOpenHelper{

    public static final String TABLE_NAME_STUDENT = "student";
    
    public static final String COLUMN_NAME_ID = "_id";
    public static final String COLUMN_NOTE_NO = "Sno";
    public static final String COLUMN_NOTE_NAME = "Sname";
    public static final String COLUMN_NOTE_AGE = "Sage";
    public static final String COLUMN_NOTE_SEX = "Ssex";
    
    public SQLiteUtil(Context context, String name, CursorFactory factory,int version) {
        super(context, name, factory, version);
        // TODO Auto-generated constructor stub
    }
    
    @Override
    public void onCreate(SQLiteDatabase db) {
        // TODO Auto-generated method stub
        //在这里创建数据库，后文会用到
        db.execSQL("CREATE TABLE " + TABLE_NAME_STUDENT + "(" 
                    + COLUMN_NAME_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                    + COLUMN_NOTE_NO + " TEXT NOT NULL DEFAULT \"\","
                    + COLUMN_NOTE_NAME + " TEXT NOT NULL DEFAULT \"\"," 
                    + COLUMN_NOTE_AGE + " INTEGER NOT NULL,"
                    + COLUMN_NOTE_SEX + " TEXT NOT NULL DEFAULT \"男\"" 
                    + ")" );
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion){
        // TODO Auto-generated method stub
        //在这里更新数据库版本
    }

}
```

在这个类被实例化的时候，系统会检测这个数据库是否存在，如果已经存在就不再创建，如果不存在则创建。还会检测数据库的版本，当版本号不同时会执行更新操作。

#### 数据库基本操作

SQLiteDataBase类提供了大量的API来操控SQLite数据库,每一个SQLiteDatabase的实例就代表了一个数据库(对应底层的一个数据库文件)，一旦应用程序获得了SQLiteDatabase对象，就可以通过该对象来操作与之相对应的数据库。

```
SQLiteUtil mSqLiteUtil = new SQLiteUtil(this, "fzy", null, 1);
SQLiteDatabase db = mSqLiteUtil.getWritableDatabase();  //得到一个SQLiteDatabase对象
```

##### 基本操作写法一

对于插入、删除和更新来说都可以通过executeSQL方法执行sql语句来实现。

```
db.executeSQL(String sql);  
db.executeSQL(String sql, Object[] bindArgs);  //sql语句中使用占位符，然后第二个参数是实际的参数集  
```

查询可以使用rawQuery方法执行sql语句来实现。

```
db.rawQuery(String sql, String[] selectionArgs);  
```

将所有的SQL语句都组织到一个字符串中，使用占位符代替实际参数，selectionArgs就是占位符实际参数集。

##### 基本操作写法二

除了统一的形式之外，他们还有各自的操作方法：

###### 插入

```
db.insert(String table, String nullColumnHack, ContentValues values);
```

第一个参数都是表示要操作的表名，第二个参数表示如果插入的数据每一列都为空的话，需要指定此行中某一列的名称，系统将此列设置为NULL，不至于出现错误，第三个参数ContentValues类型的变量，是键值对组成的Map，key代表列名，value代表该列要插入的值。

###### 删除

```
db.delete(String table, String whereClause, String whereArgs);  
```

第一个参数都是表示要操作的表名，第二个参数是用来指定删除条件，传递空值时将删除所有行，第三个参数是删除条件的数组值，将与第二个参数组成条件字符串。

###### 更新

```
db.update(String table, Contentvalues values, String whereClause, String whereArgs); 
```

第一个参数都是表示要操作的表，第二个参数ContentValues类型的变量，是键值对组成的Map，key代表列名，value代表该列要插入的值。第三个参数用来指定更新条件，传递空值将更新所有行。第四个参数是更新条件的数组值，将与第三个参数组成条件字符串。

###### 查询

查询有很多不同参数的方法，这里只列举一例，其他的可以参考官方文档查看。
```
db.query(String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy); 
```
第一个参数都是表示要操作的表名，第二个参数表示要查询的列所有名称集，第三个参数selection表示WHERE之后的条件语句，可以使用占位符，groupBy指定分组的列名，having指定分组条件，配合groupBy使用，orderBy指定排序的列名，limit指定分页参数，distinct可以指定“true”或“false”表示要不要过滤重复值。需要注意的是，selection、groupBy、having、orderBy、limit这几个参数中不包括“WHERE”、“GROUP BY”、“HAVING”、“ORDER BY”、“LIMIT”等SQL关键字。

##### 结果集的处理

最后，他们同时返回一个Cursor对象，代表数据集的游标，有点类似于JavaSE中的ResultSet。

方法 | 描述
---|---
move(int offset) | 以当前位置为参考,移动到指定行
moveToFirst() | 移动到第一行 
moveToLast() | 动到最后一行
moveToPosition(int position) | 移动到指定行 
moveToPrevious()| 移动到前一行  
moveToNext() | 移动到下一行  
isFirst() | 是否指向第一条  
isLast() | 是否指向最后一条  
isBeforeFirst() | 是否指向第一条之前  
isAfterLast() | 是否指向最后一条之后  
isNull(int columnIndex) | 指定列是否为空(列基数为0)  
isClosed() | 游标是否已关闭  
getCount() | 总数据项数  
getPosition() | 返回当前游标所指向的行数  
getColumnIndex(String columnName) | 返回某列名对应的列索引值  
getString(int columnIndex) | 返回当前行指定列的值

遍历结果集的方法：

```
Cursor cs = db.query(传入相关参数);     //得到结果集
if(cs!=null){
    while(cs.moveToNext()){
        cs.getString(cs.getColumnIndex(列名));  //通过列名获得列索引，然后再取出其值
        //...获取更多的列值
    }
}
```
#### Demo演示

这篇博客准备很久了，之前只是知道怎么使用Android的SQLite数据库，并没有系统地去熟悉相关的知识，现在通过查看官方的API文档与别人的博客将这些知识整理了一下，自己写了一个小Demo来熟悉Android的SQLite数据库操作。

核心的代码如下：

MainActivity.java
```
public void insertData() {  //插入数据

    // 通过直接执行SQL语句来给学生表插入3条数据
    db.execSQL("INSERT INTO " + SQLiteUtil.TABLE_NAME_STUDENT
                + " (Sno,Sname,Sage,Ssex) VALUES ('2016001','fzy','22','男')");
                db.execSQL("INSERT INTO " + SQLiteUtil.TABLE_NAME_STUDENT
                + " (Sno,Sname,Sage,Ssex) VALUES ('2016002','qwe','20','女')");
                db.execSQL("INSERT INTO " + SQLiteUtil.TABLE_NAME_STUDENT
                + " (Sno,Sname,Sage,Ssex) VALUES ('2016003','asd','19','男')");
    
    // 使用insert方法来给学生表插入一条记录
    ContentValues cv = new ContentValues();
    cv.put(SQLiteUtil.COLUMN_NOTE_NO, "20160004");
    cv.put(SQLiteUtil.COLUMN_NOTE_NAME, "rty");
    cv.put(SQLiteUtil.COLUMN_NOTE_AGE, "24");
    cv.put(SQLiteUtil.COLUMN_NOTE_SEX, "男");
    db.insert(SQLiteUtil.TABLE_NAME_STUDENT, null, cv);
}

public void deleteData() {

    // 直接执行SQL语句删除学生表中Sage大于18的学生的所有信息
    db.execSQL("DELETE FROM " + SQLiteUtil.TABLE_NAME_STUDENT + " WHERE Sage = 18");
    
    // 使用delete方法来删除学生表中_id大于1的学生的所有信息
    db.delete(SQLiteUtil.TABLE_NAME_STUDENT, "_id>", new String[] { "1" });
}
    
public void updateData() {

    // 直接执行SQL语句表中Sno为20160002的学生的名字Sname更新为xxx
    db.execSQL("UPDATE " + SQLiteUtil.TABLE_NAME_STUDENT + " SET Sname = 'xxx' WHERE Sno = '2016002'");
    
    // 使用update方法来更新学生表中_id大于2的学生的年龄信息
    ContentValues cv = new ContentValues();
    cv.put(SQLiteUtil.COLUMN_NOTE_AGE, "18");
    db.update(SQLiteUtil.TABLE_NAME_STUDENT, cv, "_id>?",
    new String[] { "2" });
}

public void queryData() {

    Cursor cs = db.query(SQLiteUtil.TABLE_NAME_STUDENT, null, null, null,null, null, null, null);
    StringBuilder result = new StringBuilder();
    while (cs.moveToNext()) {   //遍历结果集
    String line = cs.getString(cs.getColumnIndex(SQLiteUtil.COLUMN_NOTE_NO))
                    + cs.getString(cs.getColumnIndex(SQLiteUtil.COLUMN_NOTE_NAME))
                    + cs.getInt(cs.getColumnIndex(SQLiteUtil.COLUMN_NOTE_AGE))
                    + cs.getString(cs.getColumnIndex(SQLiteUtil.COLUMN_NOTE_SEX)) + "\n";
                    result.append(line);    
    }
    mResult.setText(result);    //使用TextView显示出来
    cs.close();
}

```

通过在按钮的监听事件中调用这些方法就可以实现我的Demo的功能，这个Demo主要是通过不同的方式来实践数据库的操作，比较简单。效果如下：

![26-1](http://ohe7ixo05.bkt.clouddn.com/2016/7/26-1.jpg)

##### 数据库管理工具

将程序运行在模拟器中后，我们可以打开DDMS工具看到我创建的数据库文件：fzy，将其导出到电脑，使用第三方工具查看。这里讲解一种比较方便的方法，直接使用SDK提供的数据库管理工具来操作，不需要每次更改都将数据库文件导出到windows，具体方法如下：

1、打开Windowsx系统的cmd窗口

2、进入到你的SDK目录下的platform-tools目录下，输入如下命令：

```
adb shell
```
进入调试环境，然后输入如下命令进入到数据库文件夹：

```
cd /data/data/包名/databases
ls  //查看有哪些数据库文件
```

然后，使用如下sqlite工具打开数据库文件

```
sqlite3 数据库文件名
```

进入sqlite3命令行管理工具，可以通过以下命令进行操作，这与mysql数据库有些区别，命令都是以.号开。

```
.help 查看帮助
.tables 查看数据库中存在的表
```

然后就可以对相应的表执行sql语句啦！需要注意的是，sql语句末尾需要加分号，sqlite命令行工具的操作命令不需要加分号。

如下图所示：

![26-2](http://ohe7ixo05.bkt.clouddn.com/2016/7/26-2.jpg)

参考博客： 

[1] [Android中SQLite应用详解](http://blog.csdn.net/liuhe688/article/details/6715983/)
[2] [Android 操作SQLite基本用法](http://blog.csdn.net/codeeer/article/details/30237597)