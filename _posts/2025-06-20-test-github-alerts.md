---
title: 测试 GitHub 风格警告块
date: 2025-6-20 20:31:29 +0800
categories: [测试]
tags: [markdown, 样式]
description: Github alerts 测试
pin: true
math: true
mermaid: true
image:
  path: /assets/images/Manim.png
---

正常文本内容。

>[!note]
>这是一个注释提示框。

>[!tip]
>这是一个提示框。

>[!important]
>这是一个重要信息框。

>[!warning]
>这是一个警告框。

>[!caution]
>这是一个危险操作提示框。
>更多普通文本。
>



之后会结束吗




# 时间线(假的)
{% timeline title: "我的编程历程" %}
- date: "1995年"
  title: "开始编程"
  description: "学习我的第一门编程语言 BASIC"
- date: "2000年"
  title: "大学时期"
  description: "主修计算机科学，深入学习 Java 和 C++"
  image: "/assets/images/university.jpg"
- date: "2005年"
  title: "职业生涯开始"
  description: "在一家初创公司担任软件工程师"
- date: "2010年"
  title: "转向 Web 开发"
  description: "学习 JavaScript 和前端框架"
  image: "/assets/images/webdev.jpg"
- date: "2020年"
  title: "博客之旅"
  description: "开始使用 Jekyll 写技术博客，分享经验"
  {% endtimeline %}


## 8. 数学公式支持

### 如何使用

在 Markdown 中使用以下语法：

```markdown
行内公式：{% math %}E = mc^2{% endmath %}

显示公式：
{% math display %}
\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
{% endmath %}

