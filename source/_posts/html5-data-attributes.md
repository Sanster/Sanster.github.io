title: HTML5 data attributes
date: 2016-08-08 20:21:03
category: Frontend
tags: HTML
---

HTML5 原生提供了`data`属性来存储数据，data 属性是一个全局的属性，所有 HTML 元素都可以使用，使用的方法是以`data-`为前缀来定义元素的属性名：
```html
<article>
  id="electriccars"
  data-columns="3"
  data-index-number="12314"
  data-parent="cars">
...
</article>
```

<!--more-->

# 在 JS 中使用 data
data 中存储的数据可以在 JS 中通过元素内置的`dataset`属性获得，所获得的值均为字符串，这里要注意 `data-index-number` 这个 data，HTML 中 index 和 number 中间的`-`符号会根据「驼峰」原则转化。

```javascript
var article = document.getElementById('electriccars');

article.dataset.columns // "3"
article.dataset.indexNumber // "12314"
article.dataset.parent // "cars"
```

data 的值可以通过 dataset 直接修改：
```css
article.dataset.columns = "4"
```

# 在 CSS 中使用 data
使用 [attr()](https://developer.mozilla.org/en-US/docs/Web/CSS/attr) 函数获得 data 的值：
```css
article::before {
  content: attr(data-parent);
}
```

使用 CSS 的属性选择器[attribute selectors](https://developer.mozilla.org/en-US/docs/Web/CSS/Attribute_selectors) 选择具有相应 data 值元素：
```css
article[data-columns='3'] {
  width: 400px;
}

article[data-columns='4'] {
  width: 600px;
}
```

JSFiddle 示例：
{% jsfiddle o0cvt34n html,css,result light 100% 300px %}

参考文章： [Using_data_attributes](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Using_data_attributes)