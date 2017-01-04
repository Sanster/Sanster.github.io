title: HTML 中的块级元素和行内元素
date: 2016-11-15 22:17:56
category: Frontend
tags:
    - HTML
    - CSS
---

# 块级(block)元素

CSS 属性：display:block

默认情况下，块级元素会占据父级容器的全部宽度，并且会新起一行，块级元素中可以包含其他块级元素或者行内元素。
宽度(width)、高度(height)、内边距(padding)和外边距(margin)都可控制;

<!--more-->

# 行内(inline)元素

行内元素不会另起一行，一个行内元素只占据它对应标签（如 span, a）的 box 所包含的空间，多个相邻的行内元素会排列在同一行里，直到一行排列不下，才会换行，宽度随元素内容变化。
[MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Inline_elements)上建议行内元素应该**只包含数据或者其他行内元素**。如果行内元素包含了块级元素，那下一个行内元素会新起一行。

CSS 属性：display:inline
> 竖直方向的 padding-top, padding-bottom, margin-top, margin-bottom 不会产生边距效果，不会对元素的位置产生影响

CSS 属性：display:inline-block
> 显示为行内块元素，表现为同行显示并可修改宽高内外边距等属性

# 常用块级元素
```
<ul>/<ol>：列表
<header>/<footer>：区段头或页头/区段尾或页尾
<h1...h6>：标题
<div>：文档分区
<section>：一个页面区段
<table>：表格
<form>：表单
<output>：表单输出
<canvas>：绘制图形
<video>/<audio>：视频/音频
<p>：行
<hr>：水平分割线
<pre>：预格式化文本
```

# 常用行内元素
```
<b>,<strong>,<small>,<em>
<code>
<i>
<a>
<img>
<span>
<button>
<input>
<label>
<select>
<textarea>
<br>
```