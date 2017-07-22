---
title: Android获取yeelink云端数据
date: 2016-06-29 21:05:54
tags: ［Android,yeelink］
categories: Android
---

　　虽然前段时间的项目我参与了硬件部分的调试，但是我主要还是负责Android客户端的开发。yeelink是一个物联网云平台，我们可以采用单片机采集数据，然后将数据上传到yeelink，再通过Android客户端去云端获取数据，以便实现远程监测。这篇博客主要讲解如何从yeelink云端获取单片机上传到yeelink云端的数据。

<!--more-->

#### 查阅yeelink开发者文档

要想查看云端数据，需使用GET方法，对http://api.yeelink.net/v1.0/device/<device_id>/sensor/<sensor_id>/datapoint/<key>进行请求，对该URL的请求返回指定key的datapoint, 若未指定key, 则返回该sensor的最新数据。

![28-1](http://ohe7ixo05.bkt.clouddn.com/2016/6/28-1.jpg)

#### 新建并配置工程

##### 添加网络访问权限

在AndroidManifest.xml文件中加入如下：

```
<uses-permission android:name="android.permission.INTERNET" />
```

##### 编写布局文件

添加一个Button用于获取数据，添加一个TextView用于显示获取到的数据。


#### 网络请求库android-async-http的使用

android-async-http是一个强大的网络请求库，这个网络请求库是基于Apache HttpClient库之上的一个异步网络请求处理库，网络处理均基于Android的非UI线程，通过回调方法处理请求结果。

##### jar包下载

点击此处可以下载jar包

##### 将jar包添加到工程

将jar包复制到lib文件夹下，并右键该jar包，BuildPath--Add to Build Path

##### 编写代码

新建一个Http工具类CloudHttpUtil,再新建一个静态方法GetCloudData()，该方法需要两个参数，一个是进行消息传递的Handler，另一个是Http请求的url地址，具体代码如下：

```
public class CloudHttpUtil {

public static void GetCloudData(final Handler handler, String url) {

        AsyncHttpClient client = new AsyncHttpClient();
        //添加Http请求的头部信息
        client.addHeader("U-ApiKey", "你的API密钥");    
        //使用get方法获取数据
        client.get(url, new AsyncHttpResponseHandler() {

            @Override
            public void onSuccess(int i, Header[] headers, byte[] bytes) {
                // TODO Auto-generated method stub
                String response = new String(bytes);
                Message msg = new Message();
                msg.obj = response; 
                //请求成功后，将返回值通过消息传递到Activity实现数据显示
                handler.sendMessage(msg);  
            }

            @Override
            public void onFailure(int i, Header[] headers, byte[] bytes,
                    Throwable throwable) {
                // TODO Auto-generated method stub
                String response = new String(bytes);
                 //请求不成功时将错误信息打印
                System.out.println(response);  
            }
        });
    }
}
```

#### 获取云端数据

```
public class MainActivity extends ActionBarActivity {

    private TextView tv_clound_data;
    private Button btn_get_data;

    private Handler cloudHandler = new Handler() {
        public void handleMessage(android.os.Message msg) {
            String jsonData = (String) msg.obj;
            //成功获取数据后，将数据显示在界面上
            tv_clound_data.setText(jsonData);
            //还可以将获得的JSON数据进行解析，以便使用适配器将数据显示在列表等其他地方
            JSONArray ja;
            try {
                ja = new JSONArray(jsonData);
                for (int i = 0; i < ja.length(); i++) {
                    JSONObject js = ja.getJSONObject(i);
                    String time = js.getString("timestamp");
                    String value = js.getString("value");
                    System.out.println(time + value);
                }
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //初始化控件
        tv_clound_data = (TextView) findViewById(R.id.tv_clound_data);
        btn_get_data = (Button) findViewById(R.id.btn_get_data);

        //设置按钮监听事件
        btn_get_data.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                
                //不带参数的请求
                //String url = "http://api.yeelink.net/v1.0/device/你的设备号/sensor/你的传感器号/datapoint";
                //带参数的请求
                String url = "http://api.yeelink.net/v1.0/device/你的设备号/sensor/你的传感器号.json?start=2016-05-01T14:01:46&end=2016-06-24T10:01:40&interval=1";
                //发送http请求
                CloudHttpUtil.GetCloudData(cloudHandler, url);
            }
        });

    }
}

```

#### 测试效果图

##### 不带参数的请求

不带参数时将返回最新一个数据点的数据：

![28-2](http://ohe7ixo05.bkt.clouddn.com/2016/6/28-2.jpg)

##### 带参数的请求

带参数时将返回参数指定时间段内的数据：

![28-3](http://ohe7ixo05.bkt.clouddn.com/2016/6/28-3.jpg)

注：你的云端传感器得有数据才能获取啊，没有数据的话可以在yeelink官网手动添加几个数据，他的API文档中编辑数据，然后有个在线调试，可以模拟Http请求进行数据点的创建。


