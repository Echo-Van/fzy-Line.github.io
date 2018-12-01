---
title: Android 获取外网 ip 地址详解
tags:
  - Android
  - ip
categories: Android
abbrlink: 61955
date: 2016-07-10 23:10:58
---

　　很多 App 都需要获取当前所在位置，如果需要获取精确地位置当然是使用 GPS 定位啦，但是有时候不需要那么精确的定位，而且手机开启 GPS 进行定位需要用户手动打开 GPS 开关，那么如何无声无息的在后台进行定位呢？其实，只要获取到本机的外网 ip 地址就能够获取你的所在大概地址啦！此篇博客主要讲解如何获取外网 ip，如何通过 ip 进行定位将写在下一篇博客中。

<!--more-->

#### 获取外网ip地址

##### 实现方法

　　想必很多人都查过本机的外网 ip 地址，通过 cmd 的 config 等命令看到的都是内网 ip，要想查看外网 ip 有一个很简单的办法就是在百度输入 ip，点击搜索即可看到自己的外网 ip，这个结果通常是由 www.ip138.com 这个网站提供的，我们点进去可以看到他其实提供了ip地址查询服务。那我们就可以把这个利用起来，这里其实会用到类似爬虫的技术，也就是把网页源代码下下来，然后从源代码中提取 ip 地址。打开浏览器的开发者工具，定位 ip 地址那一行代码，可以看到如下代码：

![10-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/7/10-1.jpg)

　　我们对http://1212.ip138.com/ic.asp发送一个get请求即可获得服务器返回的ip地址信息。

##### android-async-http

　　在 AndroidManifest.xml 文件中加入如下：

```
<uses-permission android:name="android.permission.INTERNET" />
```
　　下载第三方网络请求库：android-async-http 的 jar 包

　　将 jar 包添加到工程，复制到 lib 文件夹下，并右键该 jar 包，点击 BuildPath，然后点击 Add to Build Path。

##### 获取网站返回信息

　　对 http://1212.ip138.com/ic.asp 发送一个 get 请求来获得服务器返回的ip地址信息。

```java
public class IpHttpUtil {
    public static void GetNetIp(final Handler handler, String url) {
        AsyncHttpClient client = new AsyncHttpClient();
        client.get(url, new AsyncHttpResponseHandler() {
        
            @Override
            public void onSuccess(int arg0, Header[] arg1, byte[] bytes) {
                // TODO Auto-generated method stub
                String ipLine = null;
                String response = null;
                try {
                    //字节转字符串，并指定编码方式为GBK，否则会乱码
                    response = new String(bytes, "GBK"); 
                } catch (UnsupportedEncodingException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                System.out.println("返回的信息" + response); //打印返回信息
            }
            
            @Override
            public void onFailure(int arg0, Header[] arg1, byte[] bytes,
            Throwable arg3) {
                // TODO Auto-generated method stub
                String response = new String(bytes);
                System.out.println(response);
            }
        });
    }
}   
```

　　返回信息如下：

![10-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/7/10-2.jpg)

##### Java正则表达式取出字符串

　　我们要从网站返回的 html 中提取 ip 地址则可以通过正则表达式来进行匹配：

　　提取中括号内容的规则：\\[.*\\]，对 Http 请求得到的 response 进行正则匹配，得到字符串：[xxx.xxx.xxx.xxx]，然后再进行字符串切割，取出 ip 地址。

```java
//匹配中括号及其之间的内容
Pattern pattern = Pattern.compile("\\[.*\\]"); 
Matcher matcher = pattern.matcher(response.toString());
if (matcher.find()) {
    ipLine = matcher.group();
}
if(!ipLine.isEmpty()){
    //去掉左右两边的中括号
    ipLine = ipLine.substring(1, ipLine.length() - 1); 
}
System.out.println("ip地址：" + ipLine);
```
　　将获取到的数据通过 Handler 传回到 Activity：
```java
//将得到的ip地址传递给Activity进行显示
Message msg = new Message();
msg.obj = ipLine;
handler.sendMessage(msg);
```
　　在 Activity 中调用 Http 请求：
```java
public class MainActivity extends Activity {

    private TextView mName, mIp;
    private Handler mIpHandler = new Handler() {
        public void handleMessage(Message msg) {
            String res = (String) msg.obj; //取出通过Handler传递过来的字符串
            System.out.println("MainActivity:" + res);
            mIp.setText(res); //显示到界面
        };
    };
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        mName = (TextView) findViewById(R.id.tv_name);
        mIp = (TextView) findViewById(R.id.tv_ip);
        
        mName.setText("你的外网ip地址是：");
        
        //发送Http请求
        String url = "http://1212.ip138.com/ic.asp";
        IpHttpUtil.GetNetIp(mIpHandler, url);
    }
}
```

#### 效果展示


![10-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/7/10-3.jpg)


　　获取了本机的外网 ip 之后就可以通过这个 ip 来进行定位啦！欲知后事如何，请看下回分解！



