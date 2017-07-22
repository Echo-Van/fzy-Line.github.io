---
title: 基于IPV6和ZIGBEE技术的智能家居系统(全文翻译)
date: 2017-01-23 22:51:09
tags: [IPv6,ZigBee,智能家居]
categories: 论文研读
---

　　开始学习如何阅读英文文献，刚开始只是做了简单的翻译工作，选择的论文也是与自己毕业设计的主题有关，一方面是为了探索英文文献的阅读方法，另一方面为自己的毕业设计做一些准备。目前来看，读起来比较困难，但是相信会慢慢进步的。

<!--more-->

**Smart Home System Based on IPV6 and ZIGBEE Technology**

**基于IPV6和ZIGBEE技术的智能家居系统**

Zhenyu Zou a , Ke-Jun Li b* , Ruzhen Li a and Shaofeng Wu b

a Shangdong Electric Power Engineering Consulting Institute Corp. ,Ltd., Jinan250013, China

b School of Electrical Engineering, Shandong University, Jinan250061, China


摘要：

--------------------------------------------------------------------------------
　
　Because of high-speed growth of computer control technology and communication technology, it led to the birth of smart home. ZigBee technology is intended to be a suitable standard for a low-rate wireless home control system. The remotely controlling information appliances based on Ipv6 in a home network has become a major request for nowadays consumers. In the paper an IPv6 and Zigbee home network frame is described briefly and the real products are introduced capable of home networking like home gateway and information appliance.

--------------------------------------------------------------------------------

　　由于计算机控制技术和通信技术的高速发展,它引导了智能家居的诞生。ZigBee技术想要成为一个低速无线家庭控制网络的合适标准。在一个家庭网络中基于IPv6的信息家电远程控制对于今天的消费者来说已经变成一个主要的需求。在本文中简要描述了一个IPv6和Zigbee家庭网络框架，并介绍了家庭网络的真实产品，比如家庭网关和信息家电。

Keywords: Smart home; Ipv6; Zigbee; Home Gateway

关键词：智能家居；Ipv6；Zigbee；家庭网关

##### 前言

--------------------------------------------------------------------------------

　ZigBee is an emerging network technology as a wireless communication standard that is capable to satisfy such requirements with advantage of low cost, low power and wider　coverage, and therefore it is very suitable for the development and utilization of home. IPv6 offers new function such as address that is extended from 32 bits to 128bits, autoconfigura-tion and more powerful security. Given the global climate changes and limited resources, now it is the time to build energy awareness directly into nextgeneration products. Over 100 mil-lion smart me-ters slated are to be installed worldwide over the next five to seven years. This "tidal wave" forming in the horizon will have a dramatic impact on consumer products as homeowners search for cost-effective solutions for managing their energy.

--------------------------------------------------------------------------------

　　ZigBee作为一个无线通信标准是一种新兴的网络技术，它能够很好的满足这些需求并且有低成本、低功耗、覆盖范围广的优点，因此它非常适合用于家庭开发和利用。IPv6提供新的功能比如从32位扩展到128位的地址、自动配置以及更强大的安全。

　　考虑到全球气候变化和有限的资源，现在是时候树立能源意识直接进入下一代产品。在世界范围内未来五至七年将有超过1亿的智能电表被安装.这种在地平线上形成的“浪潮”将产生巨大的影响
消费者产品，因为房主寻找具有成本效益的解决方案来管理他们的能量

##### 家庭网络体系结构

--------------------------------------------------------------------------------

　The structure of the smart home network requires three different devices: coordinator, router and end device. Home environment can then be monitored, and the required data can be delivered to the coordinator or home gateway. After program execution, proper control commands will be sent from the gateway through coordinator to home appliances. Figure1 shows home network architecture.
　A supervisory control Intranet system which is low cost and high performance can be implemented by the ZigBee technology. A terminal node first sends the data to coordinator node and then this coordinator node retransmits the data to the aiming terminal node in return. Since all appliances have their own IP addresses based on the IPv6, they can be directly connected to external network. So all appliances can be not only controlled locally and centrally through the hand remote control device at home but also can be controlled by the long-distance PC, which entered the home gateway machine through the Internet.

--------------------------------------------------------------------------------

　　智能家居网络的结构需要三个不同的设备:协调器、路由器和终端设备。家庭环境可以被监控,所需的数据可以通过协调器或家庭网关传递。程序执行后，适当的控制命令将从家庭网关通过协调器到达网关家电。图1显示了家庭网络架构。

