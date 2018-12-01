---
title: Contiki 中 MQTT 协议实现
tags:
  - MQTT
  - Contiki
categories:
  - IoT
  - OS
abbrlink: 14042
date: 2017-06-30 15:06:02
---

　　6LoWPAN 无线传感网络中无线传感节点采用 MQTT 作为应用层协议是一种很好的选择，通过结合边界路由器、MQTT 代理服务器和远程客户端可以实现无线传感网络的数据上传、管理以及远程控制等功能。本文通过 Contiki 操作系统中实现的 MQTT 协议来介绍 6LoWPAN 中 MQTT 客户端功能的实现。

<!--more-->

#### MQTT简介

　　MQTT（Message Queuing Telemetry Transport，即消息队列遥测传输协议）是基于 TCP/IP 协议的基于发布订阅的消息传递协议。它被设计用于与需要“小代码占用”或网络带宽有限的远程位置的连接。

![7-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/3/7-1.png)

　　实现 MQTT 协议需要：客户端和服务器端。

　　MQTT 协议中有三种身份：发布者（Publish）、代理（Broker）（服务器）、订阅者（Subscribe）。其中，消息的发布者和订阅者都是客户端，消息代理是服务器，消息发布者可以同时是订阅者。

　　MQTT 传输的消息分为：主题（Topic）和负载（payload）两部分。

　　Topic 可以理解为消息的类型，订阅者订阅（Subscribe）后，就会收到该主题的消息内容（payload），可以理解为消息的内容，是指订阅者具体要使用的内容。
　　
#### MQTT API

　　MQTT 的实现在 Contiki 的 apps/mqtt 目录下，它使用 tcp-socket 库，当前在 Contiki 中 MQTT 的实现只支持 QoS 0 和 1。

##### MQTT 注册

**注意：初始化MQTT引擎，必须在使用任何其他MQTT函数之前调用。**

```c
/**
* \brief 初始化MQTT引擎.
* \param conn 指向MQTT连接的指针.
* \param app_process 指向处理MQTT连接的应用程序进程的指针.
* \param client_id 指向MQTT客户端ID的指针.
* \param event_callback 回调函数负责处理来自MQTT引擎的回调.
* \param max_segment_size MQTT/TCP连接的最大TCP分片大小.
* \return MQTT_STATUS_OK or MQTT_STATUS_INVALID_ARGS_ERROR
*/
mqtt_status_t mqtt_register(struct mqtt_connection *conn,
                            struct process *app_process,
                            char *client_id,
                            mqtt_event_callback_t event_callback,
                            uint16_t max_segment_size);
```

##### MQTT 连接

```c
/**
* \brief 连接到一个MQTT代理.
* \param conn 指向MQTT连接的指针.
* \param host MQTT代理服务器的IP地址.
* \param port MQTT代理的MQTT服务端口.
* \param keep_alive 保持连接的心跳频率，服务器端从客户端接收消息的最大时间间隔.
* \return MQTT_STATUS_OK or an error status
*/
mqtt_status_t mqtt_connect(struct mqtt_connection *conn,
                            char *host,
                            uint16_t port,
                            uint16_t keep_alive);
```

##### MQTT 断开连接

```c
/**
* \brief 与MQTT代理断开连接.
* \param conn 指向MQTT连接的指针.
*/
void mqtt_disconnect(struct mqtt_connection *conn);
```

##### MQTT 订阅主题

```c
/**
* \brief 订阅一个MQTT主题.
* \param conn 指向MQTT连接的指针.
* \param mid 指向message ID的指针.
* \param topic 指向要订阅的主题的指针.
* \param qos_level 服务质量等级.
* \return MQTT_STATUS_OK or some error status
*/
mqtt_status_t mqtt_subscribe(struct mqtt_connection *conn,
                                uint16_t *mid,
                                char *topic,
                                mqtt_qos_level_t qos_level);

```

##### MQTT 取消订阅

```c
/**
* \brief 取消订阅的主题.
* \param conn 指向MQTT连接的指针.
* \param mid 指向message ID的指针.
* \param topic 指向要取消订阅的主题的指针.
* \return MQTT_STATUS_OK or some error status
*/
mqtt_status_t mqtt_unsubscribe(struct mqtt_connection *conn,
                                uint16_t *mid,
                                char *topic);
```


##### MQTT 发布消息

```c
/**
* \brief 发布消息到一个MQTT主题.
* \param conn 指向MQTT连接的指针.
* \param mid 指向message ID的指针.
* \param topic 指向要发布消息的主题的指针.
* \param payload 指向主题有效载荷的指针.
* \param payload_size 有效载荷大小.
* \param qos_level 服务质量等级.
* \param retain 保持标志，如果RETAIN标志设置为1，则表示服务器要保留这次推送的信息，如果有新的订阅者出现，就把这消息推送给它.
* \return MQTT_STATUS_OK or some error status
*/
mqtt_status_t mqtt_publish(struct mqtt_connection *conn,
                            uint16_t *mid,
                            char *topic,
                            uint8_t *payload,
                            uint32_t payload_size,
                            mqtt_qos_level_t qos_level,
                            mqtt_retain_t retain);
```


##### MQTT 用户名密码

```c
/**
* \brief 设置MQTT客户端的用户名和密码.
* \param conn 指向MQTT连接的指针.
* \param username 指向用户名的指针.
* \param password 指向密码的指针.
*/
void mqtt_set_username_password(struct mqtt_connection *conn,
                                char *username,
                                char *password);
```


##### MQTT 遗言

　　遗言就是一个由客户端预先定义好的主题和对应消息，附加在 CONNECT 的可变头部中，在客户端连接出现异常的情况下，由服务器主动发布此消息。

```c
/**
* \brief 为MQTT客户端设置遗言主题和消息
* \param conn 指向MQTT连接的指针.
* \param topic 指向遗言主题的指针.
* \param message 指向遗言消息的指针.
* \param qos 服务质量等级.
*/
void mqtt_set_last_will(struct mqtt_connection *conn,
                        char *topic,
                        char *message,
                        mqtt_qos_level_t qos);
```

##### MQTT 状态检测 

　　可以使用以下帮助函数来声明 MQTT 连接状态，以检查节点是否连接到代理，如果连接已建立并且缓冲区中有空间可以发布，则使用 mqtt_ready。

```c
#define mqtt_connected(conn) \
((conn)->state == MQTT_CONN_STATE_CONNECTED_TO_BROKER ? 1 : 0)

#define mqtt_ready(conn) \
(!(conn)->out_queue_full && mqtt_connected((conn)))
```

　　参考文献：[IPv6-WSN-book：https://github.com/marcozennaro/IPv6-WSN-book](https://github.com/marcozennaro/IPv6-WSN-book)