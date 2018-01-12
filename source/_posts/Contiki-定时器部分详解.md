---
title: Contiki 定时器部分详解
date: 2017-04-06 17:24:47
tags: ［IoT,Contiki,timer］
categories:
- IoT
- Contiki
---


　　Contiki有一个clock模块和一系列timer模块：timer，stimer，ctimer，etimer，和rtimer。

　　contiki的定时器种类太多，在初期会让人有一种分不清的感觉。都是以timer（硬件定时器）为基础拓展成软件的定时器方式，有的以事件方式、有的以回调方式，有的通过粗精度来保证软件的低消耗，可以通过功能的划分来选择不同的定时器。

<!--more-->

#### Clock模块

clock.h位于contiki/core/sys。该文件为内核文件，定义了clock模块实现的接口和必要条件。

- clock_init()函数

就是初始化系统时钟。

- clock_time()函数

函数就是计时函数，直接返回count的值，这样就知道当前时间了。

- clock_seconds()函数

函数返回以秒为单位的数值seconds。该全局变量在时钟中断函数中，每当count值为128时，都会加1，相当于每增加1都经过了1秒。

- clock_delay()和clock_wait()函数

用来阻塞CPU的，但不会放弃控制权，就是平常的延时函数，有的底层驱动可能会需要。

CLOCK_SECOND宏就是一秒的宏，该宏值乘以7.8ms应该是1s，所以程序里面设置该宏值为128，这样，128 * 7.8 = 998.4≈1S。

有clock.h必有clock.c，该文件与具体的硬件平台有关，它可以位于contiki/cpu/下，也可以位于contiki/platform/下。

#### Timer定时器

##### 简介

　　Timer定时器以clock的tick作为时间精度，它是Contiki系统最基础的定时器，它使用Contiki系统时钟模块中的clock_time()函数来获取系统当前时间以便实现定时功能，等待时间到达以后触发，需要轮询调用，即应用程序必须去主动检查定时器是否过期,不能自动的的获得过期的消息。clock模块提供一些处理系统时间的函数，还有一些用来阻塞CPU的函数。

##### 定时器API定义

/home/user/contiki/core/sys/timer.h

```
#ifndef TIMER_H_
#define TIMER_H_

#include "sys/clock.h"

/**
 * 定义一个Timer定时器对象。定时器在使用之前必须通过timer_set()进行设置。
 */

struct timer {
  clock_time_t start;
  clock_time_t interval;
};

//设置并启动一个Timer定时器对象
CCIF void timer_set(struct timer *t, clock_time_t interval);
//复位一个Timer定时器对象
void timer_reset(struct timer *t);
//重启一个Timer定时器对象
void timer_restart(struct timer *t);
//检查一个Timer定时器对象是否到期
CCIF int timer_expired(struct timer *t);
//获取一个Timer定时器对象距离所设置的到期时长还剩余多少时间
clock_time_t timer_remaining(struct timer *t);


#endif /* TIMER_H_ */
```

##### API的具体实现

位于/home/user/contiki/core/sys目录下的timer.c文件中。

#### Stimer

##### 简介

　　设定定时器，以second作为时间精度，等待时间到达以后触发，需要轮询调用。实际上stimer这个模块跟timer的用法，及API的功能完全一致，只不过timer定时us级别的时间，stimer定时s级别的时间。

##### 定时器API定义

/home/user/contiki/core/sys/stimer.h

```
#ifndef STIMER_H_
#define STIMER_H_

#include "sys/clock.h"

/**
 * 定义一个Stimer定时器对象。定时器在使用之前必须通过stimer_set()进行设置。
 */
struct stimer {
  unsigned long start;
  unsigned long interval;
};

// 设置并启动一个Stimer定时器对象
void stimer_set(struct stimer *t, unsigned long interval);
// 重置一个Stimer定时器对象
void stimer_reset(struct stimer *t);
// 重启一个Stimer定时器对象
void stimer_restart(struct stimer *t);
// 检查一个Timer定时器对象是否到期
int stimer_expired(struct stimer *t);
// 获取一个Timer定时器对象距离所设置的到期时长还剩余多少时间
unsigned long stimer_remaining(struct stimer *t);
// 得到定时器启动后的时间
unsigned long stimer_elapsed(struct stimer *t);

#endif /* STIMER_H_ */
```

##### API的具体实现

位于/home/user/contiki/core/sys目录下的stimer.c文件中。

#### Etimer

##### 简介

　　事件定时器，调用clock_time获得当前系统的时间，它提供产生时间事件（timed event）的机制，当设定好的定时器到期时将会给绑定定时器的线程发送一个PROCESS_EVENT_TIMER 事件；

　　contiki系统可以使用这个定时器做事件调度，主要用在contiki进程当系统的其它功能工作或休眼时，这个进程在等待一个时钟周期。Rime协议栈里面会经常用来处理通信超时。

##### 定时器API定义

/home/user/contiki/core/sys/etimer.h

