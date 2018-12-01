---
title: Android Http 网络请求
tags:
  - Android
  - Http
categories: Android
abbrlink: 42080
date: 2016-08-05 21:36:44
---

　　Android 网络编程（特别是 Http 请求）是 Android 学习中比较重要的内容，也是 Android 开发中比较常用的内。虽然已经有很多优秀的第三方开源框架供我们使用，也大大提升了我们的开发效率，但是也因此我们对基本 Http 请求的并不熟悉，我们应该重视基础，从底层去了解网络请求的实现机制。此篇博客总结了 Android 两种基本的网络请求方式，并通过一个简单的 Demo 进行实践。

<!--more-->

#### Android 网络编程注意事项

- 安卓的耗时操作（如 I/O 流操作）的逻辑不能写在主线程，必须写在子线程。
- 子线程在安卓 2.3 以后不能更新 UI 界面（更新就报错），子线程想要更新界面必须结合 Handler 或者 AsyncTask 等才可以。
- Android 网络操作均需添加网络访问权限：

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

#### 说明事项

　　以下代码中的 GET 请求都是对博主博客的一个 404 页面发送的请求，会返回该页面的 html 代码，POST 请求都是对博主服务器上的一个用户注册 API 接口发送的请求，其中请求参数包括用户名和密码，如果服务器中的数据库已经存在此账号则会返回一个 exist，如果注册成功则会返回一个 success，否则返回一个 error。

#### HttpURLConnection

　　HttpURLConnection 类位于 java.net 包中，用于发送 HTTP 请求和获取 HTTP 响应。该类是抽象类，不能直接实例化，要使用URL的 openConnection() 方法获得。

##### 发送 GET 请求

```java
public void get() {
    try {
        URL url = new URL("http://blog.line-coding.tech/");
        HttpURLConnection huc = (HttpURLConnection) url.openConnection();
        // mUrlConnection.setRequestMethod("GET"); //默认就是GET方式，此声明可不要
        //获取字节流，并将字节流转换成字符流
        InputStreamReader isr = new InputStreamReader(huc.getInputStream());         //缓冲字符流，以便读取
        BufferedReader br = new BufferedReader(isr);    
        String inputLine = null;
        //按行读取数据
        while ((inputLine = br.readLine()) != null) {
            result += inputLine + "\n";
        }
        isr.close();    //关闭输入流
        huc.disconnect();   //关闭连接
    } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}
```

　　GET 方法在传递中文参数时，会产生乱码，要进行 Base64 编码来解决乱码问题。


```java
public String base64Encode(String params) {
    try {
        params = Base64.encodeToString(params.getBytes("utf-8"), Base64.DEFAULT);
        params = URLEncoder.encode(params,"utf-8");
    } catch (UnsupportedEncodingException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
    return params;
}
    
```
##### 发送 POST 请求

```java
public void post() {
    try {
        URL url = new URL("http://data.line-coding.tech/register.php");
        HttpURLConnection huc = (HttpURLConnection) url.openConnection();
        huc.setRequestMethod("POST");
        huc.setDoInput(true); // 向连接中写入数据
        huc.setDoOutput(true); // 向连接中读取数据
        huc.setUseCaches(false); // 禁止缓存
        huc.setInstanceFollowRedirects(true); // 自动执行Http重定向
        huc.setRequestProperty("Content-Type","application/x-www-form-urlencoded");  //设置内容类型
        DataOutputStream dos = new DataOutputStream(huc.getOutputStream()); //获取输出流
        String params = "username=13674852343" + "&password=123456";    //添加请求参数
        dos.writeBytes(params);     //将数据写入到输出流
        dos.flush();    //输出缓存
        dos.close();    //关闭输出流
        if (huc.getResponseCode() == HttpURLConnection.HTTP_OK) {
            InputStreamReader isr = new InputStreamReader(
            huc.getInputStream());
            BufferedReader br = new BufferedReader(isr);
            String inputLine = null;
            while ((inputLine = br.readLine()) != null) {
                result += inputLine + "\n";
            }
            isr.close();
        }
        huc.disconnect();   //关闭连接
    } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}
```

