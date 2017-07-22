---
title: Named Data Networking Based Smart Home Lighting
date: 2017-05-05 21:31:25
tags: [IoT,NDN]
categories: 论文研读
---

　　Named Data Networking Based Smart Home Lighting（全文翻译）
　　基于命名数据网络的智能照明系统

<!-- more -->

```
Named Data Networking Based Smart Home Lighting
基于命名数据网络的智能照明系统

Upeka De Silva
Asian Institute of
Technology,Thailand
st116384@ait.asia

Adisorn Lertsinsrubtavee
University of Cambridge
al773@cam.ac.uk

Arjuna Sathiaseelan
University of Cambridge
as2330@cam.ac.uk

Kanchana Kanchanasut
Asian Institute of
Technology, Thailand
kanchana@ait.asia
```

#### 引言

　　物联网（IoT）目前的势头正在鼓励科学界和行业界将目前的基于仓库的物联网平台模型发展成为一个全球统一的物联网平台-一个能够有效支持50-100亿网络对象的平台。为了应对这一挑战，出现了几个提议，例如建立覆盖在今天的以主机为中心的互联网之上的统一的以主机为中心的物联网平台。或者，网络社区建议使用信息中心网络（ICN），如NDN（命名数据网络）来应对挑战。NDN使用基于名称的路由在简单的有状态转发平面中传送数据包。它为开发人员在命名，安全性，缓存和固有多播支持方面提供了极大的灵活性。它避免了依赖于独立协议和IoT网络中使用的各种中间件。

　　在本文中，我们使用NDN提供家庭智能照明系统的初步评估，并展示了使用ICN模式来满足IoT挑战的一些优势。我们开发了一个原型，并将其与基于IP云的方法进行了对比。

#### NDN智能照明解决方案

　　NDN使用两种类型的数据包：Interest和Data来实现基于有状态转发平面的请求/响应架构，两种数据包都提供了类似URI的名称。天然支持组播传送，并且基于名称转发Interest包，随后聚合并复制对应的Data包。数据包是自我描述和自我保护的，这使得它们能够被缓存和重用。从数据位置解耦数据检索可实现分散的，有效的，可扩展和安全的内容分发模型。

![5-1](http://ohe7ixo05.bkt.clouddn.com/2017/5/5-1.png)

　　我们的架构如图1所示，家庭路由器，一个连接所有IoT设备的无线路由器；智能控制器，一个具有无线接口（802.11g）的IoT平台；灯节点：通过一个执行器连接到一个智能控制器的普通灯泡，它可以远程切换灯泡开关。占用检测器：一种运动传感器，用于跟踪人员进出房间的动作。光度检测器：用于测量勒克斯灯光亮度的光传感器。智能家居控制器：在智能控制器上运行的智能家居应用程序，可根据房间占用和日光来控制灯光。我们分别使用Raspbian Wheezy和OpenWrt 12.09配置了树莓派和家庭路由器。NDN转发进程二进制数用于启用NDN功能。我们使用PyNDN客户端库开发了Python中的最终应用程序。

　　**NDN基于推送的通信机制：**NDN本质上支持基于拉式的通信。然而，在像智能照明这样的一些应用中，基于推送的数据传送更合适。占用检测器使用推送发送关于检测到的运动的数据并传播测量的光照水平。数据是一个20字节的字符串直接附加在Interest包中被发送，这种方法被称为Interest通知。图2显示了基于名称路由的光照强度检测器和光照强度监视器之间的消息流程示例。光照强度检测器每五秒钟测量一次光线，并将包含光照强度值和时间戳的Interest通知推送到智能控制器，该智能控制器通过静态路由向家用路由器注册名称前缀，以接收此类通知。

![5-2](http://ohe7ixo05.bkt.clouddn.com/2017/5/5-2.png)

　　**基于名字的多播：**我们的解决方案通过使用聚合命名空间从NDN的固有组播通信中获益。单个Interest就包足以将任务命令给多个设备。例如，名为/home/light/floor1/的Interest包将被在floor1和switch off发布了相同名字的每个节点接收。

　　**FIB优化：**NDN使用称为转发兴趣库（FIB）的数据结构作为记录输出接口与名称匹配的路由表。为了扩大规模，我们通过在本地代理使用Interest过滤器以他们的内部NDN名字过滤匹配的Interest包来优化FIB。这样做的效果是单个FIB条目足以使节点捕获具有多个匹配层次结构的Interest。

#### 初步结果

　　我们将系统与NetPie进行了比较，NetPie是一个本地云平台，拥有自己的即时消息系统，支持MQTT协议和HTTP RESTful API。为了将我们的平台连接到NetPie，我们为每个设备实现了客户端模块，并将其注册到NetPie服务器。我们使用匹配的身份和应用程序标识（home）来配置模块，以便他们可以按类似URI的主题名称认证和发布数据。我们关注消息传送延迟的评估：从生产者传递到消费者的消息所花费的时间。图3显示了在NDN和云方式下的光照强度检测器和智能家居控制器之间的消息传送延迟的CDF。使用云端时，我们通过从家庭路由器ping云服务器，并分别测量了互联网传输开销延迟（ITOD），估计大约为70ms。我们从消息传输延迟中扣除了这个开销，以模拟本地运行的云。

![5-3](http://ohe7ixo05.bkt.clouddn.com/2017/5/5-3.png)

　　该图显示，在NDN和云中，85%的消息分别以小于23ms和142ms的延迟发送。当从云方法中扣除互联网传输开销时，85%的消息在不到72ms内传输。这表明即使云在本地托管，由于处理开销及其协议栈，延迟仍高于NDN。延迟降低在诸如智能照明的应用中是重要的，以确保实时响应和同时控制灯组。使用云，多个消费者可以通过订阅相关主题来接收亮度消息，而在NDN下，多个消费者可以通过注册家庭路由器的FIB中的相关名称前缀来订阅光照强度的Interests通知。由于NDN的组播转发功能，所有消费者可以同时接收到兴趣通知。相比之下，NDN比基于云的平台提供了更高的性能和更大的灵活性。当流量是本地时，这是特别有用的。

参考文献：

[1] M. Amadeo, et al. Internet of things via named data networking: The support of push tra!c. In Network of the Future, 2014.

[2] V. Jacobson, et al. Networking named content. In ACM CoNEXT, 2009.

[3] Y. Zhang et al. Requirements and Challenges for IoT over ICN. IRTF-Draft, 2016.
