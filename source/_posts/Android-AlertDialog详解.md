---
title: Android AlertDialog详解
date: 2016-08-13 09:26:41
tags: ［Android,AlertDialog］
categories: Android
---

　　AlertDialog就是Android中的弹出式对话框，很多应用中都有对AlertDialog的应用。前段时间，一位学长问我自定义AlertDialog的问题，因为自己也只是之前用过，并不是很熟悉，所以我也只能很抱歉地回绝了，这一次通过写这篇博客对AlertDialog的操作进行了详细的总结，介绍了AlertDialog类和AlertDialog.Builder类，以及给AlertDialog设置不同的内容，最后还实现了自定义的AlertDialog。

<!--more-->

AlertDialog继承自Dialog类，对于Android内置的AlertDialog，它可以包含一个标题、一个内容消息或者一个选择列表、最多三个按钮。而创建AlertDialog推荐使用它的一个内部类AlertDialog.Builder创 建，使用Builder对象，可以设置AlertDialog的各种属性，最后通过Builder.create()就可以得到AlertDialog对 象，再使用Builder.show()方法来显示。

官方图解：

![13-1](http://ohe7ixo05.bkt.clouddn.com/2018/8/13-1.png)

（1）区域1是AlertDialog对话框的头部信息区域，包括标题名或者是一个图标。

（2）区域2是AlertDialog对话框的内容部分，在这里我们可以设置Message信息或者是选择框，还可以设置自定义的布局弹出框。

（3）区域3是AlertDialog对话框的操作按钮部分，可以设置相应的按钮。


#### AlertDialog类

##### 常用方法

方法 | 描述
---|---
setTitle(CharSequence title) | 为对话框设置标题
setIcon(Drawable icon) | 通过Drawable资源对象为对话框设置图标
setIcon(int resId)| 通过资源ID为对话框设置图标
setButton(int whichButton, CharSequence text, DialogInterface.OnClickListener listener) | 为对话框添加按钮
setMessage(CharSequence message) | 为对话框设置提示内容

##### 使用示例

```
AlertDialog dialog = new AlertDialog.Builder(this).create();
dialog.setTitle("退出");
dialog.setMessage("是否要退出");
dialog.setButton(DialogInterface.BUTTON_NEGATIVE, "取消",new OnClickListener() {

    @Override
    public void onClick(DialogInterface arg0, int arg1) {
        // TODO Auto-generated method stub
        Toast.makeText(MainActivity.this, "取消",Toast.LENGTH_SHORT).show();
    }
});

dialog.setButton(DialogInterface.BUTTON_POSITIVE, "确定",new OnClickListener() {

    @Override
    public void onClick(DialogInterface arg0, int arg1) {
        // TODO Auto-generated method stub
        Toast.makeText(MainActivity.this, "确定",Toast.LENGTH_SHORT).show();
    }
});

dialog.show();
```

![13-7](http://ohe7ixo05.bkt.clouddn.com/2018/8/13-7.png)

#### AlertDialog.Builder类

AlertDialog类提供了弹出框的一些基本的方法，但是要想设置更多的元素来丰富我们的弹出框就要使用到AlertDialog.Builder类了。

##### 常用方法

方法 | 描述
---|---
setTitle(CharSequence title) | 为对话框设置标题
setIcon(Drawable icon) | 通过Drawable资源对象为对话框设置图标
setIcon(int resId)| 通过资源ID为对话框设置图标
setMessage(CharSequence message) | 为对话框设置提示内容
setNegativeButton(CharSequence text, DialogInterface.OnClickListener listener) | 为对话框添加取消按钮
setPositiveButton(CharSequence text, DialogInterface.OnClickListener listener) | 为对话框添加确定按钮
setNeutralButton(CharSequence text, DialogInterface.OnClickListener listener) | 为对话框添加中立按钮
setItems(CharSequence[] items, DialogInterface.OnClickListener listener) | 为对话框设置列表项
setSingleChoiceItems(CharSequence[] items, int checkedItem, DialogInterface.OnClickListener listener) | 为对话框设置单选列表项
setMultiChoiceItems(CharSequence[] items, boolean[] checkedItems, DialogInterface.OnMultiChoiceClickListener listener) | 为对话框设置多选列表项

注意：setMessage()、setItems()、setSingleChoiceItems()、setMultiChoiceItems()方法不能同时使用。因为他们都是对弹出框的内容区域的设置。

##### 设置按钮

```
Builder builder = new AlertDialog.Builder(this);
builder.setTitle("更新");
builder.setMessage("是否要进行更新？");
builder.setNegativeButton("取消", new OnClickListener() {

    @Override
    public void onClick(DialogInterface dialog, int whitch) {
        // TODO Auto-generated method stub
        Toast.makeText(MainActivity.this, "取消", Toast.LENGTH_SHORT).show();
    }
});

builder.setPositiveButton("确定", new OnClickListener() {

    @Override
    public void onClick(DialogInterface dialog, int whitch) {
        // TODO Auto-generated method stub
        Toast.makeText(MainActivity.this, "确定", Toast.LENGTH_SHORT).show();
    }
});

builder.setNeutralButton("忽略", new OnClickListener() {

    @Override
    public void onClick(DialogInterface dialog, int whitch) {
        // TODO Auto-generated method stub
        Toast.makeText(MainActivity.this, "忽略", Toast.LENGTH_SHORT).show();
    }
});

builder.show();
```

![13-6](http://ohe7ixo05.bkt.clouddn.com/2018/8/13-6.png)

##### 设置列表项

```
final CharSequence items[] = new String[] {"北京","上海","广州","深圳","成都","南京"};
Builder builder = new AlertDialog.Builder(MainActivity.this);
builder.setTitle("请选择");
builder.setItems(items, new OnClickListener() {

    @Override
    public void onClick(DialogInterface dialog, int whitch) {
        // TODO Auto-generated method stub
        String selectedItem = items[whitch].toString();
        Toast.makeText(MainActivity.this, selectedItem, Toast.LENGTH_SHORT).show();
    }
});

builder.show();
```

![13-5](http://ohe7ixo05.bkt.clouddn.com/2018/8/13-5.png)

##### 设置单选列表项

```
final CharSequence items[] = new String[] {"北京","上海","广州","深圳","成都","南京"};
Builder builder = new AlertDialog.Builder(MainActivity.this);
builder.setTitle("请选择");
builder.setSingleChoiceItems(items, 1, new OnClickListener() {

    @Override
    public void onClick(DialogInterface dialog, int whitch) {
        // TODO Auto-generated method stub
        String selectedItem = items[whitch].toString();
        Toast.makeText(MainActivity.this, selectedItem, Toast.LENGTH_SHORT).show();
    }
});

builder.setNegativeButton("取消", new OnClickListener() {

    @Override
    public void onClick(DialogInterface dialog, int whitch) {
        // TODO Auto-generated method stub
        Toast.makeText(MainActivity.this, "取消", Toast.LENGTH_SHORT).show();
    }
});

builder.setPositiveButton("确定", new OnClickListener() {

    @Override
    public void onClick(DialogInterface dialog, int whitch) {
        // TODO Auto-generated method stub
        dialog.dismiss();
    }
});

builder.show();
```
![13-4](http://ohe7ixo05.bkt.clouddn.com/2018/8/13-4.png)

##### 设置多选列表项

```
CharSequence items[] = new String[] {"北京","上海","广州","深圳","成都","南京"};
boolean[] checkedItems = new boolean[] {true,false,true,true,false,true};
        
Builder builder = new AlertDialog.Builder(MainActivity.this);
builder.setTitle("请选择");
builder.setMultiChoiceItems(items, checkedItems, new OnMultiChoiceClickListener() {

    @Override
    public void onClick(DialogInterface dialog, int whitch, boolean isChecked) {
        // TODO Auto-generated method stub
    
    }
});

builder.setNegativeButton("取消", new OnClickListener() {

    @Override
    public void onClick(DialogInterface dialog, int whitch) {
        // TODO Auto-generated method stub
        Toast.makeText(MainActivity.this, "取消", Toast.LENGTH_SHORT).show();
    }
});

builder.setPositiveButton("确定", new OnClickListener() {

    @Override
    public void onClick(DialogInterface dialog, int whitch) {
        // TODO Auto-generated method stub
        dialog.dismiss();
    }
});

builder.show();
```
![13-3](http://ohe7ixo05.bkt.clouddn.com/2018/8/13-3.png)

#### 自定义AlertDialog

```
Builder builder = new AlertDialog.Builder(MainActivity.this);
builder.setTitle("请输入");
// 通过LayoutInflater来加载布局文件作为一个View对象
View view = LayoutInflater.from(MainActivity.this).inflate(R.layout.alterdialog, null);
// 设置自定义的布局文件作为弹出框的内容
builder.setView(view);
final EditText username = (EditText) view.findViewById(R.id.et_username);
final EditText password = (EditText) view.findViewById(R.id.et_password);

builder.setPositiveButton("确定", new OnClickListener() {

    @Override
    public void onClick(DialogInterface dialog, int whitch) {
        // TODO Auto-generated method stub
        String name = username.getText().toString().trim();
        String pwd = password.getText().toString().trim();
        Toast.makeText(MainActivity.this, name + pwd, Toast.LENGTH_SHORT).show();
    }
});

builder.setNegativeButton("取消", new OnClickListener() {

    @Override
    public void onClick(DialogInterface dialog, int whitch) {
        // TODO Auto-generated method stub
        dialog.dismiss();
    }
});

builder.show();
```

![13-2](http://ohe7ixo05.bkt.clouddn.com/2018/8/13-2.png)

以上多个方法的参数列表都有用到CharSequence，但是我的例子中直接使用的String，所以在这里做一个补充说明。

**CharSequence与String的区别：**

CharSequence与String都能用于定义字符串，但CharSequence的值是可读可写序列，而String的值是只读序列。
