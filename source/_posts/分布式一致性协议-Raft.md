---
title: 分布式一致性协议 Raft
tags:
  - Raft
categories:
  - Distributed
abbrlink: 26996
date: 2019-11-09 22:51:54
---

<center>分布式一致性协议 Raft 学习。</center>

<!--more-->

#### 概念

　　Raft 协议有效的借鉴了美国总统大选的策略，采用精英（Raft 称呼这个精英为 Leader）领导全局的方案，整个集群中只有 Leader 可以处理 client 发送过来的请求，其他非 Leader 节点即使接收到请求也必须将其转发到 Leader 节点进行处理。Raft 集群中的成员分三种角色：

- Leader：领导者，处理所有客户端交互，日志复制等，一般一次只有一个Leader。
- Follower：追随者，类似选民，完全被动。
- Condidate：候选人，可以被选为一个新的领导人。

![9-1](https://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/11/9-1.jpg)

　　英文动画演示：http://thesecretlivesofdata.com/raft/

#### 选举过程

##### 两个超时

- 选举超时

　　为了每个节点同时发起投票，会给每个节点分配一个随机的选举超时时间（Election Timeout），即从Follower 状态成为 Candidate 状态需要等待的时间，随机分配在 150ms 到 300ms 之间。在这个时间内，节点必须等待，不能成为 Candidate 状态。

- 心跳超时

　　Leader 会固定间隔时间向 Follower 节点发送心跳消息，这个固定间隔时间被称为心跳超时（Heartbeat Timeout）

##### 选举流程

1. 在集群初始状态下是没有 Leader 的，集群中所有成员均是 Follower。在选举开始期间，任何一个服务器（Follower）都可以成为一个候选者（Candidate）。

2. 每一个节点都有自己的计时器，当计时达到了超时时间（Election Timeout），该节点会转变为Candidate。它向其他服务器（Follower）发出要求选举自己的请求。

3. 其他收到投票请求且还未投票的服务器（Follower）节点会发出 OK 进行投票，发起者收到反馈通知后

   票数增加。

4. 如果在这个过程中，候选者可以自己选自己，只要达到 N/2 + 1 的大多数票，候选人就可以成为Leader，其余落败的 Condidate 角色转变为 Follower 开始服从 Leader 领导。

5. 选举出 Leader 后 Leader 会定期向所有 Follower 发送 heartbeat 来维护其 Leader 地位，并且可以向选民（Follower）发出指令，比如进行日志复制。

##### 重新选举

　　如果所有 Condidate 均投票给自己，这样无法决出票数多的一方。Raft 算法为了解决这个问题引入了北洋时期袁世凯获选大总统的谋略，即选不出 Leader 不罢休，直到选出为止，一轮选不出 Leader，便令所有 Condidate 随机 sleep（Raft 论文称为 timeout，选举超时）一段时间，然后马上开始新一轮的选举，这里的随机 sleep 就起了很关键的因素，第一个从 sleap 状态恢复过来的 Condidate 会向所有 Condidate 发出投票给我的申请，这时还没有苏醒的 Condidate 就只能投票给已经苏醒的 Condidate ，因此可以有效解决 Condiadte 均投票给自己的故障，便可快速的决出 Leader。

　　如果 Follower 一段时间后未收到 Leader 的心跳则认为 Leader 已经挂掉，便转变自身角色为 Condidate，同时发起新一轮的选举，产生新的 Leader，其继续承担日志复制等指导工作。

#### 日志复制

　　日志复制（Log Replication）主要作用是用于保证节点的一致性，这阶段所做的操作也是为了保证一致性与高可用性。

![9-2](https://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/11/9-2.jpg)

　　数据一致性策略：Raft 协议强依赖 Leader 节点来确保集群数据一致性。即 Client 发送过来的数据均先到达 Leader 节点，Leader 接收到数据后，先将数据标记为 uncommitted 状态，随后 Leader 开始向所有 Follower 复制数据并等待响应，在获得集群中大于 N/2 个 Follower 的已成功接收数据完毕的响应后，Leader 将数据的状态标记为 committed，随后向 client 发送数据已接收确认，再向所有 Follower 节点发送通知表明该数据状态为committed。

　　日志复制流程：

1. 假设 Leader 已经选出，这时客户端向 Leader 发出增加日志的请求。
2. Leader 要求 Follower 遵从他的复制指令，都将这个新的日志内容追加到他们各自日志中。如果一次复制失败，会不断进行重试。
3. 大多数 Follower 服务器将新的日志写入磁盘文件后，确认追加成功，发出 Commited OK。
4. 随后提交自己的日志，向 client 发送数据已接收确认。在下一个心跳中，Leader会通知所有 Follower 更新 commited 项目。

#### 安全性

##### 选举限制

　　拥有最新的已提交的日志的 Follower 才有资格成为 Leader。

　　Candidate 在请求其他服务器（Follower）投票给自己时，要带上自己的最后一条日志的 term 和日志 index，其他节点收到消息时，如果发现自己的日志比请求中携带的更新，则拒绝投票。日志比较的原则是，如果本地的最后一条日志的 term 更大，则 term 大的更新，如果 term 一样大，则日志 index 更大的更新。

##### 日志提交限制

　　Leader 只能推进 commit index 来提交当前 term 的已经复制到大多数服务器上的日志，旧 term 日志的提交要等到提交当前 term 的日志来间接提交（log index 小于 commit index 的日志被间接提交）。通俗来说，Leader 可以复制前面 term 的日志，但是不会主动提交前面 term 的日志。而是通过提交当前 term 的日志，而间接地提交前面 term 的日志。

![9-3](https://fzy-blog.oss-cn-shenzhen.aliyuncs.com/2019/11/9-3.png)

1. 在 (a) 中，S1 是 Leader，部分的复制了索引位置 2 的日志条目。
2. 在 (b) 中，S1 离线，然后 S5 在任期 3 里通过 S3、S4 和自己的选票赢得选举，然后从客户端接收了一条不一样的日志条目放在了索引 2 处。
3. 然后到 (c)，S5 又离线了；S1 重新启动，选举成功，开始复制日志。在这时，来自任期 2 的那条日志已经被复制到了集群中的大多数机器上，但是还没有被提交。
4. 如果 S1 在 (d) 中又离线了，S5 可以重新被选举成功（通过来自 S2，S3 和 S4 的选票），然后覆盖了他们在索引 2 处的日志。反之，如果在离线之前，S1 把自己主导的新任期里产生的日志条目复制到了大多数机器上，就如 (e) 中那样，那么在后面任期里面这些新的日志条目就会被提交（因为S5 就不可能选举成功）。 这样在同一时刻就同时保证了，之前的所有老的日志条目就会被提交。

　　在上图中，trem 2 内产生的日志可能在 (d) 的情况下被覆盖，所以在出现 (c) 的状态下，Leader 节点是不能提交 term 2 的日志条目的，即不能更新 commit index。

　　在上图 (e) 的情况下，commit index 的变化应该是1->3，即在 (c) 的情况下，term 4 在索引 3 的位置 commit 了一条消息，commit index 直接被修改成 3。而 term 2 的那条日志会通过 Log Matching Property 最终被复制到大多数节点且被应用。