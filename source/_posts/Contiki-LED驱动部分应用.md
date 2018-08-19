---
title: Contiki LED驱动部分应用
tags: '［IoT,Contiki,LED］'
categories:
  - IoT
  - Contiki
abbrlink: 23863
date: 2017-02-23 21:34:14
---


　　Contiki为用户提供了控制LED的接口，在各个平台下也给出了对应的函数，但是由于牵扯到多个文件，这对于初学者来说也是很麻烦的事情，这篇博客将一步步解析Contiki LED控制的实现机制。

<!--more-->

#### LED API函数

由于contiki需要适应多种平台，所以contiki提供了底层控制LED的三大接口，分别是：

```

void leds_arch_init(void)  //LED初始化函数
unsigned char leds_arch_get(void)  //LED状态获取函数
void leds_arch_set(unsigned char leds)  //LED状态设置函数

```

为方便各个平台对于LED的控制，在各个平台下又提供了详细的控制API接口，分别是：

```

void leds_init(void);  //LED初始化
void leds_blink(void);  //所有LED闪烁
unsigned char leds_get(void);  //获取LED的状态
void leds_set(unsigned char leds);  //设置LED的状态
void leds_on(unsigned char leds);  //LED打开
void leds_off(unsigned char leds);  //LED关闭
void leds_toggle(unsigned char leds);  //LED状态切换，反转

```

#### LED驱动文件

##### leds.c

打开位于/home/user/contiki/core目录的leds.c文件

```
#include "dev/leds.h"
#include "sys/clock.h"
#include "sys/energest.h"

static unsigned char leds;
/*---------------------------------------------------------------------------*/
static void
show_leds(unsigned char new_leds)
{
  unsigned char changed;
  changed = leds ^ new_leds;
  leds = new_leds;

  if(changed & LEDS_GREEN) {
    /* Green did change */
    if(leds & LEDS_GREEN) {
      ENERGEST_ON(ENERGEST_TYPE_LED_GREEN);  //方便跟踪节能设计了energest模块
    } else {
      ENERGEST_OFF(ENERGEST_TYPE_LED_GREEN);
    }
  }
  if(changed & LEDS_YELLOW) {
    if(leds & LEDS_YELLOW) {
      ENERGEST_ON(ENERGEST_TYPE_LED_YELLOW);
    } else {
      ENERGEST_OFF(ENERGEST_TYPE_LED_YELLOW);
    }
  }
  if(changed & LEDS_RED) {
    if(leds & LEDS_RED) {
      ENERGEST_ON(ENERGEST_TYPE_LED_RED);
    } else {
      ENERGEST_OFF(ENERGEST_TYPE_LED_RED);
    }
  }
  leds_arch_set(leds);
}
/*---------------------------------------------------------------------------*/
void
leds_init(void)
{
  leds_arch_init();
  leds = 0;
}
/*---------------------------------------------------------------------------*/
void
leds_blink(void)
{
  /* Blink all leds that were initially off. */
  unsigned char blink;
  blink = ~leds;
  leds_toggle(blink);

  clock_delay(400);

  leds_toggle(blink);
}
/*---------------------------------------------------------------------------*/
unsigned char
leds_get(void) {
  return leds_arch_get();
}
/*---------------------------------------------------------------------------*/
void
leds_set(unsigned char ledv)
{
  show_leds(ledv);
}
/*---------------------------------------------------------------------------*/
void
leds_on(unsigned char ledv)
{
  show_leds(leds | ledv);
}
/*---------------------------------------------------------------------------*/
void
leds_off(unsigned char ledv)
{
  show_leds(leds & ~ledv);
}
/*---------------------------------------------------------------------------*/
void
leds_toggle(unsigned char ledv)
{
  show_leds(leds ^ ledv);
}
/*---------------------------------------------------------------------------*/
```

##### leds.h

打开位于/home/user/contiki/core目录的leds.h文件

```
#ifndef LEDS_H_
#define LEDS_H_

/* Allow platform to override LED numbering */
#include "contiki-conf.h"

void leds_init(void);

/**
 * Blink all LEDs.
 */
void leds_blink(void);

#ifndef LEDS_GREEN
#define LEDS_GREEN  1
#endif /* LEDS_GREEN */
#ifndef LEDS_YELLOW
#define LEDS_YELLOW  2
#endif /* LEDS_YELLOW */
#ifndef LEDS_RED
#define LEDS_RED  4
#endif /* LEDS_RED */
#ifndef LEDS_BLUE
#define LEDS_BLUE  LEDS_YELLOW
#endif /* LEDS_BLUE */

#ifdef LEDS_CONF_ALL
#define LEDS_ALL    LEDS_CONF_ALL
#else /* LEDS_CONF_ALL */
#define LEDS_ALL    7
#endif /* LEDS_CONF_ALL */

/**
 * Returns the current status of all leds
 */
unsigned char leds_get(void);
void leds_set(unsigned char leds);
void leds_on(unsigned char leds);
void leds_off(unsigned char leds);
void leds_toggle(unsigned char leds);

/**
 * Leds implementation
 */
void leds_arch_init(void);
unsigned char leds_arch_get(void);
void leds_arch_set(unsigned char leds);

#endif /* LEDS_H_ */

```

