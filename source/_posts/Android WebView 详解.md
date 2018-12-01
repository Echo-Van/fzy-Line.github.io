---
title: Android WebView 详解
tags:
  - Android
  - Webview
categories: Android
abbrlink: 27349
date: 2016-08-26 09:55:11
---

　　Android 提供了内置的浏览器，该浏览器使用了开源的 WebKit 引擎，要使用内置的浏览器就需要通过 WebView 来实现。Android WebView 在 Android 平台上是一个特殊的 View， 它能用来显示网页，这个类可以被用来在你的 App 中仅仅显示一张在线的网页，还可以用来开发浏览器。本文详细介绍了 WebView 的相关方法以及配置操作，最后通过一个简易的浏览器对 WebView 进行应用演示。

<!--more-->

#### 基本使用

##### 基本方法

方法 | 描述
---|---
loadUrl(String url) | 用于加载指定url对应得网页
goBack() | 执行后退操作，相当于浏览器的回退按钮功能
goForward() | 执行前进操作，相当于浏览器的前进按钮功能
stopLoading() | 用于停止加载当前页面
reload() | 用于刷新当前页面

##### 使用示例

　　访问百度首页：

```java
mWebView = (WebView) findViewById(R.id.webView1);
mWebView.loadUrl("http://www.baidu.com/");
```

　　这个时候发现一个问题，启动应用后，自动的打开了系统内置的浏览器，解决这个问题需要为 webview 设置 WebViewClient，并重写重写 WebViewClient 的 shouldOverrideUrlLoading 方法返回 true，这样新的连接就会在当前 WebView 中打开。

```java
mWebView.setWebViewClient(new WebViewClient(){
    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String url){
        view.loadUrl(url);
        return true;
    }
});
```

#### 进阶使用

##### WebSettings常用方法

　　获取设置 WebView 的 WebSettings 对象。

```java
mWebView.getSettings()  //得到WebSettings对象
```

1. 设置支持自动加载图片

```java
mWebView.getSettings().setLoadsImagesAutomatically(true);
```
2. 设置支持放大和缩小的功能

```java
mWebView.getSettings().setSupportZoom(true); 
mWebView..getSettings().setBuiltInZoomControls(true)

```

3. 设置支持多窗口

```java
mWebView.getSettings().supportMultipleWindows();
```

4. 设置支持JavaScript

```java
mWebView.getSettings().setJavaScriptEnabled(true);
```
5. 设置将图片调整到适合webview的大小 

```java
mWebView.getSettings().setUseWideViewPort(false);  
```

6. 设置支持插件 

```java
mWebView.getSettings().setPluginsEnabled(true);
```

##### WebViewClient常用方法

　　设置将接收各种通知和请求的WebViewClient。

```java
mWebView.setWebViewClient(new WebViewClient(){
    //可在此重写下列方法，以实现相应需求
});
```
1. 开始载入页面时调用

```java
onPageStarted(WebView view, String url, Bitmap favicon)
```

2. 在页面加载结束时调用

```java
onPageFinished(WebView view, String url)
```

3. 在加载页面资源时调用

```java
onLoadResource(WebView view, String url)
```

4. 报告错误信息

```java
onReceivedError(WebView view, int errorCode, String description, String failingUrl)
```

5. 重写此方法才能够处理在浏览器中的按键事件

```java
shouldOverrideKeyEvent(WebView view, KeyEvent event)
```
6. 控制新的连接在当前WebView中打开

```java
shouldOverrideUrlLoading(WebView view, String url)
```

##### WebChromeClient常用方法

　　设置chrome处理。

```java
mWebView.setWebChromeClient(new WebChromeClient() {
    //可在此重写下列方法，以实现相应需求
});

```
1. 网页加载进度改变时调用

```java
onProgressChanged(WebView view, int newProgress)
```

2. 网页加载完毕时获取网站标题

```java
onReceivedTitle(WebView view, String title)
```

3. 创建WebView时

```java
onCreateWindow(WebView view, boolean isDialog,boolean isUserGesture, Message resultMsg)
```
4. 关闭WebView时

```java
onCloseWindow(WebView window)
```

5. 网页加载完毕时获取网站图标

```java
onReceivedIcon(WebView view, Bitmap icon) 
```

6. WebView获得焦点时

```java
onRequestFocus(WebView view)
```

##### 浏览器开发小技巧

