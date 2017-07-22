---
title: Android网络请求框架Android-async-http
date: 2016-08-14 09:42:01
tags: ［Android,网络］
categories: Android
---

　　Http网络数据交互是Android中极其重要并且使用很频繁的模块。前段时间写了一篇博客总结了Android Http网络请求，但是其中还有很多没有考虑到的问题。众所周知，网络请求方式的效率和性能直接影响到APP的整体用户体验流畅性，在我们自己编写网络请求方法中往往不会考虑这么周全。但是，还好有技术大牛为我们提供了开源的第三方网络请求框架：Android-async-http。

<!--more-->

#### Android-async-http简介

Async-http是一款国外的开源框架，是基于Apache HttpClient库的，使用它可以方便快速高效的进行网络数据请求和发送，文件下载和上传。

**特点：**
- 清晰的网络请求回调；
- 内部采用线程池来处理并发请求，限制并发资源使用情况；
- http请求发生在UI（主）线程之外的异步线程中；
- 内置多部分文件上传，不需要第三方库支持；
- 流式Json上传，不需要额外的库；
- 在各种各样的移动连接环境中具备自动智能请求重试机制；
- 等等

#### 简单应用

##### 下载jar包

（1）Github地址：[https://github.com/loopj/android-async-http](https://github.com/loopj/android-async-http)

（2）CSDN下载地址：[http://download.csdn.net/detail/bambooofmottled/7866567](http://download.csdn.net/detail/bambooofmottled/7866567)

（3）也可以自己百度去找，这是一个很受欢迎的开源框架，资源很丰富。

##### 添加到工程

将jar包复制到工程的libs目录下，右键移到Build Path然后点击Add to Build Path。

##### 封装自己的Http请求类

封装了HTTP请求中最常见的GET和POST方法的请求，通过Handler在异步网络请求与UI主线程之间来传递消息。

```
public class HttpUtil {
    
    private static AsyncHttpClient client;
    
    public static void doGet(String url, final Handler handler) {
        client = new AsyncHttpClient();
        //可以为Http请求添加头部信息，比如很多开放的API都需要添加申请到的api-key
        client.addHeader("键", "值");
        client.get(url, new AsyncHttpResponseHandler() {
        
            @Override
            public void onSuccess(int statusCode, Header[] headers,byte[] responseBody) {
                // TODO Auto-generated method stub
                String response = new String(responseBody);
                System.out.println(response);   //打印接收到的数据，以便调试
                Message msg = new Message();    //将数据封装到Message中
                msg.obj = response;
                handler.sendMessage(msg);   //使用Handler将Message传给UI线程，以便刷新界面
            }
    
            @Override
            public void onFailure(int statusCode, Header[] headers,byte[] responseBody, Throwable error) {
                // TODO Auto-generated method stub
                String response = new String(responseBody);
                System.out.println(response);   //打印错误信息，以便调试
            }
        });
    }
    
    public static void doPost(String url, RequestParams params,final Handler handler) {
        client = new AsyncHttpClient();
        //可以为Http请求添加头部信息，比如很多开放的API都需要添加申请到的api-key
        client.addHeader("键", "值");
        client.post(url, params, new AsyncHttpResponseHandler() {
        
            @Override
            public void onSuccess(int statusCode, Header[] headers,byte[] responseBody) {
                // TODO Auto-generated method stub
                String response = new String(responseBody);
                System.out.println(response);   //打印接收到的数据，以便调试
                Message msg = new Message();
                msg.obj = response; //将数据封装到Message中
                handler.sendMessage(msg);   //使用Handler将Message传给UI线程，以便刷新界面
            }
            
            @Override
            public void onFailure(int statusCode, Header[] headers,byte[] responseBody, Throwable error) {
                // TODO Auto-generated method stub
                String response = new String(responseBody);
                System.out.println(response);   //打印错误信息，以便调试
            }
        });
    }
}
            

```

#### 使用示例

调用自己封装好的GET请求和POST请求方法都需要传递Handler来传递消息，以便在网络请求我完成时，将服务器返回的数据传递给UI线程，然后进行UI更新。

```
public class MainActivity extends Activity {

    private Handler mGetHandler = new Handler() {
        public void handleMessage(android.os.Message msg) {
            String res = (String) msg.obj;
            Toast.makeText(MainActivity.this, "请求成功", Toast.LENGTH_SHORT).show();
            System.out.println(res);    //打印传递过来的数据
            
            //此处，拿到数据之后就可以解析数据，比如JSON数据解析，然后进行UI的更新
        };
    };
    
    private Handler mPostHandler = new Handler() {
        public void handleMessage(android.os.Message msg) {
            String res = (String) msg.obj;
            Toast.makeText(MainActivity.this, "请求成功", Toast.LENGTH_SHORT).show();
            System.out.println(res);    //打印传递过来的数据
            
            //此处，拿到数据之后就可以解析数据，比如JSON数据解析，然后进行UI的更新
        };
    };
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        String getUrl = "你的get请求的url";
        HttpUtil.doGet(getUrl, mGetHandler);
        
        String postUrl = "你的post请求的url";
        RequestParams params = new RequestParams();
        params.add("键", "值");       //可通过add方法添加多个请求参数
        HttpUtil.doPost(postUrl, params, mPostHandler);
    }

}

```

此博客主要展示了如何使用Android-async-http的GET和POST请求，这也是我自己在开发中最常用的两个请求方法，虽然这只是这个强大的网络请求库的一部分功能，但是这已经让我的开发变得更方便高效，也使得开发的应用程序的网络请求能够稳定高效，除此之外，Android-async-http还有很多优秀的功能，有机会再好好挖掘，先分享到这里。