```
#ifndef ETIMER_H_
#define ETIMER_H_

#include "sys/timer.h"
#include "sys/process.h"

// 定义一个Etimer定时器对象，定时器在使用之前必须通过etimer_set()进行设置。
struct etimer {
  struct timer timer;
  struct etimer *next;
  struct process *p;
};

// 设置并启动一个Etimer定时器对象
CCIF void etimer_set(struct etimer *et, clock_time_t interval);
// 重置一个Etimer定时器对象
CCIF void etimer_reset(struct etimer *et);
// 重启一个Etimer定时器对象
void etimer_restart(struct etimer *et);
// 获取事件定时器的过期时间。
void etimer_adjust(struct etimer *et, int td);
// 获取事件定时器的到期时间
clock_time_t etimer_expiration_time(struct etimer *et);
// 获取事件定时器的启动时间
clock_time_t etimer_start_time(struct etimer *et);
// 检查一个Etimer定时器对象是否到期
CCIF int etimer_expired(struct etimer *et);
// 停止一个Etimer定时器对象
void etimer_stop(struct etimer *et);
// 通知事件定时器时钟已更改
void etimer_request_poll(void);
// 检查是否有任何非过期的事件定时器
int etimer_pending(void);
// 所有即将到期的事件定时器的下一个到期时间
clock_time_t etimer_next_expiration_time(void);

PROCESS_NAME(etimer_process);
#endif /* ETIMER_H_ */
```

##### API的具体实现

位于/home/user/contiki/core/sys目录下的etimer.c文件中。


#### Ctimer

##### 简介

　　回调定时器，调用etimer，触发以后调用回调函数；

　　由于Ctimer同样也是事件定时器，只不过多了一个回调的功能，所以在初始化Ctimer时，用etimer_set来初始化系统启动时需要的Ctimer，然后标记初始化完成。在ctimer_process中，主要是去轮询过期的Ctimer，然后再进行回调。请注意,由于回调函数在另一个进程中,所以根据protothread的设计，需要调用 PROCESS_CONTEXT_BEGIN()和PROCESS_CONTEXT_END()来临时的开辟其它进程中的上下文，最后关闭。（可参考ctimer_process的具体实现进行分析）

##### 定时器API定义

/home/user/contiki/core/sys/ctimer.h

```
#ifndef CTIMER_H_
#define CTIMER_H_

#include "sys/etimer.h"

// 定义一个Ctimer定时器对象
struct ctimer {
  struct ctimer *next;
  struct etimer etimer;
  struct process *p;
  void (*f)(void *);
  void *ptr;
};

// 复位一个Ctimer定时器对象
void ctimer_reset(struct ctimer *c);
// 重启一个Ctimer定时器对象
void ctimer_restart(struct ctimer *c);
// 设置并启动一个Ctimer定时器对象
void ctimer_set(struct ctimer *c, clock_time_t t, void (*f)(void *), void *ptr);
// 停止一个Ctimer定时器对象
void ctimer_stop(struct ctimer *c);
// 检查一个Ctimer定时器对象是否到期
int ctimer_expired(struct ctimer *c);
// 初始化Ctimer定时器
void ctimer_init(void);

#endif /* CTIMER_H_ */

```
##### API的具体实现

位于/home/user/contiki/core/sys目录下的ctimer.c文件中。

#### rtimer

　　实时定时器，直接调用硬件平台，设定一个硬件实时定时器，触发以后调用一个定时器回调。它可以抢占任何进程，这样使得实时任务可以准确调度。

　　有两种类型的实时任务：一种是硬实时任务，一种是软实时任务，其中硬实时任务的优先级要高点。

　　rtimer与其它的timer不一样的是，它在平台这一层只是提供了三个接口：

- rtimer_init
- rtimer_set
- rtimer_run_next

　　这三个接口的实现是严重依赖于MCU的特性的。

##### 定时器API定义

/home/user/contiki/core/sys/rtimer.h

```
#ifndef RTIMER_H_
#define RTIMER_H_

#include "contiki-conf.h"

#ifndef RTIMER_CLOCK_LT
typedef unsigned short rtimer_clock_t;
#define RTIMER_CLOCK_LT(a,b)     ((signed short)((a)-(b)) < 0)
#endif /* RTIMER_CLOCK_LT */

#include "rtimer-arch.h"

void rtimer_init(void);

struct rtimer;
typedef void (* rtimer_callback_t)(struct rtimer *t, void *ptr);

// 定义一个Ctimer定时器对象
struct rtimer {
  rtimer_clock_t time;
  rtimer_callback_t func;
  void *ptr;
};

enum {
  RTIMER_OK,
  RTIMER_ERR_FULL,
  RTIMER_ERR_TIME,
  RTIMER_ERR_ALREADY_SCHEDULED,
};

// 设置并启动一个rtimer定时器对象
int rtimer_set(struct rtimer *task, rtimer_clock_t time,
           rtimer_clock_t duration, rtimer_callback_t func, void *ptr);

void rtimer_run_next(void);

// 用于获取当前的rtimer时间
#define RTIMER_NOW() rtimer_arch_now()


#define RTIMER_TIME(task) ((task)->time)

// 针对特定平台的初始化操作，被rtimer_init()函数调用
void rtimer_arch_init(void);
// 传递一个唤醒时间，在特定时刻进行调度操作，调用rtimer_run_next()
void rtimer_arch_schedule(rtimer_clock_t t);
/*rtimer_clock_t rtimer_arch_now(void);*/

// rtimer每秒的滴答数
#define RTIMER_SECOND RTIMER_ARCH_SECOND

#endif /* RTIMER_H_ */
```

##### API的具体实现

位于/home/user/contiki/core/sys目录下的rtimer.c文件中。
