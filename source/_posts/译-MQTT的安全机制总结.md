---
title: '[译]MQTT的安全机制总结'
date: 2017-08-25 09:28:05
tags: [MQTT,安全]
categories:
- IoT
- MQTT
---

　　HiveMQ团队对MQTT安全方面的系列总结文章写得很不错，所以想要将其翻译整理一下。

<!--more-->

　　HiveMQ 是一个企业级的 MQTT 代理，主要用于企业和新兴的机器到机器M2M通讯和内部传输，最大程度的满足可伸缩性、易管理和安全特性。提供免费的个人版。HiveMQ 提供了开源的插件开发包。


　　**注：本文翻译自：[MQTT Security Fundamentals Wrap-Up](http://www.hivemq.com/blog/mqtt-security-fundamentals-wrap-up)**

![22-1](http://www.hivemq.com/wp-content/uploads/mqttsecurityfundamentals.png)

　　在我们的超连接世界中，安全是一个非常重要的方面，从每个IoT应用程序的开始就应该考虑安全性。我们的MQTT安全基础系列的目标是讨论通过MQTT协议保护数据交换的几个概念。

　　对于没有跟随整个系列的每个人来说，这里是所有按顺序排列的文章：

- [Introducing the MQTT Security Fundamentals](http://www.hivemq.com/introducing-the-mqtt-security-fundamentals/)
- [Authentication with Username and Password](http://www.hivemq.com/mqtt-security-fundamentals-authentication-username-password/)
- [Advanced Authentication Mechanisms](http://www.hivemq.com/mqtt-security-fundamentals-advanced-authentication-mechanisms/)
- [Authorization](http://www.hivemq.com/mqtt-security-fundamentals-authorization/)
- [TLS / SSL](http://www.hivemq.com/mqtt-security-fundamentals-tls-ssl/)
- [X509 Client Certificate Authentication](http://www.hivemq.com/mqtt-security-fundamentals-x509-client-certificate-authentication/)
- [OAuth 2.0 & MQTT](http://www.hivemq.com/mqtt-security-fundamentals-oauth-2-0-mqtt/)
- [MQTT Payload Encryption](http://www.hivemq.com/mqtt-security-fundamentals-payload-encryption/)
- [MQTT Message Data Integrity](http://www.hivemq.com/mqtt-security-fundamentals-mqtt-message-data-integrity/)
- [Securing MQTT Systems](http://www.hivemq.com/mqtt-security-fundamentals-securing-mqtt-systems/)

　　文章翻译目录：

- [[译]MQTT安全基础知识介绍](http://fanzhenyu.me/2017/08/23/译-MQTT安全基础知识介绍/)
- [[译]MQTT安全基础：使用用户名和密码进行身份验证](http://fanzhenyu.me/2017/08/24/译-MQTT安全基础：使用用户名和密码进行身份验证/)
- [[译]MQTT安全基础：高级认证机制](http://fanzhenyu.me/2017/09/23/译-MQTT安全基础：高级认证机制/)
- [[译]MQTT安全基础：授权](http://fanzhenyu.me/2017/09/28/译-MQTT安全基础：授权/)
- [[译]MQTT安全基础：TLS / SSL](http://fanzhenyu.me/2017/10/10/译-MQTT安全基础：TLS/SSL/)
- [译]MQTT安全基础：X509客户端证书认证
- [译]MQTT安全基础：OAuth 2.0和MQTT
- [译]MQTT安全基础：MQTT有效载荷加密
- [译]MQTT安全基础 - MQTT消息数据完整性
- [译]MQTT安全基础 - 保护MQTT系统

　　感谢并关注更多MQTT相关内容，

　　HiveMQ团队
