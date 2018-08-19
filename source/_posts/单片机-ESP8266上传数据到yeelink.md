---
title: 单片机+ESP8266上传数据到yeelink
tags: '［单片机,yeelink］'
categories: 单片机
abbrlink: 1148
date: 2016-06-29 20:56:50
---

　　前段时间在做一个物联网的项目，需要将采集到的数据通过STM32单片机传送到yeelink云端，虽然之前学过51单片机但是因为ESP8266也是第一次使用，而且STM32没学过，对底层操作通信协议也不清楚，所以调试了很才成功了，现在有时间就把之前的思路理顺一下，希望对初学者有帮助。

<!--more-->

#### 串口直接调试

一开始是直接和项目成员一起通过STM32的串口发送命令来控制ESP8266进行数据发送，但是一直没成功，也不知道哪里出错了，也是想到可以直接将ESP8266通过单片机的转串口模块连接到电脑，用电脑的串口助手直接发命令给ESP8266进行调试，这样调试成功之后再把STM32加进来就容易多啦。

##### 熟悉操作命令

查阅ESP8266的相关资料，以及yeelink的http请求格式，将命令准备在串口调试助手，如下图：

![28-4](http://ohe7ixo05.bkt.clouddn.com/2016/6/28-4.png)

***注意选择发送新行，这样串口助手将自动在每一行后面加上回车换行符，具体原因在后面解释。然后在http请求头最后要发送一个空行，在发送请求体，即数据。否则数据上传失败。***

##### 硬件连接与设置

此处需要借助一个USB转串口的模块，也可以直接用单片机开发板上的转串口模块，将ESP8266的Txd，Rxd引脚与单片机开发板的串口输出引脚反接(即Txd连Rxd，Rxd连Txd)，将Vcc接单片机开发板的Vcc或5V，GND接开发板的GND，然后在电脑上设置串口调试助手波特率为：11520，再按顺序一条一条的发送以下命令，每条命令都会有相应的回应：

##### ESP8266控制指令

（1）设置WIFI模式
AT+CWMODE=1

（2）重启生效
AT+RST

（3）连接无线路由器
AT+CWJAP="你的wifi账号","你的wifi密码"

![28-5](http://ohe7ixo05.bkt.clouddn.com/2016/6/28-5.png)

（4）查询模块IP
AT+CIFSR

（5）与服务器建立TCP连接
AT+CIPSTART="TCP","www.yeelink.net",80

（6）开启透传模式
AT+CIPMODE=1

（7）开始透传
AT+CIPSEND

开始透传之后串口助手将显示‘>’符号，已经开启透传模式，表示可以传输数据，如下图：

![28-6](http://ohe7ixo05.bkt.clouddn.com/2016/6/28-6.png)

##### Http请求格式

Http请求的格式可以参照yeelink的API文档中的在线调试，如下图：

![28-7](http://ohe7ixo05.bkt.clouddn.com/2016/6/28-7.png)

在线调试发送Http请求之后下面会显示发送Http请求的格式，可直接复制过来用。

***进入透传模式之后开始发送http请求获取数据，将以下8条命令一次发送完成，按顺序将命令一个个点击发送完，不要点一个等一下，这个必须将所有命令发送完才会有回应***

（1）POST /v1.0/device/你的设备号/sensor/你的传感器号/datapoints HTTP/1.1

（2）User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0.1) Gecko/20100101 Firefox/9.0.1

（3）Host: api.yeelink.net

（4）Accept: */*

（5）Content-Length: 15

（6）U-ApiKey: 这里填写你在yeelink申请的密钥

（7）发送一个空行

（8）{"value":34.66}

发送成功将获得服务器的200，OK返回。

![28-8](http://ohe7ixo05.bkt.clouddn.com/2016/6/28-8.png)

其实，在这个过程中也遇到了很多坑：

（1）本来每发一条命令之后都要加上回车换行表示结束的，一开始没注意串口助手已经勾选发送新行，即自动为每一行添加回车换行，于是每条命令之后都有两个回车换行，就悲剧了。一定要注意你是否勾选上串口调试助手的回车换行。

（2）建议大家还是勾选上串口调试助手的发送新行，一方面不用自己去写回车换行符，另一方面也省去了考虑加转义字符的麻烦。亲测，串口助手还不一定可以识别你自己写的回车换行符。

（3）Http请求一定是一次性发送完才会有响应，否则服务器无法判断你的请求是否发送完。

#### 单片机控制ESP8266

以上的测试成功以后，应该怎么发送命令，怎么发送Http请求就已经很清楚了，将这些命令和请求嵌入到STM32的代码中，然后用STM32的串口通过printf函数进行输出，便可以很方便的实现我们需要的功能。当然，此时需要注意为每一行命令加上回车换行符，以及转义字符的处理。


```

//串口3,printf 函数
//确保一次发送数据不超过USART3_MAX_SEND_LEN字节
void u3_printf(char* fmt,...)  
{  
    u16 i,j; 
    va_list ap; 
    va_start(ap,fmt);
    vsprintf((char*)USART3_TX_BUF,fmt,ap);
    va_end(ap);
    i=strlen((const char*)USART3_TX_BUF);       //此次发送数据的长度
    for(j=0;j<i;j++)                            //循环发送数据
    {
      //循环发送,直到发送完毕   
      while(USART_GetFlagStatus(USART3,USART_FLAG_TC)==RESET);    
      USART_SendData(USART3,USART3_TX_BUF[j]); 
    } 
}

/*ESP8266连接网络与发送Http请求的部分代码*/

//设置WIFI模式
u3_printf("AT+CWMODE=1\r\n");
delay_ms(1000);

//重启生效
u3_printf("AT+RST\r\n");
delay_ms(1000);

//连接无线路由器，需延时等待连接成功
u3_printf("AT+CWJAP=\"你的wifi账号\",\"你的wifi密码\"\r\n");    
delay_ms(1000);
delay_ms(1000);
delay_ms(1000);
delay_ms(1000);
delay_ms(1000);
delay_ms(1000);

//此处省略了查看ip地址

//与服务器建立TCP连接
u3_printf("AT+CIPSTART=\"TCP\",\"www.yeelink.net\",80\r\n");
delay_ms(1000);
delay_ms(1000);

//开启透传模式
u3_printf("AT+CIPMODE=1\r\n");
delay_ms(1000);

//开始透传
u3_printf("AT+CIPSEND\r\n");
delay_ms(10);

//开始发生Http请求
u3_printf("POST /v1.0/device/你的设备号/sensor/你的传感器号/datapoints HTTP/1.1\r\n");
u3_printf("Host: api.yeelink.net\r\n");
u3_printf("Accept: */*\r\n");
u3_printf("U-ApiKey: 你在yeelink申请的密钥\r\n");
u3_printf("Content-Length: 15\r\n");
//设置短连接，连接双方都会要求在处理请求后关闭它们的TCP连接
u3_printf("Connection: close\r\n");
u3_printf("\r\n"); 
//发送数据
u3_printf("{\"value\":34.66}); 
delay_ms(1000);

//关闭透传
u3_printf("+++");
```