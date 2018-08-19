---
title: android图片轮播框架：RollViewPager
tags: '［Android,RollViewPager,图片轮播］'
categories: Android
abbrlink: 26550
date: 2016-12-11 10:59:04
---

　　经常上网逛一逛还是能有不少的收获，以前自己用ViewFlipper控件来实现android的图片轮播效果，做得实在是不怎么样，很多小细节不知道怎么处理，现在好了，在Github上找到一个开源的图片轮播框架，只需要大概30行代码就可以很好地实现图片轮播功能，推荐给大家！

<!--more-->


#### RollViewPager简介

自动轮播的Viewpager，支持无限循环。触摸时会暂停播放，直到结束触摸一个延迟周期以后继续播放。其中的指示器可以为点可以为数字还可以自定义，位置也可以变。

Github项目地址：[https://github.com/Jude95/RollViewPager](https://github.com/Jude95/RollViewPager)

下文大部分均摘抄自该项目的说明文档，可以直接看本博客，也可以到Github上看说明文档，本文旨在宣传该开源框架。

#### 如何使用

以android studio为例：

##### 添加依赖

在gradle中导入包：

```
compile 'com.jude:rollviewpager:1.4.5'
```

##### 添加控件

编写布局文件：

```
<com.jude.rollviewpager.RollPagerView
    android:layout_width="match_parent"
    android:layout_height="180dp"
    app:rollviewpager_play_delay="3000"/>
```

还可以为其添加如下属性：

app:rollviewpager_play_delay="3000" 播放间隔时间，单位ms。填0则不播放。默认为0。

app:rollviewpager_hint_gravity="center" 指示器位置,提供 left , center , right 。默认 center 

app:rollviewpager_hint_color="#7c7c7c" 指示器背景颜色.默认黑色

app:rollviewpager_hint_alpha="80" 指示器背景透明度。0全透明，255不透明。默认0。

app:rollviewpager_hint_paddingLeft="16dp" 指示器左边距

app:rollviewpager_hint_paddingRight="16dp" 指示器右边距

app:rollviewpager_hint_paddingTop="16dp" 指示器上边距

app:rollviewpager_hint_paddingBottom="16dp" 指示器下边距

一般指定一下间隔时间就好了。

##### HintView指示器配置

提供了HintView是对指示器进行自定义，下面的设置一种方式就好了。

```
mRollViewPager.setHintView(new IconHintView(this,R.drawable.point_focus,R.drawable.point_normal)); //指示器为图片
mRollViewPager.setHintView(new ColorPointHintView(this, Color.YELLOW,Color.WHITE)); //指示器为由颜色的点
mRollViewPager.setHintView(new TextHintView(this)); //指示器为文本
mRollViewPager.setHintView(null);//隐藏指示器
```

##### ItemClickListener监听点击事件

```
mRollViewPager.setOnItemClickListener(new OnItemClickListener() {
  @Override
  public void onItemClick(int position) {
      Toast.makeText(MainActivity.this,"Item "+position+" clicked",Toast.LENGTH_SHORT).show();
  }
});
```

##### Adapter

提供以下三种种方便的PagerAdapter供使用。本ViewPager也可以使用其他任意PagerAdapter。

**（1）StaticPagerAdapter**

存储页面的Adapter。view添加进去就存储，不会再次 getView ，减少页面创建消耗，但是会消耗更多的内存。一般自动播放的情况这种方案比较好。不然会大量构造View。 

**概念参照FragmentPagerAdapter。可以用于其他ViewPager。**

**（2）DynamicPagerAdapter**

动态的Adapter，当创建3号view时会销毁1号view(递推)，会时常调用 getView 。增加页面创建消耗，减小内存消耗。 

**概念参照FragmentStatePagerAdapter。可以用于其他ViewPager。**

```
//以上2个Adapter用法类似;
mRollViewPager.setAdapter(new TestNomalAdapter());
private class TestNomalAdapter extends StaticPagerAdapter{
    private int[] imgs = {
            R.drawable.img1,
            R.drawable.img2,
            R.drawable.img3,
            R.drawable.img4,
    };

    @Override
    public View getView(ViewGroup container, int position) {
        ImageView view = new ImageView(container.getContext());
        view.setImageResource(imgs[position]);
        view.setScaleType(ImageView.ScaleType.CENTER_CROP);
        view.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        return view;
    }

    @Override
    public int getCount() {
        return imgs.length;
    }
}
```

**（3）LoopPagerAdapter**

无限循环的Adapter，无限循环上采用的是getCount返回最大的int数的方法，和staticpageradapter页面存储一样。一次创建多次使用。

数据采用StaticPagerAdapter的方案，节省创建View开销。 

**本Adapter只能用于本RollViewPager**

```
mRollViewPager.setAdapter(new TestLoopAdapter(mRollViewPager));
private class TestLoopAdapter extends LoopPagerAdapter{
    private int[] imgs = {
            R.drawable.img1,
            R.drawable.img2,
            R.drawable.img3,
            R.drawable.img4,
    };

    public TestLoopAdapter(RollPagerView viewPager) {
        super(viewPager);
    }

    @Override
    public View getView(ViewGroup container, int position) {
        ImageView view = new ImageView(container.getContext());
        view.setImageResource(imgs[position]);
        view.setScaleType(ImageView.ScaleType.CENTER_CROP);
        view.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        return view;
    }

    @Override
    public int getRealCount() {
        return imgs.length;
    }
}
```

##### 播放控制

rollViewPager.pause()//暂停
rollViewPager.resume()//恢复
rollViewPager.isPlaying()//是否正在播放

#### 示例程序

布局文件：

```
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    xmlns:app="http://schemas.android.com/apk/res-auto">

    <com.jude.rollviewpager.RollPagerView
        android:id="@+id/roll_view_pager"
        android:layout_width="match_parent"
        android:layout_height="180dp"
        app:rollviewpager_play_delay="3000"/>

</LinearLayout>
```

存放4张图片到工程res目录下的drawable文件夹下，命名为img1，img2，img3，img4.

Java文件：

```
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        /**使用RollPagerView实现图片轮播**/
        mRollViewPager = (RollPagerView) view.findViewById(R.id.roll_view_pager);
        //设置播放时间间隔
        mRollViewPager.setPlayDelay(2000);
        //设置透明度
        mRollViewPager.setAnimationDurtion(500);
        //设置适配器
        mRollViewPager.setAdapter(new TestNormalAdapter());
        //设置指示器（顺序依次）
        mRollViewPager.setHintView(new ColorPointHintView(view.getContext(), Color.YELLOW, Color.WHITE));

    }
    
    private class TestNormalAdapter extends StaticPagerAdapter {
        private int[] imgs = {
                R.drawable.img1,
                R.drawable.img2,
                R.drawable.img3,
                R.drawable.img4,
        };

        @Override
        public View getView(ViewGroup container, int position) {
            ImageView view = new ImageView(container.getContext());
            view.setImageResource(imgs[position]);
            view.setScaleType(ImageView.ScaleType.CENTER_CROP);
            view.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
            view.setOnClickListener(new View.OnClickListener()      // 点击事件
            {
                @Override
                public void onClick(View v)
                {
                    Toast.makeText(MainActivity.this, "你点击了第" + (position + 1) + "张图片", Toast.LENGTH_SHORT).show();
                }
            });
            return view;
        }

        @Override
        public int getCount() {
            return imgs.length;
        }
    }
}
```

写到这里，其实还是有话要说。现在连图片轮播都有开源框架了，自己要写的代码真的越来越少，要考虑的问题也越来越少。我们常常说不要重复造轮子，但是越来越觉得自己根本不会造轮子。注重基础，在自己实现过的基础上，再去对比开源框架，如果确实比自己做得好，那你应该认真思考自己写的程序的不足，然后可以采用开源框架进行开发。