1. 设置 android WebView 不显示滚动条

　　可以直接在 layout 中添加如下属性设置

```java
android:scrollbars="none"
```
2. 一些清除方法

```java
mWebView.clearHistory();    //清除当前webview访问的历史记录
mWebView.clearFormData();   //清除自动完成填充的表单数据
mWebView.clearCache();   //清除网页访问留下的缓存
mWebView.clearMatches();      //清除网页查找的高亮匹配字符
```


#### 自制简易浏览器

　　带前进、后退、主页、刷新按钮，网页加载进度条，网址输入框的简单浏览器。实现效果如下：

![26-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/8/26-1.jpg)

##### 添加网络访问权限
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

##### MainActivity.java

```java
public class MainActivity extends Activity implements OnClickListener {

    private WebView mWebView;
    private ImageButton mBack, mHome, mNext, mRefresh;
    private EditText mEditText;
    private ProgressBar mProgressBar;
    private String homeUrl = "www.baidu.com";
    
    @SuppressLint("SetJavaScriptEnabled")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_main);
        
        mWebView = (WebView) findViewById(R.id.wb_test_web);
        mBack = (ImageButton) findViewById(R.id.ib_back);   //返回按钮
        mHome = (ImageButton) findViewById(R.id.ib_home);   //主页按钮
        mNext = (ImageButton) findViewById(R.id.ib_next);   //前进按钮
        mRefresh = (ImageButton) findViewById(R.id.ib_refresh);     //刷新按钮
        mEditText = (EditText) findViewById(R.id.et_url);   //网址输入框
        mProgressBar = (ProgressBar) findViewById(R.id.pb_load);    //网页加载进度条
        
        /*设置监听事件*/
        mBack.setOnClickListener(this);
        mHome.setOnClickListener(this);
        mNext.setOnClickListener(this);
        mRefresh.setOnClickListener(this);
        mEditText.setOnClickListener(this);
        
        /*WebView的基本设置*/
        mWebView.getSettings().setJavaScriptEnabled(true);
        mWebView.getSettings().setSupportZoom(true);
        mWebView.getSettings().setBuiltInZoomControls(true);
        mWebView.setInitialScale(25);
        mWebView.getSettings().setUseWideViewPort(true);
        mWebView.setWebViewClient(new WebViewClient());
        
        mWebView.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onProgressChanged(WebView view, int newProgress) {
                // TODO Auto-generated method stub
                mProgressBar.setProgress(newProgress);  //设置进度
                System.out.println(newProgress);
                if (newProgress == 100) {
                    mProgressBar.setVisibility(View.GONE);  //加载完后设置进度条不可见
                }else{
                    mProgressBar.setVisibility(View.VISIBLE);   //设置进度条可见
                }
                super.onProgressChanged(view, newProgress);
            }
        
            @Override
            public void onReceivedTitle(WebView view, String title) {
                // TODO Auto-generated method stub
                mEditText.setText(title);   //网站加载完后，
                super.onReceivedTitle(view, title);
            }
        });
        
        /*加载主页*/
        loadWeb(homeUrl);
        
        mEditText.setOnKeyListener(new OnKeyListener() {
        
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                // TODO Auto-generated method stub
                String url = mEditText.getText().toString();
                if (keyCode == KeyEvent.KEYCODE_ENTER) {
                    if (!url.equals("")) {
                        loadWeb(url);
                        return true;
                    }
                } else {
                    Toast.makeText(MainActivity.this, "请输入要访问的网址",
                        Toast.LENGTH_SHORT).show();
                    }
                    return false;
                }
            });
        }
        
        public void loadWeb(String url) {
            url = "http://" + url;      //补全url
            mWebView.loadUrl(url);      //加载页面
        }
        
        @Override
        public void onClick(View v) {
            // TODO Auto-generated method stub
            switch (v.getId()) {
            case R.id.ib_back:
                mWebView.goBack();      //返回上一个页面
                break;
            case R.id.ib_home:
                loadWeb(homeUrl);       //回到主页
                break;
            case R.id.ib_next:
                mWebView.goForward();   //前进到下一个页面
                break;
            case R.id.ib_refresh:
                mWebView.reload();      //重新加载
                break;
            case R.id.et_url:
                mEditText.setText("");  //输入网站
                mEditText.setHint("请输入网址");
                break;
            default:
                break;
        }
    }
}
```