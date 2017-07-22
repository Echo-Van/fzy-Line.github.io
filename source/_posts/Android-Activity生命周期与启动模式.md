---
title: Android Activity生命周期与启动模式
date: 2016-08-09 09:04:23
tags: ［Android,Activity］
categories: Android
---

　　Android 程序的生命周期是由系统控制而非程序自身直接控制，因此了解和管理Activity的生命周期对于Android应用程序开发来说都是十分重要的。本文通过实例演示了Activity的生命周期，并对Android的任务栈设计以及Activity的启动模式进行了介绍。

<!--more-->

#### Activity生命周期

官方文档对Activity的生命周期进行了详细的描述，其中，示意图如下：


![9-1](http://ohe7ixo05.bkt.clouddn.com/2016/8/9-1.png)

在Activity的生命周期里会调用以下方法，具体的描述如下表：

方法 | 描述
---|---
onCreat() | 当activity启动时调用
onStart() | 当activity对用户来说可见时调用
onResume() | 当activity将要开始与用户进行交互时调用
onPause() | 当系统将要开始恢复以前的activity时调用。
onStop() | 当activity不再对用户可见时调用，因为另一个活动已恢复，并覆盖了这一个。 
onRestart() | 当一个activity被停止后，被重新启动时调用
onDestroy() | 当activity被销毁时调用 

我们通过重写以上7个方法来观察各个方法的执行情况：

MianActivity.java:
```
public class MainActivity extends Activity {

    private Button mButton;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        System.out.println("MainActivity: onCreate()");
        
        mButton = (Button) findViewById(R.id.btn_to_another);
        
        mButton.setOnClickListener(new OnClickListener() {
        
            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                Intent intent = new Intent(MainActivity.this,AnotherActivity.class);
                startActivity(intent);
            }
        });
    }
    
    @Override
    protected void onStart() {
        // TODO Auto-generated method stub
        super.onStart();
        System.out.println("MainActivity: onStart()");
    }
    
    @Override
    protected void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
        System.out.println("MainActivity: onResume()");
    }
    
    @Override
    protected void onPause() {
        // TODO Auto-generated method stub
        super.onPause();
        System.out.println("MainActivity: onPause()");
    }
    
    @Override
    protected void onRestart() {
        // TODO Auto-generated method stub
        super.onRestart();
        System.out.println("MainActivity: onRestart()");
    }
    
    @Override
    protected void onStop() {
        // TODO Auto-generated method stub
        super.onStop();
        System.out.println("MainActivity: onStop()");
    }
    
    @Override
    protected void onDestroy() {
        // TODO Auto-generated method stub
        super.onDestroy();
        System.out.println("MainActivity: onDestroy()");
    }
    
}

```

AnotherActivity的代码与MainActivity的代码基本相同，在这里就不再贴代码了。

以下是运行程序之后各个情况下的控制台输出：

##### App启动时

```
MainActivity: onCreat()
MainActivity: onStart()
MainActivity: onResume()  
```

##### 锁屏或者按下Home键时

```
MainActivity: onPause()
MainActivity: onStop()
```

##### 解锁或者返回到App时

```
MainActivity: onRestart()
MainActivity: onStart()
MainActivity: onResume()
```

##### 按下Back键时

```
MainActivity: onPause()
MainActivity: onStop()
MainActivity: onDestroy()
```


##### 按下跳转到AnotherActivity按钮时

```
MainActivity: onPause()
AnotherActivity: onCreat()
AnotherActivity: onStart()
AnotherActivity: onResume()
MainActivity: onStop()
```

##### 按下跳转到MainActivity按钮时

```
AnotherActivity: onPause()
MainActivity: onCreat()
MainActivity: onStart()
MainActivity: onResume()
AnotherActivity: onStop()
```
可以看到，我们在跳转到AnotherActivity时MainActivity并没有被Destroy掉，但是我们按下跳转到MainActivity的按钮时执行了onCeate()方法，即重新创建了一个MainActivity实例，这是为什么呢？其实，这就和Activity的启动模式有关了，请看下文Activity的启动模式。

##### 再按下Back键时

```
MainActivity: onPause()
AnotherActivity: onRestart()
AnotherActivity: onStart()
AnotherActivity: onResume()
MainActivity: onStop()
MainActivity: onDestroy()
```

注意看，我们在不同的Activity之间切换时，都是先执行的本Activity的onPause()方法，待新的Activity创建启动并显示出来之后，才执行本Activity的onStop()方法，这样的生命周期设计是有他的道理的，首先防止同时显示两个Activity，然后防止另一个Activity启动失败，导致出现黑屏的情况。

#### Activity四种启动模式


Android采用Task来管理多个Activity，任务栈(task stack)，又称为后退栈(back stack)，记录存放用户开启的activity的。在Android操作系统里面会存在多个任务栈，应用程序一被开启系统就给他分配一个任务栈，当所有的Activity都退出的时候，任务栈就清空了，置于栈顶的Activity就是用户看到的Activity。

##### standard模式

默认模式，可以不用写配置。在这个模式下，每次激活Activity都会默认创建一个新的实例。因此，在这种模式下，可以有多个相同的实例，也允许多个相同Activity叠加。


##### singleTop模式

可以有多个实例，但是不允许多个相同Activity叠加。分为两种情况：

（1）如果Activity在栈顶的时候，启动相同的Activity，不会创建新的实例，而会调用其onNewIntent方法。

（2）如果Activity不在栈顶的时候，启动Activity时会创建新的实例。

##### singleTask模式

只有一个实例。分为三种情况：

（1）如果启动的目标Activity不存在Task栈中,系统将会创建一个目标Activity实例,并将它加入到Task栈顶。

（2）如果启动的目标Activity已存在Task栈顶,此时模式和singleTop模式相同。

（3）若果启动的目标Activity已存在但没有位于Task栈顶,系统将会把该目标Activity上面的所有Activity移除Task栈,使该Activity置于Task栈顶。

##### singleInstance模式

只有一个实例，并且这个实例独立运行在一个task中，这个task只有这个实例，不允许有别的Activity存在。

此启动模式和我们使用的浏览器工作原理类似，我们都知道在多个程序中访问浏览器时，如果当前浏览器没有打开，则打开浏览器，否则会在当前打开的浏览器中访问。此模式会节省大量的系统资源，因为他能保证要请求的Activity对象在当前的栈中只存在一个。


##### 配置启动模式

Android Activity的启动方式可以在AndroidManifest.xml文件的activity标签中的android:launchMode属性进行配置：

```
<activity android:name="com.example.activitydemo.MainActivity"
    android:label="@string/app_name" 
    android:launchMode="standard">
</activity>
```
有兴趣的话也可以自己写一个小的Demo来对这四种启动模式进行测试，通过创建几个Activity以及切换按钮，然后在各个Activity的onCreat()方法中写入下面的语句来打印activity实例的标识信息：

```
System.out.println(toString());
```

通过控制台打印的内容我们可以区分Activity启动时是否创建了新的实例。

通过了解Android Activity的启动模式，我们就可以回答上文中Activity生命周期中留下的问题啦，因为Activity默认配置上启动模式是：standard，因此我们每次启动Activity都会创建新的实例。为Activity选择合适的启动模式可以节省更多的资源，这对于应用程序开发很重要。


