---
title: '[译]MQTT安全基础：使用用户名和密码进行身份验证'
date: 2017-08-24 09:36:07
tags: [MQTT,安全]
categories: 
- IoT
- MQTT
---

　　在上一篇文章中，我们介绍了MQTT中非常基本的安全。今天的文章将从MQTT中的认证开始，进一步详细介绍。

<!--more-->

　　**注：本文翻译自：[MQTT Security Fundamentals: Authentication with Username and Password](http://www.hivemq.com/blog/mqtt-security-fundamentals-authentication-username-password)**

![24-1](http://www.hivemq.com/wp-content/uploads/mqttsecurityfundamentals_part2.png)

　　认证是MQTT中传输层和应用层安全性的一部分。

　　在传输层上，TLS可以保证使用客户端证书的客户端到服务器的身份验证，并确保服务器向客户端验证服务器证书。在应用层上，MQTT协议提供用户名和密码用于验证。各种代理实现在上面添加了不同的机制。本文将概述一般认证，哪些功能内置于MQTT协议本身。下周我们将看看经纪人认证方式。

#### 认证

```
认证是确认单个数据或实体的属性的真实性的行为。
```

　　据维基百科

　　这意味着认证用于验证个人、设备或应用程序是否具有他们声称拥有的身份。

　　呈现一个旅行中的简单例子给你。在你能够乘坐飞机之前，机场安检要求你的护照或身份证件。显示所请求的ID以认证身份。在这种情况下，您的护照证实您的身份和您的姓名。每个人都可以说出你的名字，但是只有你能够出示护照作为你身份的证明。

　　身份验证是我们每天使用的过程，甚至没有注意到。每次登录到您的计算机时，您提供用户名和密码。用户名是您的身份，密码输入会将您认证为合法拥有者。

#### MQTT认证用户名/密码

　　当涉及MQTT中的认证时，协议本身在CONNECT消息中提供用户名和密码字段。因此，客户端可以在连接到MQTT代理时发送用户名和密码（有关详细信息，请参阅[MQTT Essential Part 3：建立MQTT连接](http://www.hivemq.com/blog/mqtt-essentials-part-3-client-broker-connection-establishment)）

![24-2](http://www.hivemq.com/wp-content/uploads/connect.png)

　　用户名是一个UTF-8编码的字符串，密码是二进制数据，最大为65535个字节。在去年发布的新版3.1.1版本中，MQTT 3.1规范中密码为12个字符的非规范性建议被删除。该规范还指出，没有密码的用户名是可能的。只发送密码而没有用户名是不可以的。

![24-3](http://www.hivemq.com/wp-content/uploads/connack.png)

　　当使用内置的用户名/密码认证时，MQTT代理将根据实现的认证机制（更多的是在下一篇文章中）来评估凭证，并返回以下返回码之一（所有返回码的完整列表可以在[MQTT Essential Part 3：建立MQTT连接](http://www.hivemq.com/blog/mqtt-essentials-part-3-client-broker-connection-establishment)中找到）。

Return Code | Return Code Response
---|---
0   |  Connection Accepted
4   |  Connection Refused, bad user name or password
5   |  Connection Refused, not authorized

　　在客户端设置用户名和密码时，将以明文形式发送给代理。这将允许攻击者窃听，并且是获取凭据的简单方式。确保用户名和密码完全安全传输的唯一方法是使用传输加密。

　　所以这是关于MQTT认证的第一部分，在下一篇文章中，我们将通过验证提供的用户名/密码是否有效或通过使用其他属性（如客户端标识符进行身份验证）来查看在代理端实现身份验证的不同选项。