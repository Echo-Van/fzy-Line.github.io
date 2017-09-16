---
title: CoAP协议详解（一）
date: 2017-03-01 18:26:53
tags: [CoAP]
categories: 
- IoT
- CoAP
---

　　CoAP(Constrained Application Protocol)协议是为物联网中资源受限设备制定的应用层协议。由于物联网中的很多设备都是资源受限型的，即只有少量的内存空间和有限的计算能力，所以传统的HTTP协议应用在物联网上就显得过于庞大而不适用。IETF的CoRE工作组提出了一种基于REST架构的CoAP协议。

<!--more-->

#### CoAP简介

　　CoAP是一种应用层协议，它运行于UDP协议之上而不是像HTTP那样运行于TCP之上。

　　CoAP协议基于REST 构架，REST 是指表述性状态转换架构，是互联网资源访问协议的一般性设计风格。为了克服HTTP对于受限环境的劣势，CoAP既考虑到数据报长度的最优化，又考虑到提供可靠通信。一方面，CoAP提供URI，REST 式的方法如GET，POST，PUT和DELETE，以及可以独立定义的头选项提供的可扩展性。另一方面，CoAP基于轻量级的UDP协议，并且允许IP多播。而组通信是物联网最重要的需求之一，比如说用于自动化应用中。为了弥补UDP传输的不可靠性，CoAP定义了带有重传机制的事务处理机制。并且提供资源发现机制，并带有资源描述。

##### CoAP的特点

- CoAP采用了二进制报头，而不是文本报头(text header)。

- CoAP降低了头的可用选项的数量。

- CoAP减少了一些HTTP的方法。

- CoAP可以支持检测装置。

##### CoAP与Http协议

　　CoAP协议不是盲目的压缩了HTTP协议，考虑到资源受限设备的低处理能力和低功耗限制，CoAP重新设计了HTTP的部分功能以适应设备的约束条件。另外，为了使协议适应物联网和M2M 应用，CoAP协议改进了一些机制，同时增加了一些功能。图1 显示了HTTP和CoAP的协议栈。CoAP和HTTP在传输层有明显的区别。HTTP协议的传输层采用了TCP协议，而CoAP协议的传输层使用UDP协议，开销明显降低，并支持多播。

