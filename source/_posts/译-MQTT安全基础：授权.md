---
title: '[译]MQTT安全基础：授权'
tags:
  - MQTT
  - 安全
categories:
  - IoT
  - MQTT
abbrlink: 38132
date: 2017-09-28 12:44:31
---

　　您好，欢迎来到MQTT安全基础的下一篇文章。本周，我们将专注于一个新课题，并通过MQTT研究授权。这在我们以前讨论过认证后才适合。如果您没有阅读关于身份验证的最后两篇文章（第1部分和第2部分），那么在继续阅读此文章之前，您一定要这样做。

<!--more-->

**注：本文翻译自：[MQTT Security Fundamentals: Authorization](https://www.hivemq.com/blog/mqtt-security-fundamentals-authorization/)**

![26-1](http://www.hivemq.com/wp-content/uploads/mqttsecurityfundamentals_part4.png)

#### 什么是授权？

　　授权是指定特定资源的访问权限的功能。这包括策略的定义和实施，它们指定谁可以访问某个资源。因此，以下术语至关重要：

- 主体或用户：想访问资源
- 资源，对象或服务：应防止未经授权的访问
- 政策：指定主体是否可以访问资源


##### 真实世界例证

　　让我们来看一下身份验证博客文章的旅行示例，并继续执行。我们已经看到，登机时可以使用护照来认证一个人的身份。所以在身份确认后，预订确认书或登机证用于授权/授予访问权限以获得特定的飞机。所以在预订航班后，有关您的人的信息和确切的航班日期，时间和目的地作为飞行的授权。


##### 认证和授权：两个最好的朋友！

　　正如我们已经在现实世界中看到的那样，**认证和授权是两个非常重要的安全概念**。用户或主体的授权在事先没有认证的情况下没有太多价值，从而确认其身份。**授权对于限制访问非常重要，只允许符合条件的人员，客户或主体访问某些资源，数据或事物。**如果您没有特别关注安全性，您可能不会注意到这些概念无处不在，但如果您退缩并仔细查看，您可以轻松识别它们：登录到您的操作系统并访问文件，登录到网络应用程序，并具有某些权利或使用工作人员徽章访问公司大楼。

##### 如何指定授权策略

　　最常用的是不同类型的授权，这里是一个快速的概述。如果你想了解更多，网络上有大量的资源可以详细地解释这些类型。


简写 | 名称 | 说明 | 示例
---|---|---|---|
ACL | 访问控制列表 | ACL将资源与权限列表相关联。权限包括谁可以访问资源（例如文件）以及哪些操作（例如，读取，写入，执行）被允许。 | Unix文件权限
RBAC | 基于角色的访问控制 | RBAC始终将某个资源的权限与角色相关联。角色是用户和资源之间的额外抽象。这使得更容易将用户与角色相关联，以便维护所有用户的权限。 | Active Directory, SELinux, PostgreSQL

#### MQTT授权

　　我们来看看MQTT。

　　MQTT客户端在连接到代理之后基本上可以做两件事情，它可以发布消息，并且可以订阅主题。所以将其转换为以前所述的定义：

- 一个MQTT客户端是主题，它需要授权才能做某事
- 客户可用的主要资源或对象是主题
- 其他对象将是：Store Last Will and Testament或持久会话
- 需要保护的主要资源是发布或订阅的能力

　　没有适当的授权，每个经过身份验证的客户端都可以发布和订阅各种主题。这在封闭系统中是可取的。对于大多数用例，细粒度限制使得很有意义，应该被使用。官方的MQTT 3.1.1规范说明了以下事项：

```
“MQTT solutions are often deployed in hostile communication environments. In such cases, implementations will often need to provide mechanisms for: […] Authorization of access to Server resources”

“MQTT解决方案通常部署在恶劣的通信环境中。在这种情况下，实现通常需要提供以下机制：[...]访问服务器资源的授权"
```

　　为了限制客户端发布或订阅仅被授权的主题，有必要在代理方实现主题权限。这些权限需要在代理运行时配置和调整。主题权限可以如下所示：

- 允许主题（确切主题或通配符主题）
- 允许的操作（发布，订阅，两者）
- 允许服务质量水平（0，1，2，全部）

　　这种主题权限将允许代理为客户端指定授权策略，并限制其订阅和发布消息的能力。一个例子是给客户端许可只订阅一个主题，只使用一定的服务质量水平。

##### 拒绝

　　在定义了授权策略之后，一个很常见的问题是如何通知客户它没有发布或订阅某个主题的权限。

##### 发布

　　当发布到主题时，客户端没有权限，代理有两个选项：

- 它可以断开客户端，因为发布到受限主题是不允许的。
- 它可以以普通方式向客户端发送（在使用PUBACK或PUBREL的QoS 1或2的情况下），并决定不向订阅者发送已发布的消息。

　　目前的MQTT 3.1.1规范没有定义与代理无关的方式来通知客户端未经授权的发布，除了断开客户端，这可能会在即将到来的MQTT版本中有所改进。

##### 订阅

　　在订阅主题的情况下，代理需要使用返回码确认每个订阅。有4个不同的代码用于确认具有授权QoS的每个主题或发送错误代码。因此，**如果客户端无权订阅特定主题，代理可以通知客户该订阅被拒绝。**

#### 最佳做法

　　常用的最佳做法是将许可中的发布客户端的客户端标识包含在内。**所以客户端仅限于发布到主题，客户端ID在哪里。**一个例子是client123/temperature或client123/＃。同样可以用于订阅。这是一个只关心一个客户端的主题的良好模式。当然，这通常不是唯一的许可。此外，客户端通常具有订阅更常规主题的权限，如：clients/status或clients/command。这很大程度上取决于用例，应该只是一个建议。

##### 代理实现

　　最后，我们来看看HiveMQ MQTT代理如何实现自定义授权。

　　HiveMQ的开源插件系统可以轻松为每个客户端指定主题权限。每当客户端想要发布或订阅时，HiveMQ会向插件询问客户端的权限。当然这些权限可以被缓存，所以它不会减慢消息流。

　　OnAuthorizationCallback允许实现getPermissionsForClient方法，其示例如下所示。该方法从HiveMQ内核中调用，并交付一个ClientData对象，该对象包含可用于客户端请求权限的所有可用信息。这可以用来确定正确的权限，就像示例中使用客户端ID一样。HiveMQ期望插件返回客户端允许使用的主题权限列表。HiveMQ本身完成了权限和当前主题的完全匹配。

```
@Override
@Cached(timeToLive = 5, timeUnit = TimeUnit.MINUTES)
public List<MqttTopicPermission> getPermissionsForClient(ClientData clientData) {
    List<MqttTopicPermission> mqttTopicPermissions = new ArrayList<MqttTopicPermission>();
    mqttTopicPermissions.add(
             new MqttTopicPermission(
                    clientData.getClientId() + “/#”,            // Topic
                    MqttTopicPermission.ALLOWED_QOS.ALL,        // QoS
                    MqttTopicPermission.ALLOWED_ACTIVITY.ALL)); // Publish, Subscribe, All

    return mqttTopicPermissions;
}
```

　　该示例显示客户端如何只发布和订阅主题，从其客户端ID开始。所有其他订阅或发布的消息都被拒绝。

　　完整的示例可以在[HiveMQ GitHub帐户](https://github.com/hivemq/hivemq-authorization-example)中找到。

　　另一个例子是[Stormpath插件](http://www.hivemq.com/plugin/stormpath-plugin/)，它使用Strompath API进行身份验证和授权。
