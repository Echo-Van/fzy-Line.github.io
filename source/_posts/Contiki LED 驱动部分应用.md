---
title: Contiki LED 驱动部分应用
tags:
  - IoT
  - Contiki
categories:
  - IoT
  - OS
abbrlink: 23863
date: 2017-02-23 21:34:14
---


　　Contiki 为用户提供了控制 LED 的接口，在各个平台下也给出了对应的函数，但是由于牵扯到多个文件，这对于初学者来说也是很麻烦的事情，这篇博客将一步步解析 Contiki LED 控制的实现机制。

<!--more-->

#### LED API 函数

　　由于 Contiki 需要适应多种平台，所以 Contiki 提供了底层控制LED的三大接口，分别是：

```c

void leds_arch_init(void)  //LED初始化函数
unsigned char leds_arch_get(void)  //LED状态获取函数
void leds_arch_set(unsigned char leds)  //LED状态设置函数

```

　　为方便各个平台对于 LED 的控制，在各个平台下又提供了详细的控制 API 接口，分别是：

```c

void leds_init(void);  //LED初始化
void leds_blink(void);  //所有LED闪烁
unsigned char leds_get(void);  //获取LED的状态
void leds_set(unsigned char leds);  //设置LED的状态
void leds_on(unsigned char leds);  //LED打开
void leds_off(unsigned char leds);  //LED关闭
void leds_toggle(unsigned char leds);  //LED状态切换，反转

```

#### LED 驱动文件

##### leds.c 文件

　　打开位于 /home/user/contiki/core 目录的 leds.c 文件。

```c
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

##### leds.h 文件

　　打开位于 /home/user/contiki/core 目录的 leds.h 文件。

```c
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

##### leds-arch.c 文件

　　打开 /home/contiki/platform/cc2538dk/dev 目录下的 leds-arch.c 。

```c
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

　　在 PROCESS_THREAD 中调用 leds_on()：

```c
void
leds_on(unsigned char ledv)
{
  show_leds(leds | ledv);
}
```

　　调用 show_leds()：

```c
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

　　调用 leds_arch_set()：

```c
void
leds_arch_set(unsigned char leds)
{
  // 若leds为1，输出高电平，leds为0，输出低电平
  GPIO_WRITE_PIN(GPIO_C_BASE, LEDS_GPIO_PIN_MASK, leds);
}
```

　　到此，完成了 LED 端口的电平输出。

#### 示例程序

　　在 /home/user/contiki/platform/cc2538dk 目录下的 main 函数部分有如下一行代码：

```c
leds_init();
```

　　即系统一启动就进行了初始化。下面，我们定义一个进程，该进程实现 LED 闪烁，间隔时间为 1s。在这个任务中还涉及 contiki 任务的基本结构，etimer 的使用。具体代码如下：

　　在 /home/user/contiki/cc2538dk/leds_blink 目录下进行以下操作：

##### leds_blink.c 文件

```c
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

##### Makefile 文件

```makefile
CONTIKI_PROJECT = led_blink

all: $(CONTIKI_PROJECT)

CONTIKI = ../../..
CONTIKI_WITH_RIME = 1
include $(CONTIKI)/Makefile.include
```

##### Makefile.target 文件

```
TARGET = cc2538dk
```

##### 编译程序

```shell
$ make TARGET=cc2538dk
```
##### 烧录程序

　　得到 bin 和 hex 文件，将其复制到 Windows 使用 TI Flash Programmer2 将其烧录到 cc2538dk 开发板上即可看到灯的亮灭情况。
