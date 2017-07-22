---
title: 树莓派自动发送ip到指定邮箱
date: 2016-05-26 10:51:23
tags: ［树莓派,ip］
categories: 树莓派
---

　　知道树莓派的ip地址才能通过SSH或者VNC在你的电脑上操作树莓派，树莓派开机自动发送ip地址到指定邮箱会让你使用树莓派更加方便！

<!--more-->

#### 新建一个python脚本文件


输入命令

```
touch send_ip.py
```

#### 编写python脚本


（1）输入命令

```
sudo vim send_ip.py
```

（2）写入以下代码

```
#!\usr\bin\env python
#-*-coding: utf-8-*-
import socket
import time
import smtplib
import urllib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage

#发送邮件的基本函数，参数依次如下
# smtp服务器地址、邮箱用户名，邮箱秘密，发件人地址，手贱儿女地址（列表的方式），邮件主题，邮件html内容
def sendEmail(smtpserver,username,password,sender,receiver,subject,msghtml):
        msgRoot =MIMEMultipart('reklated')
        msgRoot['To']=','.join(receiver)
        msgRoot['Subject']= subject
        msgText = MIMEText(msghtml,'html','utf-8')
        msgRoot.attach(msgText)
        smtp = smtplib.SMTP()
        smtp.connect(smtpserver,"25")
        smtp.login(username,password)
        print "YES"
        smtp.quit()
#检查网络连通性
def check_network():
        while True:
            try:
                result=urllib.urlopen('http://baidu.com').read()
                print result
                print "Network is Ready!"
                break
          except Exception , e:
                print e
                print "Network is not ready,Sleep 5s..."
                time.sleep(5)
        return True

#获取本级制定接口的ip地址
def get_ip_address():
        s =socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
        s.connect(("1.1.1.1",80))
        ipaddr=s.getsockname()[0]
        s.close()
        return ipaddr

if  __name__ == '__main__' :
        check_network()
        ipaddr= get_ip_address()
        sendEmail("smtp.sohu.com",'你的邮箱帐号','你的邮箱密码','发件人地址',['收件人地址'],'IP Address of Raspberry PI',ipaddr)
```

（3）保存退出

vim编辑器下保存退出步骤为：

按esc然后输入：，然后看到冒号显示出来再输入wq，回车即可

#### 设置开机自动执行该脚本


在/etc/rc.local文件里加入下面这一行：

```
/usr/bin/python/home/pi/send_ip.py
```

输入命令：

```
sudo vim /etc/rc.local
```

在文件中添加/usr/bin/python/home/pi/send_ip.py然后保存退出

特别提示：收到的邮件有可能在垃圾箱里，不要以为是脚本的问题，其实是邮箱的问题，请注意查看！另外，有的邮箱不支持smtp，所以无法使用。搜狐和网易的邮箱亲测可用。