##### leds-arch.c文件

打开/home/contiki/platform/cc2538dk/dev目录下的leds-arch.c

```
#include "contiki.h"
#include "reg.h"
#include "dev/leds.h"
#include "dev/gpio.h"

#define LEDS_GPIO_PIN_MASK LEDS_ALL
/*---------------------------------------------------------------------------*/
void
leds_arch_init(void)
{
  /* 这里解释下：LED控制使用的是PC0~PC7端口，一共有7个引脚，LEDS_GPIO_PIN_MASK被定义为LEDS_ALL，
   * 而在leds.h里面LEDS_ALL被定义为7，二进制展开即为111，低三位赋值为1，即这三个引脚被配置为输出通道。
   * 在leds.h中定义了三种颜色的LED，分别对应低三位，即每个引脚对应一盏LED灯，当然，这得看你的开发板的具体连线。
   */
  GPIO_SET_OUTPUT(GPIO_C_BASE, LEDS_GPIO_PIN_MASK);
}
/*---------------------------------------------------------------------------*/
unsigned char
leds_arch_get(void)
{
  //同上
  return GPIO_READ_PIN(GPIO_C_BASE, LEDS_GPIO_PIN_MASK);
}
/*---------------------------------------------------------------------------*/
void
leds_arch_set(unsigned char leds)
{
  //同上
  GPIO_WRITE_PIN(GPIO_C_BASE, LEDS_GPIO_PIN_MASK, leds);
}
/*---------------------------------------------------------------------------*/

```

##### 调用过程分析

我们来理清一下调用函数的过程，例如：

在PROCESS_THREAD中调用leds_on()：

```
void
leds_on(unsigned char ledv)
{
  show_leds(leds | ledv);
}
```

调用show_leds()：

```
static void
show_leds(unsigned char new_leds)
{
  unsigned char changed;
  changed = leds ^ new_leds;
  leds = new_leds;

  //方便跟踪节能设计了energest模块
  if(changed & LEDS_GREEN) {
    /* Green did change */
    if(leds & LEDS_GREEN) {
      ENERGEST_ON(ENERGEST_TYPE_LED_GREEN);
    } else {
      ENERGEST_OFF(ENERGEST_TYPE_LED_GREEN);
    }
  }
  if(changed & LEDS_YELLOW) {
    if(leds & LEDS_YELLOW) {
      ENERGEST_ON(ENERGEST_TYPE_LED_YELLOW);
    } else {
      ENERGEST_OFF(ENERGEST_TYPE_LED_YELLOW);
    }
  }
  if(changed & LEDS_RED) {
    if(leds & LEDS_RED) {
      ENERGEST_ON(ENERGEST_TYPE_LED_RED);
    } else {
      ENERGEST_OFF(ENERGEST_TYPE_LED_RED);
    }
  }
  //设置LED端口输出电平
  leds_arch_set(leds);
}
```

调用leds_arch_set()：

```
void
leds_arch_set(unsigned char leds)
{
  // 若leds为1，输出高电平，leds为0，输出低电平
  GPIO_WRITE_PIN(GPIO_C_BASE, LEDS_GPIO_PIN_MASK, leds);
}
```

到此，完成了LED端口的电平输出。

#### 示例程序

在/home/user/contiki/platform/cc2538dk目录下的main函数部分有如下一行代码：

```
leds_init();
```

即系统一启动就进行了初始化。

下面，我们定义一个进程，该进程实现LED闪烁，间隔时间为1s。在这个任务中还涉及contiki任务的基本结构，etimer的使用。具体代码如下：

在 /home/user/contiki/cc2538dk/leds_blink 目录下进行以下操作：

##### leds_blink.c

```
#include "contiki.h"  
#include "dev/leds.h"  
/*---------------------------------------------------------------------------*/  
PROCESS(blink_process, "Blink");  
AUTOSTART_PROCESSES(&blink_process);  
/*---------------------------------------------------------------------------*/  
PROCESS_THREAD(blink_process, ev, data)  
{  
  static struct etimer et_led_blink;

  PROCESS_BEGIN();

  while(1) {
    etimer_set(&et_led_blink, CLOCK_SECOND);     // etimer溢出周期为1s  
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et_led_blink));  
    leds_on(1);                                 // 打开LED1  
    etimer_set(&et_led_blink, CLOCK_SECOND);  
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et_led_blink));  
    leds_off(1);  
  }  

  PROCESS_END();  
}  
```



##### Makefile

```
CONTIKI_PROJECT = led_blink

all: $(CONTIKI_PROJECT)

CONTIKI = ../../..
CONTIKI_WITH_RIME = 1
include $(CONTIKI)/Makefile.include
```

##### Makefile.target

```
TARGET = cc2538dk
```

##### 编译程序

```
$ make TARGET=cc2538dk
```
##### 烧录程序

得到bin和hex文件，将其复制到Windows使用TI Flash Programmer2 将其烧录到cc2538dk开发板上即可看到灯的亮灭情况。
