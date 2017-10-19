---
title: '[译]MQTT安全基础：高级认证机制'
date: 2017-09-23 16:37:15
tags: [MQTT,安全]
categories:
- IoT
- MQTT
---

　　在上一篇文章中，我们已经解释了认证的基础知识，并且MQTT协议在CONNECT消息中提供用于认证的用户名和密码。此帖子将引入其他机制来验证客户端，以及如何在MQTT代理端上实现身份验证。

<!--more-->

**注：本文翻译自：[MQTT Security Fundamentals: Authentication with Username and Password](http://www.hivemq.com/blog/mqtt-security-fundamentals-advanced-authentication-mechanisms)**

![25-1](http://www.hivemq.com/wp-content/uploads/mqttsecurityfundamentals_part3.png)

#### 使用其他信息认证

　　正如我们在上一篇文章中了解到的，认证是确认一方的身份的机制。我们已经看到如何通过使用用户名和密码组合来实现。除了用户名和密码外，MQTT客户端还提供可用于认证的附加信息。

##### 客户端标识符

　　每个MQTT客户端都有唯一的客户端标识符该唯一标识符由客户端在MQTT CONNECT消息中提供。客户端ID最多可达65535个字符，以前限制为23个字符的MQTT 3.1.1规范无效。通常的做法是使用36个字符长的uuids或客户端可用的任何其他唯一信息，如网络模块的MAC地址或设备本身的序列号。在身份验证过程中，除了用户名和密码之外，常常使用客户端ID。确认客户端是否可以访问MQTT代理的常见示例是验证用户名/密码以及该凭证组合的正确客户端ID。虽然这不是一个很好的安全措施，但也可以忽略用户名/密码，并根据客户端标识符进行身份验证。对于封闭系统，这种认证可能就够了。

##### X.509证书

　　来自客户端的另一个可能的认证来源是一个X.509客户端证书，它将在TLS握手期间向代理提供（我们将在稍后的一篇文章中解释更多关于传输级安全性以及SSL/TLS如何与MQTT一起工作的方式）。像HiveMQ这样的代理可以在TLS握手已经成功后，使用证书中的信息进行应用层验证。这使得代理能够读取证书中包含的所有信息，并将其用于认证目的。如果您可以控制提供IoT设备，则X509客户端证书可能是对MQTT代理进行身份验证的非常好的来源。

#### 使用HiveMQ实现认证

　　我们已经看到有可用于MQTT客户端认证的各种信息。现在是时候连接MQTT代理和身份验证存储，它可以是数据库，Web服务，LDAP目录或简单的ACL（访问控制列表）。看看如何在HiveMQ MQTT代理程序中实现认证逻辑。HiveMQ代理有一个开放源码的插件系统，它允许你挂钩在代理上的各种事件。HiveMQ具有不同的回调接口，它们在定制插件中非常容易实现。插件实现在运行时由代理调用。为了认证，HiveMQ提供OnAuthenticationCallback。

```
public class AuthWithUsernamePasswordCallback implements OnAuthenticationCallback {
    @Override
    public Boolean checkCredentials(ClientCredentialsData clientCredentialsData) throws AuthenticationException
    {

    // Custom Authentication Logic

    }
}
```

　　这种回调实现足以根据您的用例自定义身份验证机制。方法回调有一个参数，它是ClientCredentialsData类型的一个对象，它继承了ClientData类型。这包含HiveMQ从连接客户端可用的所有数据。它允许您检查客户端ID，用户名，密码和证书。如果客户端提供有效的认证信息，则此回调将返回true。为了拒绝认证，有两种可能性：

- return false
- throw an Exception

　　如果回调函数返回false，HiveMQ将看到是否有任何其他插件和请求身份验证。如果其中一个返回true，HiveMQ将接受客户端的身份验证。如果HiveMQ不应该考虑任何其他插件，并立即拒绝连接，则应抛出异常。使用异常时，也可以修改CONNACK返回码。我们有一个更普遍的例子，在GitHub上使用用户名/密码验证的虚拟实现。

　　在从HiveMQ提取回调之前，需要将其添加到回调注册表中。这可以很容易地在插件的主类中完成。主要的类是每个插件都需要的，可以很容易地识别，因为它是唯一扩展PluginEntryPoint的类。回调通过依赖注入注入并添加到回调注册表中。现在插件可以和HiveMQ代理一起使用。

```
public class AuthenticationExampleMainClass extends PluginEntryPoint {

    private final AuthWithUsernamePasswordCallback authWithUsernamePasswordCallback;

    @Inject
    public AuthenticationExampleMainClass(final AuthWithUsernamePasswordCallback authWithUsernamePasswordCallbackCallback)
    {
        this.authWithUsernamePasswordCallback = authWithUsernamePasswordCallbackCallback;
    }

    @PostConstruct
    public void postConstruct() {

        CallbackRegistry callbackRegistry = getCallbackRegistry();
        callbackRegistry.addCallback(authWithUsernamePasswordCallback);

    }
}
```

　　可以使用HiveMQ（开放源代码）插件来验证我们的插件目录中的客户端，如ACL的文件验证插件。

　　如果您需要有关如何开发，运行和部署HiveMQ代理的自定义验证插件的更多信息，请阅读插件开发人员指南。

　　这也是MQTT安全基础知识认证部分的结尾。在下一篇文章中，我们将介绍使用MQTT的主题级别授权。
