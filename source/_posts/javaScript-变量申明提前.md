title: JavaScript 变量申明提前
date: 2016-08-22 21:42:51
category: Language
tags: Javascript
---

今天看到一个很「神奇」的 JavaScript 特性：JavaScript 函数中声明的所有变量都会被“提升（hoisting）”至函数的顶部，下面举例来说明。

下面这段代码中，`console.log()` 会输出什么的？打印出来的是`undefined`而不是`global`!

```javascript
var scope = "global";
function myFunc(){
    console.log(scope);
    var scope = "local";
}

myFunc();
```

<!--more-->

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

对于函数来说，如果采用函数声明（function declarations）的方式也会将定义提前，你可以在声明之前使用该函数：
```javascript
hoisted(); // logs "foo"

function hoisted() {
  console.log("foo");
}
```

但是，函数表达式（[function expression](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/function)）并不会被提前：
```javascript
notHoisted(); // TypeError: notHoisted is not a function

var notHoisted = function() {
   console.log("bar");
};
```
