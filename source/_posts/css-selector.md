title: CSS Selector
date: 2016-08-07 16:23:29
category: Frontend
tags: CSS
---

CSS 选择器用于选择需要添加样式的元素，可以按照三种类型来选择：HTML Tag、ID 和 Class
```css
/*使用 HTML Tag 选择元素*/
div {
	background: black;
}

/*使用 ID 选择元素*/
#myElementID {
	background: black;
}

/*使用 Class 选择元素*/
.myElementClass {
	background: black;
}
```

嵌套的元素可以用更准确的方式来选择：
```css
div div p {
	font-size: 22px;
}
```

如果要选择两个元素，可以用`,` 来分隔：
```
.myElementClass, #myElementID {
	background: red;
}
```

可以通过`>`来指定选择`Paragraph 1~3`元素，`>`表示选择 div 下的第一层级当中的 p tag：
```css
div > p {
	test-align: center;
}
```

可以通过`nth-child`来更准确地选择元素
{% jsfiddle smft39cq html,css,result dark 100% 300px %}

上面的示例中`p:nth-child(2)`表示选择所有是第二子元素的 p，`div :nth-child(1)`表示选择所有 div 的第一个元素，注意 div 后面有空格。

CSS 提供了非常灵活的选择器，更详细的可以看这里：[w3 CSS Selectors](http://www.w3school.com.cn/cssref/css_selectors.asp)