　　一个低成本高性能的监控内部网系统能够通过ZigBee技术来实现。一个终端节点首先将数据发送到协调器节点，然后协调器节点转发数据到目标终端节点作为回报。因为所有的家用电器都有自己基于IPv6的IP地址，他们可以直接连接到外部网络。因此，所有的设备都不仅可以在家里通过手遥控装置进行本地和集中控制，而且也可以由通过互联网进入家庭网关机器的远程电脑控制。

##### 家庭网关的初步设计

--------------------------------------------------------------------------------

　The home wireless network often adopts star topological structure, and is made of home gateway and several ZigBee sensors node module. Home gateway is a full-featured device, which acts as a network coordinator for a network establishment and normal operation. It is also an easy and effective way to control the intelligent home devices outside or in other place through mobile module embedded in gateway for remote user. Mobile terminals include PDAs, remote controllers and mobile phones. The mobility of the terminals can be managed through IPv6 mobility support. In this way, users can complete the operation over the Internet in public places to improve the system's flexibility and maneuverability. Figure2 illustrates home gateway architecture with information appliance.

--------------------------------------------------------------------------------

　　家庭无线网络通常采用星型拓扑结构，是由家庭网关和几个ZigBee传感器节点模块组成。家庭网关是一个功能齐全的设备,扮演着网络协调者的角色，用于网络建立和正常运作。在外面或者在其他地方通过为远程用户的移动模块嵌入网关也是一种简单而有效的控制智能家庭设备方法。移动终端包括掌上电脑、遥控器和移动电话。移动终端可以通过通过IPv6流动性支持来进行管理。通过这种方法，用户在公共场所可以在互联网上完成操作来提高系统的灵活性和可操作性。图2说明了家庭网关体系结构的信息设备。

##### 家庭网关和设备之间的通信

--------------------------------------------------------------------------------

　The control center of network is home gateway system, which is, from inside, to coordinate all household appliances, control their working condition and inquiry their current status, and, from outside, connect with Internet, receive remote users' instructions and transfer related information to business sites.

　Internal Communication. Every data transmit between ZigBee network can be communicated by each other, so people in any room can control the other room's devices. 　   　The query flow-work of home appliance is shown as follows: Appliance receives information fromhome gateway by ZigBee module and detects the household appliance’s status, then corresponding status will be transmitted to the home gateway by ZigBee module. If all appliances work properly, home gateway stores appliances' status. If not, home gateway reports an error message to supplier.

　External Communication. Home gateway interconnects Internet and the home network. It sends all devices information in home network to the portal server via TCP/IP socket. And also it can control and monitor the devices with date packet communication. Thus it enables users to control and monitor the home networks through Internet and even mobile phone since the portal server has the mobile interface.
　The control flow-work of home appliance is shown as follows: Home gateway receives external packets, then unpacks and gets the destination address. The next step is to select routing (destination appliance) and then transmit the data. Appliance receives the data and tests them. If the data are error, the appliance then returns an unsuccessful message to the home gateway. If proper, appliance implements corresponding operation and returns the operation information to home gateway.

--------------------------------------------------------------------------------

　　网络的控制中心是家庭网关系统，从内来说它是协调所有家用电器，控制其工作状况并查询其当前状态，从外来说它是连接互联网，接收远程用户的指令并将相关信息传送到商业站点。

　　内部通信。每一个在ZigBee网络传输的数据都能够被相互送达，所以人们在任何房间可以控制其他房间的设备。
　　家电的查询工作流程如下所示：设备通过ZigBee模块从家庭网关接收信息，并检测家用电器的状态，然后相应的状态信息将会通过ZigBee模块传送到家庭网关。如果所有家电正常工作，家庭网关存储家电的状态。如果不是，家庭网关报告一个错误信息给供应商。

　　外部通信。家庭网关连接互联网和家庭网络。它通过TCP / IP套接字将家庭网络中的所有设备信息发送到门户服务器。它也可以控制和监控设备通过数据包通信。因此，允许用户通过互联网甚至是移动电话来控制和监控家庭网络，因为门户服务器有手机接口。
　　家电的控制工作流程如下所示：家庭网关接收到外部包，然后解包得到目的地址。下一步是选择路由（目的家电）并且传输数据。设备接收数据，并测试它们。如果数据是错误的，家电会返回一个不成功消息到家庭网关。如果正确，家电执行相应的操作并将操作信息返回给家庭网关。

##### 家庭网络协议

--------------------------------------------------------------------------------

　The protocol enables whole devices to be aware of the status updates of other devices by questioning periodically. To support this, three types of packets are defined in protocol: request packet, response packet and event packet. Those packets are identified with the packet type field in the packet header.There are four main codes for controlling as follows:

　Name code. The appliance name affects its label. Every information appliance has a relevant name. Different embedded electric appliance systems must have different appliance labels identical to the appliance word set in the system.

