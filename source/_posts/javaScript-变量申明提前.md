title: JavaScript 变量申明提前
date: 2016-08-22 21:42:51
category: Language
tags: Javascript
---

今天看到一个很「神奇」的 JavaScript 特性：JavaScript 函数中声明的所有变量（但不涉及赋值）都会被“提前”至函数的顶部，下面举例来说明。

下面这段代码中，`console.log()` 会输出什么的？打印出来的是`undefined`而不是`global`!

```javascript
var scope = "global";
function myFunc(){
    console.log(scope);
    var scope = "local";
}

myFunc();
```

局部变量 scope 的声明被提前至函数顶部，所以上面这段代码「翻译」过来和下面这段代码效果是一样的：

```javascript
var scope = "global";
function myFunc(){
    var scope;
    console.log(scope);
    scope = "local";
}

myFunc();
```