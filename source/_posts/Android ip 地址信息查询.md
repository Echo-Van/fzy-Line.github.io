---
title: Android ip 地址信息查询
tags:
  - Android
  - ip
categories: Android
abbrlink: 2137
date: 2016-07-12 23:02:48
---

　　上一篇博客中我们讲解了如何获取外网的 ip 地址，获取到的 ip 地址总是会有用的，我们现在就来使用它，通过查询 ip 地址的相关信息我们可以获取当前所在城市信息，即 ip 地址定位。其实，实现起来也比较简单，主要还是使用的第三方 API 接口，通过 http 请求来获取信息。

<!--more-->

#### 实现方法

##### 百度API Store Ip地址定位API的使用

　　上一步我们获取了本机的外网 ip 地址，然后我们使用百度 API Store 的 ip 地址定位 API 来进行 ip 地址定位。[API的地址](http://apistore.baidu.com/apiworks/servicedetail/114.html)，他有很详细的文档，可以很容易使用。通过 Http 的 GET 方法将 ip 地址发送给服务器，将获取 JSON 格式的返回值进行解析即可实现定位。如下图所示：

![12-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/7/12-1.jpg)

##### android-async-http

　　android-async-http 是一个第三方网络请求库，由于在上一篇博客中我们已经为工程添加 android-async-http 的 jar 包，所以这里不需要重复添加，可直接进入下一步。

#### 代码编写

##### Handler

　　新建一个 Handler 用于将 Http 请求获得的定位数据传回 Activity：

```java
private Handler mCityHandler = new Handler() {
    public void handleMessage(Message msg) {
        String res = (String) msg.obj; //获取传回的定位数据
        res = decodeUnicode(res);
        System.out.println(res); 
        mAddr.setText(res); //显示ip地址定位信息
        //也可以进一步解析JSON数据取出所在国家、省份、城市等信息
        try {
            JSONObject js = new JSONObject(res);
            js = js.getJSONObject("retData");
            String country = js.getString("country");
            String province = js.getString("province");
            String city = js.getString("city");
            System.out.println("city:" + city);
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
    };
};
```

##### Http 请求

　　在 IpHttpUtil 类中编写 Http 请求静态方法，这里还是使用的 android-async-http 网络请求库，因为它方便、简洁，而且稳定，所以一直喜欢用它。

```java
public static void getAddress(final Handler handler, String ip) {
    //定位信息请求地址
    String url = "http://apis.baidu.com/apistore/iplookupservice/iplookup";
    AsyncHttpClient client = new AsyncHttpClient();
    client.addHeader("apikey", "这里填你自己百度API商店注册后的apikey");
    RequestParams params = new RequestParams();
    params.add("ip", ip); //添加参数
    client.get(url, params, new AsyncHttpResponseHandler() {
    
        @Override
        public void onSuccess(int arg0, Header[] arg1, byte[] bytes) {
            // TODO Auto-generated method stub
            String response = null;
            try {
                response = new String(bytes, "GBK"); //获取服务器返回数据
            } catch (UnsupportedEncodingException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            Message msg = new Message();
            msg.obj = response;
            handler.sendMessage(msg);
        }
        
        @Override
        public void onFailure(int arg0, Header[] arg1, byte[] bytes, Throwable arg3) {
            // TODO Auto-generated method stub
            String response = null;
            try {
                response = new String(bytes, "GBK");
            } catch (UnsupportedEncodingException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            System.out.println(response);
        }
    });
}
```

##### 执行请求

　　在 mIpHandler 接收到 ip 地址后，再调用获取定位信息的 Http 方法（即在 mIpHandler 的 handleMessage 方法的最后加入下面这行代码）

```java
IpHttpUtil.getAddress(mCityHandler, res); //发送获取定位信息的http请求
```

#### 效果展示

　　我们在获取 ip 地址那篇博客的例子的基础上增加了一个 TextView 来显示本篇博客获取的定位信息，如下图所示，我们获取并显示了得到的 JSON 格式的返回数据，即通过该 ip 地址获得的定位信息。如下图所示，我们可以看到已经获得了服务器返回的 JSON 数据，但是可以很清楚的看到，显示的 unicode 编码，并不是汉字，那就需要将接收到的数据转化成汉字咯。

![12-2](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/7/12-2.jpg)

　　在网上摘抄了一段 unicode 转汉字的代码：

```java
private String decodeUnicode(String theString) {
        char aChar;
        int len = theString.length();
        StringBuffer outBuffer = new StringBuffer(len);
        for (int x = 0; x &lt; len;) {
            aChar = theString.charAt(x++);
            if (aChar == '\\') {
                aChar = theString.charAt(x++);
                if (aChar == 'u') {
                    // Read the xxxx
                    int value = 0;
                    for (int i = 0; i &lt; 4; i++) {
                        aChar = theString.charAt(x++);
                        switch (aChar) {
                        case '0':
                        case '1':
                        case '2':
                        case '3':
                        case '4':
                        case '5':
                        case '6':
                        case '7':
                        case '8':
                        case '9':
                            value = (value &lt;&lt; 4) + aChar - '0';
                            break;
                        case 'a':
                        case 'b':
                        case 'c':
                        case 'd':
                        case 'e':
                        case 'f':
                            value = (value &lt;&lt; 4) + 10 + aChar - 'a';
                            break;
                        case 'A':
                        case 'B':
                        case 'C':
                        case 'D':
                        case 'E':
                        case 'F':
                            value = (value &lt;&lt; 4) + 10 + aChar - 'A';
                            break;
                        default:
                            throw new IllegalArgumentException(
                                    "Malformed   \\uxxxx   encoding.");
                        }
 
                    }
                    outBuffer.append((char) value);
                } else {
                    if (aChar == 't')
                        aChar = '\t';
                    else if (aChar == 'r')
                        aChar = '\r';
                    else if (aChar == 'n')
                        aChar = '\n';
                    else if (aChar == 'f')
                        aChar = '\f';
                    outBuffer.append(aChar);
                }
            } else
                outBuffer.append(aChar);
        }
        return outBuffer.toString();
    }
```


　　使用此方法将接收到的字符处理后即可获得获得汉字显示，如下图：

![12-3](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2016/7/12-3.jpg)