　State code. Another important message is the device state code. It is returned from the embedded system to tell the management interface what status appliances are currently in. An example is“//Power on=on/Power off=off/Probe temperature=24/Turn up=off/Strong wind=on//”. Management can list device state codes directly on the page to tell the user the state of a device.

　Command code. The protocol provides variable-length packet structure that is composed of 1-byte command code and input/return arguments. Using this type of message makes it easy to incorporate protocol into white goods such as air conditioner and microwave oven etc. The devices need to interpret the command codes and gateway that wants to control devices should be able to compose every type of message that has to be interpreted by each device.

　Home code. Home network protocol defines home code to make a home network to be independent from others in packet level communication. It looks a home as a close network that is necessary to be private from neighbors. Basically home code is generated into random 4 bytes value and is used to prevent neighbor's data from coming over and interfering with.

--------------------------------------------------------------------------------

　　这个协议通过定期的询问使得所有的设备能够意识到其他设备的状态更新。为了实现这个，协议中定义了三种类型的包：请求数据包、响应包和事件包。这些数据包通过数据包头部的数据包类型字段被识别。有四个主要控制代码如下：
　　名称码：设备名称影响它的标签。每一个信息设备都有相关的名称。不同的嵌入式电器系统必须有不同的设备标签相同的设备字集在系统中。
　　状态码：另一个重要的消息是设备状态码。它从嵌入系统被返回告诉管理界面家电设备目前的状态。一个例子是“//Power on=on/Power off=off/Probe temperature=24/Turn up=off/Strong wind=on//”。管理系统可以直接在页面上列出设备状态码来告诉用户设备的状态。
　　指令码：协议提供了变长数据包结构，由1个字节命令码和输入/返回参数。使用这种类型的消息使它很容易将协议合并到大型家电，例如空调、微波炉等。这些设备需要解释命令码，并且想要控制设备的网关应该能够组成每一种类型的消息，因为它必须被每一个设备解释执行。
　　家庭码：家庭网络协议定义了家庭代码使其在包级别的通信中与其他的独立起来。看起来好像一个家庭就是一个关闭的网络，这有必要远离邻居。基本的家庭代码被生成随机的4字节的值，它被用来防止邻居的数据过来和干扰。

##### ZigBee/ 802.15.4和IPv6/802.3网络之间的网络互连

--------------------------------------------------------------------------------

　ZigBee is the most popular wireless network communication technology. Since the TCP/IP has become the dominant protocol in the Internet due to its widespread use and reliability, and also the 802.3 Ethernet is networking standard, the demand for internetworking between ZigBee/802.15.4 and TCP/IP/802.3 is inevitable. However, the ZigBee itself is not compatible with the IP-based network. It is a great challenge to integrate these two kinds of networks together. In general, Sensor networks and IP can play together by means of three approaches:
(1) The straight forward method to make IPv6 work over ZigBee is to put the IPv6 stack on the top of ZigBee NWK layer. All the ZigBee nodes are assigned with an IPv6 address.
(2) Another approach is IP-Net. It is a dual stack approach. Both the 6LoWPAN design and ZigBee stack are working on the same 802.15.4 MAC.
(3) A gateway that allows both a 6LoWPAN and Zigbee device indifferently to be converted to IPv6, would be desirable. If we apply the IP-NET concept of a dual stack in one side of the gateway, we can obtain an interoperable gateway.

--------------------------------------------------------------------------------

　　ZigBee是最受欢迎的无线网络通信技术。由于TCP / IP 的广泛使用和可靠性，它已经成为互联网中占主导地位的协议，以及802.3以太网是网络的标准，因此ZigBee/ 802.15.4和TCP / IP / 802.3之间的网络互连是必然的。然而，ZigBee本身并不兼容的基于ip的网络。集成这两种网络连接在一起是一个巨大的挑战。通常，传感网络与IP可以通过以下三种方法连接在一起：
（1）让IPv6工作在ZigBee之上的直接的方法是将IPv6协议栈放在ZigBee NWK层的顶部。所有的ZigBee节点分配一个IPv6地址。
（2）另一种方法是IP-Net。这是一个双栈的方法。6 lowpan设计和ZigBee栈都工作在802.15.4 MAC层。
（3）一个允许一个6 lowpan和ZigBee设备被转换成IPv6的网关将是可取的。如果我们在网关的一边应用IP-NET双栈的概念，我们可以获得一个能共同操作的网关。

##### 智能家居装置

--------------------------------------------------------------------------------

　The appliance receives information from home gateway by ZigBee module and then generates corresponding signals to manipulate the smart appliances. As long as the signal being detected by the sensors of the terminal nodes, it will be transmitted to the home gateway by ZigBee module, to deal with corresponding task.

