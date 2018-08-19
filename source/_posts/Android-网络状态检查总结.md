---
title: Android 网络状态检查总结
tags: '［Android,网络］'
categories: Android
abbrlink: 40119
date: 2016-07-20 23:14:01
---

　　几乎每个具有连网功能的App都会有网络检测代码专门负责网络检测，需要实时检测网络是否可用，当出现网络不可用或者无连接时提示用户，当需要观看视频时自动检测是否处于wifi网络，并提示用户避免带来大量的流量消耗，所有的这些功能都是为了使App的用户体验更好。此篇博客主要介绍检测网络状态的相关方法，并通过一个小例子来实现实时的网络状态检测。

<!--more-->

#### 添加权限

在AndroidManifest.xml文件添加：

```
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>  
<uses-permission android:name="android.permission.INTERNET"/>  
```

#### 编写相应的检测方法

##### 判断网络是否可用的方法

```
public boolean isNetworkAvailable(Context context) {
    ConnectivityManager mConnectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
    if (mConnectivityManager != null) {
        NetworkInfo mNetworkinfo = mConnectivityManager.getActiveNetworkInfo();
        if (mNetworkinfo != null) {
            return mNetworkinfo.isAvailable();
        }
    }
    return false;
}
```

##### 判断WIFI网络是否连接上的方法

```
public boolean isWifiConnected(Context context) {

    ConnectivityManager mConnectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
    if (mConnectivityManager != null) {
        NetworkInfo mWiFiNetworkInfo = mConnectivityManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        if (mWiFiNetworkInfo != null && mWiFiNetworkInfo.isConnected()) {
            return true;
        }
    }
    return false;
}
```


##### 判断GPRS网络是否连接上的方法

```
public boolean isMobileConnected(Context context) {

    ConnectivityManager mConnectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
    if (mConnectivityManager != null) {
        NetworkInfo mMobileNetworkInfo = mConnectivityManager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
        if (mMobileNetworkInfo != null && mMobileNetworkInfo.isConnected()) {
            return true;
        }
    }
    return false;
}
```


##### 获取所连接网络的类型的方法

```
public String getNetworkType(Context context) {
    ConnectivityManager mConnectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
    if (mConnectivityManager != null) {
        NetworkInfo mNetworkinfo = mConnectivityManager.getActiveNetworkInfo();
        if (mNetworkinfo != null && mNetworkinfo.isAvailable()) {
            String info = "Type: " + mNetworkinfo.getType() + "    Name: "+ mNetworkinfo.getTypeName();
            return info;
        }
    }
    return "网络无连接，请检查网络";
    }
```

#### 实现网络状态监测

使用Service+BroadcastReceiver来实现相应的功能。

##### 编写网络状态检测类

```
public class NetState extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        // TODO Auto-generated method stub
        ConnectivityManager mConnectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (mConnectivityManager != null) {
            NetworkInfo mMobileNetworkInfo = mConnectivityManager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
            NetworkInfo mWiFiNetworkInfo = mConnectivityManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
            
            if (!mMobileNetworkInfo.isConnected()&& !mWiFiNetworkInfo.isConnected()) {
                Toast.makeText(context, "网络连接断开，请检查网络", Toast.LENGTH_SHORT).show();
            } else {
                Toast.makeText(context, "网络连接成功", Toast.LENGTH_SHORT).show();
            }
        }
    }

}
```

##### 在Activity的onCreate方法中注册监听

```
NetState mNetState = new NetState();    //获取网络监听实例
IntentFilter mFilter = new IntentFilter(); //获取意图过滤器实例
mFilter.addAction(ConnectivityManager.CONNECTIVITY_ACTION); //过滤Action，使只监听网络动作事件的广播
this.registerReceiver(mNetState, mFilter);  //注册广播接收器
mNetState.onReceive(this, null);    //调用广播接收方法
```

#### 效果演示

自己写了一个Android网络检测的演示demo，使用了刚刚学会的录屏生成动图软件以及刚刚安装上的wordpress动图插件。

![image](http://note.youdao.com/favicon.ico)






