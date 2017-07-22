---
title: Android ImageView实现圆形头像
date: 2016-05-17 21:28:02
tags: ［Android,ImageView］
categories: Android
---

#### 原理解析

先在canvas上面画一个圆形，参照圆形的起点坐标、半径，再画一个边长为圆的直径的bitmap（这个bitmap就是你想画的圆形头像），此时圆和bitmap重叠在一起，圆在下面，bitmap在上面，bitmap覆盖着圆。

<!--more-->

这时，圆形和bitmap相交的部分正是圆大小的面积，如果能将bitmap与圆相交之外的部分去掉，那么我们看到的就是bitmap的圆形部分了。

#### 代码实现

```
public Bitmap toRoundBitmap(Bitmap bitmap) {  
    //圆形图片宽高  
    int width = bitmap.getWidth();  
    int height = bitmap.getHeight();  
    //正方形的边长  
    int r = 0;  
    //取最短边做边长  
    if(width &amp;amp;gt; height) {  
        r = height;  
    } else {  
        r = width;  
    }  
    //构建一个bitmap  
    Bitmap backgroundBmp = Bitmap.createBitmap(width,  
             height, Config.ARGB_8888);  
    //new一个Canvas，在backgroundBmp上画图  
    Canvas canvas = new Canvas(backgroundBmp);  
    Paint paint = new Paint();  
    //设置边缘光滑，去掉锯齿  
    paint.setAntiAlias(true);  
    //宽高相等，即正方形  
    RectF rect = new RectF(0, 0, r, r);  
    //通过制定的rect画一个圆角矩形，当圆角X轴方向的半径等于Y轴方向的半径时，  
    //且都等于r/2时，画出来的圆角矩形就是圆形  
    canvas.drawRoundRect(rect, r/2, r/2, paint);  
    //设置当两个图形相交时的模式，SRC_IN为取SRC图形相交的部分，多余的将被去掉  
    paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));  
    //canvas将bitmap画在backgroundBmp上  
    canvas.drawBitmap(bitmap, null, rect, paint);  
    //返回已经绘画好的backgroundBmp  
    return backgroundBmp;  
}  
```

#### 使用详解


##### 从res目录下的drawable文件夹获取图片资源进行转换

```
// 以数据流的方式读取bitmap资源
Resources r = this.getResources();
InputStream is = r.openRawResource(R.drawable.iv_head);
BitmapDrawable bmpDraw = new BitmapDrawable(is);
Bitmap bmp = bmpDraw.getBitmap();
 
// 将图片转换成圆形图片
Bitmap bm = toRoundBitmap(bmp);
 
//传给imagview进行显示
imageview.setImageBitmap(bm);
```

##### 从sdcard中获取图片资源进行转换

注意：需添加sdcard读取数据的权限

```
Bitmap bmp = BitmapFactory.decodeFile(path) (path 是图片的路径，根目录是/sdcard)
 
// 将图片转换成圆形图片
Bitmap bm = toRoundBitmap(bmp);
 
//传给imagview进行显示
imageview.setImageBitmap(bm);
```