　To achieve remote control, the terminal device is formed with the network terminals and micro-controller. Appliance control module connected with executing system can get commands from the network termination module and operate home appliances. The network terminal module is the core of information appliance system, which allows access to IPv6 network appliances, and serves as an embedded web server to respond to the request of the client. The appliance automatically gets the routing prefix of 64-bit of IPv6 distributed by network processor. Together with the existing 64-bit interface identifier for each household appliance, it can form the world's sole128-bit IPv6 address.

　In order to reduce costs and improve network efficiency, appliances can be classified as smart appliances and non-smart appliances according to the function. Corresponding node can be divided into normal and complex control node. Smart appliances, such as air conditioning, only need to realize switching function. Non-smart appliances, such as television, not only realize switching function, but also require complex instruction to realize some other functions.

--------------------------------------------------------------------------------

　　这个装置通过ZigBee模块从家庭网关接收信息，然后生成相应的信号来控制智能家电。只要信号被终端节点的传感器检测到。它将通过ZigBee模块传送给家庭网关去处理相应的任务。
　　为了实现远程控制，终端设备由网络终端和微控制器组成。与执行系统相连的装置控制模块可以从网络终端模块得到命令和操作家用电器。网络终端模块是信息设备系统的核心，它允许访问IPv6网络家电和作为嵌入式web服务器响应客户机的请求。设备自动获得由网络处理器分配的IPv6 64位路由前缀。结合现有的每一个家用电器的64位接口标识符，它可以形成世界唯一的128位IPv6地址。
　　为了降低成本和提高网络效率，家电能够根据功能被分类为智能设备和非智能设备。相应的节点可以分为正常的和复杂的控制节点。智能家电，例如空调，只需要实现切换功能。非智能家电，例如电视，不但实现切换功能，而且也需要复杂指令来实现其他功能。

##### 智能电表和家电节能控制

--------------------------------------------------------------------------------

　Smart utility meters play an important role in the energy aware scheme. The backbone of the smart grid is the AMI that typically involves the installation of smart meters that remotely read electricity consumption, remotely connect and disconnect service, and deliver prepaid electricity to customers. Achieving it requires a monitoring and control solution that involves makers of home appliances, home controls, and in-home displays. An integrated, high-performance, GUI technology keeps consumers informed. The home energy management system relies on the power consumption history to control appliances and consists of a group of functions that facilitate remote monitoring, controlling, planning and repairing of operations and provide information on the status of installed devices and the network. The system includes micro-generation which allows customers to be net buyers or sellers of electricity at different times and with different tariffs.

　When controlling home appliances, interconnection between appliances should be considered, especially these have positive connection. At that time, peer to peer network is often required instead of star network. There is a typical example to illustrate the coordination between air conditioning and water heater. Both of them are the maximum power consumption appliances. But if we input the cold water released from the heating equipment of heater to the refrigeration equipment of air conditioning, while input the heat released from the refrigeration equipment to the heating equipment of heater, maximum power will be saved by the two-way recycling use.

--------------------------------------------------------------------------------
　　
　　智能电表在能源意识计划中发挥了重要作用。智能电网的骨干是AMI，它通常涉及到智能电表的安装，远程读表、远程连接和断开服务，并提供预付电费客户。实现它需要一个监视和控制的解决方案，它涉及家用电器制造商、家庭控制装置和家庭显示器。一个集成的、高性能、GUI技术使消费者被通知。家庭能源管理系统依靠电力消费历史来控制家电，由一组功能组成来促进远程监视、控制、计划和修复操作。并提供安装设备的状态和网络信息。该系统包括微产能，它允许客户在不同的时间并且以不同的价格作为电的净买家或卖家。

　　在控制家用电器的时候，家用电器之间的互连需要被考虑，尤其是这些有实际连接件的。那时候，点对点网络通常被要求替换星型网络。有一个典型的例子来说明空调和热水器之间的协作。他们都是最大功耗家电。但是，如果我们输入来自热水器加热设备释放的冷水到空调的制冷设备，然而，来自空调制冷设备的热水输入到热水器的加热设备，通过双向循环利用最大功率将被节省。

##### 结论

--------------------------------------------------------------------------------

　Existing technologies can be integrated using IPv6 and ZigBee to provide a manageable wireless home network. The home energy management system offers a simple approach to help homeowners save household energy and offers a new way of life devoted to a greener, better intelligent to everyone.

--------------------------------------------------------------------------------

　　现有技术可以集成使用IPv6和无线个域网提供可控的无线家庭网络。家庭能源管理系统提供了一种简单的方法来帮助房主节省家庭能源,并给每个人提供了一种新的致力于环保的生活方式和更好的智能。