#### HttpClient

　　对于比较复杂的联网操作，使用 HttpUrlConnection 就不一定能够满足要求，此时，可以使用 Apache 组织提供的 HttpClient 项目来实现。HttpClient 中将 HttpUrlConnection 类中的输入/输出流操作统一封装成 HttpGet、HttpPost 和 HttpResponse 类。其中 HttpGet 类代表发送 GET 请求、HttpPost 代表发送 POST 请求、HttpResponse 类代表处理响应的对象。

##### 发送 GET 请求

- 使用流程

1. 创建 HttpClient 对象

2. 创建 HttpGet 对象

3. 如需添加参数，可以在 url 中添加参数，也可调用 HttpGet 的 setParams() 方法来添加请求参数。

4. 调用 HttpClient 对象的 execute() 方法发送请求。

5. 调用 HttpResponse 的 getEntity() 方法获得包含服务器响应内容的 HttpEntity 对象。

- 使用示例

```java
public void getMethod() {
        
    String url = "http://blog.line-coding.tech/";
    try {
        HttpClient client = new DefaultHttpClient();    //创建HttpClient对象
        HttpGet get = new HttpGet(url);     //创建HttpGet对象
        HttpResponse response = client.execute(get);    //执行HttpClient请求
        if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
            result = EntityUtils.toString(response.getEntity());    //获取返回结果
        } else {
            result = "请求失败";
        }
    } catch (ClientProtocolException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}
```

##### 发送 POST 请求

- 使用流程

1. 创建 HttpClient 对象

2. 创建 HttpGet 对象

3. 调用 HttpPost 的 setParams() 方法来添加请求参数，也可调用 setEntity() 方法来设置请求参数。

4. 调用 HttpClient 对象的 execute() 方法发送请求。

5. 调用 HttpResponse 的 getEntity() 方法获得包含服务器响应内容的 HttpEntity 对象。

- 使用示例：

```java
public void postMethod() {
    
    String url = "http://data.line-coding.tech/register.php";
    HttpClient client = new DefaultHttpClient();    //创建HttpClient对象
    HttpPost post = new HttpPost(url);      //创建HttpGet对象
    List<NameValuePair> params = new ArrayList<NameValuePair>();
    params.add(new BasicNameValuePair("username", "13674852343"));
    params.add(new BasicNameValuePair("password", "123456"));   
    try {
        post.setEntity(new UrlEncodedFormEntity(params,"utf-8"));   //添加参数
        HttpResponse response = client.execute(post);   //执行HttpClient请求
        if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) { //判断请求是否成功
            result = EntityUtils.toString(response.getEntity());    //获取返回结果
        } else {
            result = "请求失败";
        }
    } catch (UnsupportedEncodingException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    } catch (ClientProtocolException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    };  
}
```

#### 简单的 Demo

　　通过在 MainActivity 中使用子线程分别调用以上四个方法来发送 Http 请求，并通过 Handler 在子线程和主线程之间传递消息，通知主线程更新 UI，以此来测试所写的方法是否可行。


```java
private TextView mTextView;
private String result = "";

private Handler mHandler = new Handler() {
    public void handleMessage(Message msg) {
        if (result != null) {
            mTextView.setText(result);  //收到通知，则将Http请求的结果显示在界面上
        }
    };
};

@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    
    mTextView = (TextView) findViewById(R.id.tv_result);

    new Thread(new Runnable() {     //开启子线程来执行网络请求

        @Override
        public void run() {
            // TODO Auto-generated method stub
            get();  //使用HttpURLConnection的GET方法
            //post();     //使用HttpURLConnection的POST方法
            //getMethod();  //使用HttpClient的GET方法
            //postMethod(); //使用HttpClient的POST方法
            Message msg = mHandler.obtainMessage(); //获取一个Message对象
            mHandler.sendMessage(msg);  //通知UI进行更新
        }
    }).start();
}
```