![2-1](http://ohe7ixo05.bkt.clouddn.com/2017/3/2-1.jpg)

　　CoAP协议采用了双层的结构。事务层(Transaction layer)处理节点间的信息交换，同时，也提供对多播和拥塞控制的支持。请求/响应层(Request/Response layer)用以传输对资源进行操作的请求和相应信息。CoAP协议的REST 构架基于该层的通信，REST请求附在一个CON 或者NON消息上，而REST响应附在匹配的ACK消息上。CoAP的双层处理方式，使得CoAP没有采用TCP协议，也可以提供可靠的传输机制。利用默认的定时器和指数增长的重传间隔时间实现 CON消息的重传，直到接收方发出确认消息。另外，CoAP的双层处理方式支持异步通信，这是物联网和M2M应用的关键需求之一。

#### CoAP报文

##### 报文格式

CoAP协议非常小巧，一个CoAP消息最小为4个字节，以下是CoAP协议不同部分的描述：

![2-2](http://ohe7ixo05.bkt.clouddn.com/2017/3/2-2.png)

【Ver】版本编号，指示CoAP协议的版本号。类似于HTTP 1.0 HTTP 1.1。版本编号占2位，取值为01B。

【T】报文类型，CoAP协议定了4种不同形式的报文，CON报文，NON报文，ACK报文和RST报文。

【TKL】CoAP标识符长度。CoAP协议中具有两种功能相似的标识符，一种为Message ID(报文编号)，一种为Token(标识符)。其中每个报文均包含消息编号，但是标识符对于报文来说是非必须的。

【Code】功能码/响应码。Code在CoAP请求报文和响应报文中具有不同的表现形式，Code占一个字节，它被分成了两部分，前3位一部分，后5位一部分，为了方便描述它被写成了c.dd结构。其中0.XX表示CoAP请求的某种方法，而2.XX、4.XX或5.XX则表示CoAP响应的某种具体表现。

【消息ID Message ID】每个CoAP消息都有一个ID，在一次会话中ID总是保持不变。但在这个会话之后该ID会被回收利用。

【标记 Token】标识符具体内容，通过TKL指定Token长度。

【选项 Options】：CoAP报文选项类似于HTTP请求头，它包括CoAP消息本身，例如CoAP端口号，CoAP主机和CoAP查询字符串等。

【1111 1111】CoAP报文和具体负载之间的分隔符。

【负载Payload】：真正有用的被交互的数据。

##### Option格式

**（1）组成部分**

 一般情况下Option部分包含Option Delta、Option Length和Option Value三部分。
 
 ![2-3](http://ohe7ixo05.bkt.clouddn.com/2017/3/2-3.png)
 
【Option Delta】表示Option的增量，当前的Option的具体编号等于之前所有Option Delta的总和。

【Option Length】表示Option Value的具体长度。

【Option Value】表示Option具体内容。

**（2）Option类型及编号**

CoAP中所有的Option都采用编号的方式，这些Option及编号的定义如下图所示。

![2-4](http://ohe7ixo05.bkt.clouddn.com/2017/3/2-4.png)

在这些option中，Uri-Host、Uri-Port、Uri-Path和Uri-Query等和资源“位置”和参数有关。

【3】Uri-Host:CoAP主机名称，例如iot.eclipse.org

【7】Uri-Port:CoAP端口号，默认为5683

【11】Uri-Path:资源路由或路径，例如\temperature。资源路径采用UTF8字符串形式，长度不计第一个"\"。

【15】Uri-Query:访问资源参数，例如?value1=1&value2=2，参数与参数之间使用“&”分隔，Uri-Query和Uri-Path之间采用“?”分隔。

在这些option中，Content-Format和Accept用于表示CoAP负载的媒体格式

【12】Content-Format:指定CoAP复杂媒体类型，媒体类型采用整数描述，例如application/json对应整数50，application/octet-stream对应整数40。

【17】Accept: 指定CoAP响应复杂中的媒体类型，媒体类型的定义和Content-Format相同。

**（3）Content-Format**

![2-5](http://ohe7ixo05.bkt.clouddn.com/2017/3/2-5.png)

【text/plain】 编号为0，表示负载为字符串形式，默认为UTF8编码。

【application/link-format】编号为40，CoAP资源发现协议中追加定义，该媒体类型为CoAP协议特有。

【application/xml】编号为41，表示负载类型为XML格式。

【application/octet-stream】编号为42，表示负载类型为二进制格式。

【application/exi】编号为47，表示负载类型为“精简XML”格式。

另外，还有一种格式也被IANA认定，也会在CoAP协议中广泛使用那便是CBOR格式，该格式可理解为二进制JSON格式。

【applicaiton/cbor】编号为60。


##### 消息类型

CoAP采用与HTTP协议相同的请求响应工作模式，CoAP协议共有4中不同的消息类型：

- CON：需要被确认的请求，如果CON请求被发送，那么对方必须做出响应。

- NON：不需要被确认的请求，如果NON请求被发送，那么对方不必做出回应。

- ACK：应答消息，接受到CON消息的响应。

- RST：复位消息，当接收者接收到的消息包含一个错误，接收者解析消息或者不再关心发送者发送的内容，那么复位消息将会被发送。

#### CoAP请求

##### 请求方法

在CoAP请求中，Code被定义为CoAP请求方法，这些方法有GET、POST、PUT和DELETE，这些方法和HTTP协议非常相似。

- GET方法：用于获得请求URI标识的资源

    The GET method is safe and idempotent. 

- POST方法：用于创建新资源或更新目标资源

    POST is neither safe nor idempotent.

- PUT方法：用于更新某资源

    PUT is not safe but is idempotent.

- DELETE方法：用于删除某资源

    DELETE is not safe but is idempotent.

##### 需要说明的问题

（1）safe

　　上面的英文是RFC 7252 文档的内容，其中的安全是指是否会改变服务器端的数据，而不是我们通常所说的数据的保密性。因为如果考虑到某些服务端和客户端的默认配置和默认使用方式，那么POST在很多时候比GET安全，因为GET的URL会被放在浏览器历史和WEB服务器日志里面。

（2）idempotent

　　idempotent的意思就是指CoAP方法重复执行多次，产生的效果是一样的。往一个URI发送一个CoAP的 PUT或者POST请求，CoAP的body部分就是一个文档，我们应该用PUT方法还是POST方法？取决于这个REST服务的行为是否是idempotent的。也就是我们采用PUT或者POST方法之后，服务器端是什么样的行为？如果产生了两个文档，那就说明这个服务不是idempotent的，因为多次使用产生了副作用了嘛；如果后一个请求把第一个请求覆盖掉了，那这个服务就是idempotent的。前一种情况，应该使用POST方法，后一种情况，应该使用PUT方法。


#### CoAP响应

##### 响应码

- Success：2.xx

    2.01 Created. 回复POST或者PUT。
    
    2.02 Deleted. 回复DELETE，有些情况下的POST。
    
    2.03 Valid. Indicate that the response identified by the entity-tag identified by the included ETag Option is valid. 所以，Response必须带ETag Option。　
    
    2.04 Changed. 回复POST和PUT。
    
    2.05 Content. 回复GET。

- Client Error：4.xx

    4.00 Bad Request. 错误的请求。
    
    4.01 Unauthorized 未经许可的。
    
    4.02 Bad Option 错误的选项
    
    4.03 Forbidden 访问被拒绝。
    
    4.04 Not Found 未找到。
    
    4.05 Method Not Allowed 方法不被允许。
    
    4.06 Not Acceptable 不可接受的。
    
    4.12 Precondition Failed 前提条件失败。
    
    4.13 Request Entity Too Large 请求实体太大。
    
    4.15 Unsupported Content-Format 不支持的内容格式。

- Server Error：5.xx
    
    5.00 Internal Server Error 内部服务器错误。

    5.01 Not Implemented 没有实现。
    
    5.02 Bad Gateway 错误的网关。
    
    5.03 Service Unavailable 服务不可用。
    
    5.04 Gateway Timeout 网关超时。
    
    5.05 Proxying Not Supported 代理不支持。

- Future Use：3.00-3.31

#### 请求/响应模型

Piggybacked Response, Separate Response, Non-confirmable Response三种类型

- Piggybacked Response. 

    ![2-6](http://ohe7ixo05.bkt.clouddn.com/2017/3/2-6.png)
    
    　　最常用的类型，Reponse内容直接放在ACK中。一个请求中携带的确认消息中携带的确认（ACK）消息的响应。

- Separate Response. 

    ![2-7](http://ohe7ixo05.bkt.clouddn.com/2017/3/2-7.png)
    
    　　Server暂时没办法直接回数据(可能需要更多的时间准备)，所以先直接回Empty ACK告诉Client请求我已经收到，数据准备好再给你发送数据，避免重复请求。当Server准备好了，给Client发CON(也可以是NON)，最后Client回ACK告诉Server数据我已经收到了。如果Server在回复Clinet之前又收到Client的重传，那么也回Empty ACK。

- Non-confirmable Response. 

    ![2-8](http://ohe7ixo05.bkt.clouddn.com/2017/3/2-8.png)
    
    　　Client发出NON，Server一般也回NON，但是，双方发出的消息都不要求是可靠的，即使有一方发送的数据另一方没接收到也没问题，因为不要求可靠也就是Client和Server都可以不得到数据。