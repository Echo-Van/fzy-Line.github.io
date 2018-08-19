---
title: Github Pages + Hexo搭建博客（五）
tags:
  - Hexo
  - Github
categories: Hexo
abbrlink: 14084
date: 2017-12-03 21:48:17
---

　　Gitment是一款基于GitHub Issues的评论系统。这篇博客介绍Hexo如何集成Gitment评论系统。

<!--more-->

　　为了博客能够支持评论，试过很多评论系统，多说挂了，网易云跟帖也挂了，最后换到来必力，但是发现评论经常显示不出来，登录评论后台还得翻墙，于是找到了现在的Gtiment。

　　对于hexo+Github搭建的博客，使用Gitment应该是最好的选择了，因为他是基于Github的Issue来做的，每篇文章的评论会创建一个Issue。

　　尽管还有类似的开源项目，比如Gittalk也可以实现同样的功能，由于我使用的是next主题，所以Gitment的默认样式可能更适合我的博客，虽然样式是可以自定义的，但是对于我这种不回前端的人来说怎么简单怎么来吧。

#### 注册OAuth Application

　　在Github点击右上角个人头像的下拉图标，选择Setting，然后在打开的页面左边点击 Developer settings，最后点击New OAuth app。然后填写相关的信息：

- Application name —— 应用名，随便填写

- Homepage URL —— 你的博客地址

- Application description —— 应用的描述，随便填写

- Authorization callback URL —— 你的博客地址

![3-1](http://ohe7ixo05.bkt.clouddn.com/2017/12/3-1.png)

　　填写信息完毕后点 Register application 就可以看到刚刚注册好的OAuth Application的信息，其中 Client ID 和 Client Secret 在后面要用到。

#### 配置Hexo和next

　　修改Next主题的评论框架布局文件`themes\next\layout\_partials\comments.swig`，打开该文件后可以看到关于多说、友言、Disqus等评论系统已经被添加到评论区布局框架上，所以我们只要在最后添加一个关于Gitment的分支即可，如下：

```
{% elseif theme.gitment.enable %}
      {% if theme.gitment.lazy %}
        <div onclick="showGitment()" id="gitment-display-button">{{  __('gitmentbutton') }}</div>
        <div id="gitment-container" style="display:none"></div>
      {% else %}
        <div id="gitment-container"></div>
      {% endif %}
```

　　Gitment评论系统的调用接口已经做好，但是还没有具体实现，所以接着我们在`themes\next\layout\_third-party\comments`增加一个文件gitment.swig，并在里面添加具体实现：

```
{% if theme.gitment.enable %}
    {% set owner = theme.gitment.owner %}
    {% set repo = theme.gitment.repo %}
    {% set cid = theme.gitment.client_id %}
    {% set cs = theme.gitment.client_secret %}
    <link rel="stylesheet" href="https://imsun.github.io/gitment/style/default.css">
    <script src="https://imsun.github.io/gitment/dist/gitment.browser.js"></script>
    {% if theme.gitment.lazy %}
        <script type="text/javascript">
            function showGitment(){
                document.getElementById("gitment-display-button").style.display = "none";
                document.getElementById("gitment-container").style.display = "block";
                var gitment = new Gitment({
                        id: window.location.pathname,
                        owner: '{{owner}}',
                        repo: '{{repo}}',
                        oauth: {
                            client_id: '{{cid}}',
                            client_secret: '{{cs}}',
                        }});
                gitment.render('gitment-container');
            }
        </script>
    {% else %}
        <script type="text/javascript">
            var gitment = new Gitment({
                    id: window.location.pathname,
                    owner: '{{owner}}',
                    repo: '{{repo}}',
                    oauth: {
                        client_id: '{{cid}}',
                        client_secret: '{{cs}}',
                    }});
            gitment.render('gitment-container');
        </script>
    {% endif %}
{% endif %}
```

　　然后在`themes\next\layout\_third-party\comments\index.swig`添加一行：

```
{% include 'gitment.swig' %}
```

　　最后，在NexT主题配置文件中配置一下Gitment，在`themes\next\_config.yml`中添加以下内容：

```
# Gitment
gitment:
    enable: true    # gitment评论系统开关
    lazy: true  # 评论懒加载开关
    owner: fzy-Line # GitHub用户名
    repo: fzyLine.github.io # 存储评论数据的GitHub仓库的仓库名
    client_id:  # 复制注册OAuth Application后得到的Client ID
    client_secret:  # 复制注册OAuth Application后得到的Client Secret
```

#### 常见错误

##### Error: Not Found

![3-2](http://ohe7ixo05.bkt.clouddn.com/2017/12/3-2.png)

　　出现这样错误的原因主要是：

- repo指定的仓库名对应的仓库在GitHub上根本不存在，应该修改为正确的仓库名，最好就是用自己博客所使用那个仓库，这样的话所有的评论创建的Issue就是博客仓库的Issue。
- repo指定的值是其仓库地址，而不是仓库名，应该修改为仓库名。

##### Error: Comments Not Initialized

![3-3](http://ohe7ixo05.bkt.clouddn.com/2017/12/3-3.png)

　　出现这样错误的原因主要是：

－　在注册OAuth Application时，Authorization callback URL填写的地址错误
－　还没有在该页面的Gitment评论区登陆GitHub账号，需点击login登录github，然后点击初始化按钮进行初始化。

##### Issues重复初始化

　　这个问题在Gitment的Github项目Issue中也有很多人提到，貌似还是个BUG，没有得到解决。所以，只有自己多多注意啦。

　　不要在初始化一篇文章后再去点浏览器的返回按钮然后再回到原来的这篇文章，这样的话，虽然创建了一个Issue，但是初始化按钮还是会存在，如果你再去点就会出现两个Issue。

#### 总结

　　当然，Gitment也有它的不足，目前它只能用Github账号登录来评论。但是，对于技术博客，特别是IT技术博客，这样也足够了，看你博客的人基本也是这个行业的，而Github又那么有名，所以基本大家都有账号。

　　由于每一篇文章都要初始化，对于之前写了很多博客的人来说，之前这些文章的初始化确实是个问题，比如写了100多篇的我，乖乖的手动为每一篇点了一下初始化。当然，也有人做了自动化初始化的脚本，大家可以试试。

　　自动初始化 Gitalk 和 Gitment 评论：
[https://draveness.me/git-comments-initialize](https://draveness.me/git-comments-initialize)


　　更详细的介绍可以在我参考的这篇博客中找到答案：

　　添加Gitment评论系统到Hexo主题NexT：
[https://extremegtr.github.io/2017/09/07/Add-Gitment-comment-system-to-hexo-theme-NexT/](https://extremegtr.github.io/2017/09/07/Add-Gitment-comment-system-to-hexo-theme-NexT/)
