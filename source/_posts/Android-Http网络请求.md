---
title: Android Http网络请求
tags: '［Android,Http］'
categories: Android
abbrlink: 42080
date: 2016-08-05 21:36:44
---

　　Android网络编程（特别是Http请求）是Android学习中比较重要的内容，也是Android开发中比较常用的内。虽然已经有很多优秀的第三方开源框架供我们使用，也大大提升了我们的开发效率，但是也因此我们对基本Http请求的并不熟悉，我们应该重视基础，从底层去了解网络请求的实现机制。此篇博客总结了Android两种基本的网络请求方式，并通过一个简单的Demo进行实践。

<!--more-->

#### Android网络编程注意事项

- 安卓的耗时操作（如I/O流操作）的逻辑不能写在主线程，必须写在子线程。
- 子线程在安卓2.3以后不能更新UI界面（更新就报错），子线程想要更新界面必须结合Handler或者AsyncTask等才可以。
- Android网络操作均需添加网络访问权限：

```
<uses-permission android:name="android.permission.INTERNET"/>
```

#### 说明事项

以下代码中的GET请求都是对博主博客的一个404页面发送的请求，会返回该页面的html代码，POST请求都是对博主服务器上的一个用户注册API接口发送的请求，其中请求参数包括用户名和密码，如果服务器中的数据库已经存在此账号则会返回一个exist，如果注册成功则会返回一个success，否则返回一个error。

#### 使用HttpURLConnection访问网络

HttpURLConnection类位于java.net包中，用于发送HTTP请求和获取HTTP响应。该类是抽象类，不能直接实例化，要使用URL的openConnection()方法获得。

##### 发送GET请求

```
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

GET方法在传递中文参数时，会产生乱码，要进行Base64编码来解决乱码问题。


```
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
##### 发送POST请求

```
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

#### 使用HttpClient访问网络

对于比较复杂的联网操作，使用HttpUrlConnection就不一定能够满足要求，此时，可以使用Apache组织提供的HttpClient项目来实现。HttpClient中将HttpUrlConnection类中的输入/输出流操作统一封装成HttpGet、HttpPost和HttpResponse类。其中HttpGet类代表发送GET请求、HttpPost代表发送POST请求、HttpResponse类代表处理响应的对象。

##### 发送GET请求

###### 使用流程

（1）创建HttpClient对象

（2）创建HttpGet对象

（3）如需添加参数，可以在url中添加参数，也可调用HttpGet的setParams()方法来添加请求参数。

（4）调用HttpClient对象的execute()方法发送请求。

（5）调用HttpResponse的getEntity()方法获得包含服务器响应内容的HttpEntity对象。

###### 使用示例

```
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

##### 发送POST请求

###### 使用流程

（1）创建HttpClient对象

（2）创建HttpGet对象

（3）调用HttpPost的setParams()方法来添加请求参数，也可调用setEntity()方法来设置请求参数。

（4）调用HttpClient对象的execute()方法发送请求。

（5）调用HttpResponse的getEntity()方法获得包含服务器响应内容的HttpEntity对象。

###### 使用示例：
```
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

#### 简单的Demo

通过在MainActivity中使用子线程分别调用以上四个方法来发送Http请求，并通过Handler在子线程和主线程之间传递消息，通知主线程更新UI，以此来测试所写的方法是否可行。


```
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