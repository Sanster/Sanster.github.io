title: Javascript 中的原生 DOM 操作（一）
description: 查询 DOM 元素及 Attribute 相关内容
date: 2017-02-04 15:14:48
category: Language
tags: 
  - Javascript
  - DOM
---


> 整理自《JavaScript 权威指南》

## 基本概念
每一个 DOM 节点都是一个 Node 对象，该对象有一个 `nodeType` 整数字段表示属于什么类型：
* 1 - Element
* 2 - Attribute
* 3 - Text

## 查询 DOM 元素
返回单个元素的 API，如果没有查询到的话，会返回 null 对象。返回多个元素的 API，如果没有查询到对象，会返回空 NodeList/HTMLCollection 对象。

### 通过 document 全局查询元素
指定查询类型查询:
```javascript
var el = document.getElementById('id-name');
var el_NodeList = document.getElementsByName('username');
var el_HTMLCollection = document.getElementsByClassName('class-name1');
// 查询同时包含 class-name1 和 class-name2 的元素
var el_HTMLCollection = document.getElementsByClassName('class-name1 class-name2');
var el_HTMLCollection = document.getElementsByTagName('img');
```

根据 [CSS 选择器](https://www.w3.org/TR/css3-selectors/)查询:
```javascript
// 返回当前文档中第一个类名为 "class-name" 的元素
var el = document.querySelector(".class-name");

// 返回所有 class 为 class1 或 class2 的 div 元素
var el_NodeList = document.querySelectorAll("div.class1, div.class2");
```

### 根据元素查询
```javascript
// 获取父元素、父节点(区别是什么？)
var parent = el.parentElement;
var parent = el.parentNode;

// 获取子节点，子节点可以是任何一种节点，可以通过nodeType来判断
var node_HTMLCollection = el.children;

// 当前元素的第一个/最后一个子元素节点
var el = ele.firstElementChild;
var el = ele.lastElementChild;

// 下一个/上一个兄弟元素节点
var el = ele.nextElementSibling;
var el = ele.previousElementSibling;

// 查询子元素
var el_HTMLCollection = el.getElementsByTagName('tag-name');
var el_HTMLCollection = el.getElementsByClassName('class-name');
```

### NodeList 与 HTMLCollection
可以看到在上面的查询中，当查询多个元素时，有些 API 会返回 NodeList 类型的对象，而有些会返回 HTMLCollection 类型的对象。这两种对象都是**只读**的类数组对象，可以通过 `length` 获得其长度。

两者都具有实时性（**注：** querySelectorAll 返回的 NodeList 对象除外），当添加了新的元素，或有元素被修改时，都会随之改变：
```javascript
// 对一个空的 element 元素进行查询
var el_HTMLCollection = el.getElementsByTagName('div');
el_HTMLCollection; // []

var el_div = document.createElement('div')
el.appendChild(el_div)
el_HTMLCollection; // [div]
```

NodeList 和 HTMLCollection 的区别在于：HTMLCollection 对象可以通过元素的 id 直接索引元素。

## 元素属性(attribute)操作
某些特定的元素定义了部分通用属性，可以通过属性名直接索引或修改相应的值，如 `<img>` 元素对象有 src 属性：
```javascript
var image = document.getElementById("myImage");
var imgUrl = image.src
if(image.id === "myImage") {
    // ...
}
```

更一般的写法可以使用 `setAttribute` 等方法来进行属性操作：
```javascript
// 设置特定属性的值，如果属性不存在则会新建属性
el.setAttribute('class', 'highlight');

// 删除特定属性
el.removeAttribute('class');

// 获取特定属性的值
var class_string = el.getAttribute('class');

// 判断是否包含某属性
el.hasAttribute('class');

// 是否有属性
el.hasAttributes();  
```

所有 Element 类型的节点都有一个**实时、只读**的 attributes 对象，该对象可以直接用属性名索引对应的属性：
```javascript
// 获取一个数组 [{name: "", value: ""}, {}...]
var attrs_NamedNodeMap = el.attributes;
attrs_NamedNodeMap.class; // 该对象即为 Attribute 对象，也是一种 Node 对象
attrs_NamedNodeMap.class.name; // "class"
attrs_NamedNodeMap.class.value; // "class-name1 class-name2"
```

HTML5 中还有一类特殊的属性：`dataset`。该属性用来在元素上绑定一些额外信息，可以在 JS 以及 CSS 中使用，如何使用可以看：[HTML5 data attributes](http://sanster.github.io/2016/08/08/html5-data-attributes/)
