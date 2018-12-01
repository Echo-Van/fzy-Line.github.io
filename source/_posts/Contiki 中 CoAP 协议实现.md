---
title: Contiki中CoAP协议实现
tags:
  - CoAP
  - Contiki
categories:
  - IoT
  - OS
abbrlink: 53377
date: 2017-07-16 21:04:42
---


　　CoAP（Constrained Application Protocol）协议是为物联网中资源受限设备制定的应用层协议。


<!--more-->

#### CoAP协议简介

　　CoAP 协议是为物联网中资源受限设备制定的应用层协议。CoAP 旨在轻松转换为 HTTP，以简化与 Web 的集成，同时满足组播支持，非常低的开销和简单性等特殊要求。

　　CoAP 可以在大多数支持 UDP 的设备上运行。CoAP 使用两种消息类型，请求和响应，使用简单的二进制基本头文件格式。基本标题后面可以是优化的类型长度值格式的选项。默认情况下，CoAP 绑定到 UDP，并可选择为 DTLS（数据报传输层安全），提供高水平的通信安全性。

　　逻辑上分为 Message 和 Request/Response 两层（如下图），Request/Response 通过Message承载，从封包上不体现这种层次结构。

![15-1](http://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2017/7/15-1.png)

#### REST

　　REST（Representational State Transfer，表述性状态转移）依赖于无状态的、客户机-服务器，可缓存的通信协议。

　　RESTful Web 服务的关键抽象就是资源而不是服务。一般来说，传感器，执行器和控制系统可以优雅地表现为通过 RESTful Web 服务暴露的资源及其服务。

　　RESTful 应用程序使用类似HTTP的请求来发布数据（创建和/或更新），读取数据（例如查询）和删除数据。因此，REST 对所有四个 CRUD（创建/读取/更新/删除）操作都使用 HTTP。

#### CoAP API

　　Contiki 的 CoAP 实现基于 Erbium（Er），一种低功耗的 Contiki 的 REST 引擎。 REST 引擎包括一个全面的嵌入式 CoAP 实现，成为 Contiki 中的官方。

　　CRUD（create, read, update, delete）操作：

- POST: Create a resource
- GET: Retrieve a resource
- PUT: Update a resource
- DELETE: Delete a resource


　　服务器上有各种可用的资源。服务器上的每个资源都有一个处理函数，REST 层调用它来为客户端的请求提供服务。REST 服务器将请求的内容发送回客户端。

##### RESTful 资源定义

```c
/* data structure representing a resource in REST */
struct resource_s {
  struct resource_s *next;        /* for LIST, points to next resource defined */
  const char *url;                /*handled URL */
  rest_resource_flags_t flags;    /* handled RESTful methods */
  const char *attributes;         /* link-format attributes */
  restful_handler get_handler;    /* handler function */
  restful_handler post_handler;   /* handler function */
  restful_handler put_handler;    /* handler function */
  restful_handler delete_handler; /* handler function */
  union {
    struct periodic_resource_s *periodic; /* special data depending on flags */
    restful_trigger_handler trigger;
    restful_trigger_handler resume;
  };
};
typedef struct resource_s resource_t;
```

##### 五种RESTful资源类型

- RESOURCE

　　normal resource，由与资源处理函数相关联的静态 Uri-Path 定义。这是所有其他资源类型的基础。

```c
#define RESOURCE(name, attributes, get_handler, post_handler, put_handler, delete_handler) \
  resource_t name = { NULL, NULL, NO_FLAGS, attributes, get_handler, post_handler, put_handler, delete_handler, { NULL } }
```

- PARENT_RESOURCE

　　parent resource，通过评估可能长于父资源的 Uri-Path 来管理多个子资源。

```c
#define PARENT_RESOURCE(name, attributes, get_handler, post_handler, put_handler, delete_handler) \
  resource_t name = { NULL, NULL, HAS_SUB_RESOURCES, attributes, get_handler, post_handler, put_handler, delete_handler, { NULL } }
```

- SEPARATE_RESOURCE

　　separate resource，如果服务器不能立即响应 CON 请求，它只需用空的 ACK 消息进行响应，以便客户端可以停止重新发送请求。过了一会儿，当服务器准备好响应时，它将响应作为 CON 消息发送。以下宏允许创建具有单独响应的 CoAP 资源：

```c
#define SEPARATE_RESOURCE(name, attributes, get_handler, post_handler, put_handler, delete_handler, resume_handler) \
  resource_t name = { NULL, NULL, IS_SEPARATE, attributes, get_handler, post_handler, put_handler, delete_handler, { .resume = resume_handler } }
```


- EVENT_RESOURCE

　　event resource，事件资源类似于周期性资源，但第二个处理程序是由非周期性事件调用的，例如按下一个按钮。

```c
#define EVENT_RESOURCE(name, attributes, get_handler, post_handler, put_handler, delete_handler, event_handler) \
  resource_t name = { NULL, NULL, IS_OBSERVABLE, attributes, get_handler, post_handler, put_handler, delete_handler, { .trigger = event_handler } }
```

　　如果我们需要声明一个定期的资源，例如轮询传感器并发布更改的值给订阅的客户端，那么我们应该使用：

```c
/*
 * Macro to define a periodic resource.
 * The corresponding [name]_periodic_handler() function will be called every period.
 * For instance polling a sensor and publishing a changed value to subscribed clients would be done there.
 * The subscriber list will be maintained by the final_handler rest_subscription_handler() (see rest-mapping header file).
 */
#define PERIODIC_RESOURCE(name, attributes, get_handler, post_handler, put_handler, delete_handler, period, periodic_handler) \
  periodic_resource_t periodic_##name; \
  resource_t name = { NULL, NULL, IS_OBSERVABLE | IS_PERIODIC, attributes, get_handler, post_handler, put_handler, delete_handler, { .periodic = &periodic_##name } }; \
  periodic_resource_t periodic_##name = { NULL, &name, period, { { 0 } }, periodic_handler };
```

　　请注意，PERIODIC_RESOURCE 和 EVENT_RESOURCE 可以被观察到，这意味着可以向客户端通知给定资源中的任何更改。


#### 初始化

　　初始化 REST 框架并启动 HTTP 或 CoAP 进程。

```c
/**
 * \brief      Initializes REST framework and starts the HTTP or CoAP process.
 */
void rest_init_engine(void);
```

#### 激活资源

　　然后对于每个声明的资源，我们想要访问

```c
/**
 *
 * \brief Resources wanted to be accessible should be activated with the following code.
 * \param resource
 *             A RESTful resource defined through the RESOURCE macros.
 * \param path
 *             The local URI path where to provide the resource.
 */
void rest_activate_resource(resource_t *resource, char *path);
```

　　例如：

　　定义资源：

```c
RESOURCE(res_hello,
        "title=\"Hello world: ?len=0..\";rt=\"Text\"",
        res_get_handler,
        NULL,
        NULL,
        NULL);
```

　　激活资源：

```c
rest_activate_resource(&res_hello, "test/hello");
```

　　访问资源：

　　资源的URI路径为：test/hello

##### 获取可用资源列表

```c
/**
 * \brief Returns the list of registered RESTful resources.
 * \return     The resource list.
 */
list_t rest_get_resources(void);
```

　　强制性 CoAP 端口是 5683。
