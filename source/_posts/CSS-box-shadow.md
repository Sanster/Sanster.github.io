title: CSS-box-shadow
date: 2016-08-10 21:05:39
category: CSS
tags:
---

css 的 box-shadow 参数可以为元素添加一个或多个阴影，例如按钮、卡片区域等，其参数如下：
```css
box-shadow: h-shadow v-shadow blur spread color inset;
```

* h-shadow：阴影水平偏移量，如果是正数，则阴影在对象右侧，如果是负数，则阴影在对象左侧。
* v-shadow：阴影垂直偏移量，如果是正数，则阴影在对象底部，如果是负数，则阴影在对象顶部。
* blur：可选值，模糊距离。
* spread：可选值，阴影尺寸。
* color：可选值，阴影颜色。
* inset：可选值，将外部阴影 (outset) 改为内部阴影。

可以在这里体验下不同参数的阴影效果：http://www.w3school.com.cn/tiy/c.asp?f=css_box-shadow&p=7

[这篇 Blog](http://blog.csdn.net/freshlover/article/details/7610269) 对于 box-shadow 的用法讲得很清楚，下面是根据这篇 Blog 写的 JSFiddle 的例子：
{% jsfiddle 12qmgnhw html,css,result dark 100% 300px %}

这里要注意 box-6 和 box-10，box-6 想要实现的效果是实现单边的阴影，但是可以看出 box-6 的顶部和底部还有一点红色的效果，这是因为 box 底部的阴影是四边都有的，h-shadow 的值只是将阴影向左移动了 10px 而已，上下还是可能溢出。溢出部分是红色的原因是红色的阴影处于最上层。

要清除溢出的部分，最简单的方法是设置 `spread` 参数为负数，减小阴影的尺寸，即 box-10 的效果
```css
.box-shadow-10{
	box-shadow:-10px 0 10px -4px red, /*左边阴影*/
	10px 0 10px -4px yellow, /*右边阴影*/
	0 -10px 10px -4px blue, /*顶部阴影*/
	0 10px 10px -4px green; /*底边阴影*/
}
```

更详细的关于实现单边阴影的讨论可见这个[SOF Question](http://stackoverflow.com/questions/5460129/drop-shadow-only-bottom-css3/24698566#24698566)。

参考链接：
* http://www.w3school.com.cn/cssref/pr_box-shadow.asp