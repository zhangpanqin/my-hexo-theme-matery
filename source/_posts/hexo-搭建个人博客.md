---

title: 'hexo,搭建个人博客'
top: true
cover: true
toc: true
mathjax: true
date: 2020-03-06 21:28:57
summary: hexo 搭建个人博客,nginx,oss,cdn,shell,seo
tags:
    - hexo
    - nginx
    - cdn
    - oss
    - shell
categories:
    - hexo
    - cdn
    - oss
    - nginx
    - shell

---

## 前言

2020 - 2 月底鬼使神差的给我的域名 `mflyyou.cn` 续费三年，2024 - 4 才到期，就琢磨搭建个人网站，Google 了 `hexo` 中一个自己比较喜欢的主题 `hexo-matery-modified` ,然后自己改了改其中的内容。

博客的具体效果请观摩 [张攀钦的博客](http://mflyyou.cn)

### 本文概要

- hexo 使用，及怎么去改主题的模板
- 阿里云服务器，搭建 nginx ,配置 nginx 缓存
- 百度、谷歌 seo 优化，让你的网站可以被搜索到
- 阿里 oss 作为图片服务器
- CDN 加速提高首屏渲染
- shell 脚本一键部署到 nginx 目录下，将所需静态资源上传到 oss



## Hexo 介绍

