title: ES6 中的 TDZ（temporal dead zone）及函数作用域
date: 2017-01-21 10:12:22
category: Language
tags:
  - Javascript
  - ES6
---

这两天看到阮一峰的一条[微博](http://weibo.com/1400854834/ErH6VjDgg?filter=hot&root_comment_id=0&type=comment#_rnd1485003692310)， 阮大说下面这段代码会报错，认为是 V8 的 bug：

```javascript
var x = 1

function foo (x = x) {
    console.log(x)
}

foo()
```

评论里有人提到这是「最基本」的 TDZ，之前完全没听过这个词，赶紧学习一下。

<!--more-->

# TDZ(Temporal dead zone)
上面的代码如果在最新的 Chrome 中运行，会报 `Uncaught ReferenceError: x is not defined` 的错误，要搞明白为什么会有这个错误，首先要了解 TDZ（temporal dead zone)，看下面一段代码：

```javascript
function do_something() { // TDZ 开始
  console.log(foo); // ReferenceError
  let foo = 2; // TDZ 结束
  // let foo; // 这里同样也是 TDZ 的结束，foo 为 `undefined`
}
```

在 let 变量 foo 初始化前使用它的话，就会报 `ReferenceError` 错误，所谓的 temporal dead zone 就是指

{% cq %} 从 let/const 变量作用域开始，到其真正被初始化之间的这段区域。{% endcq %}

这里的变量作用域包括函数作用域，块级作用域以及下面会提到的**参数作用域**。

其实换一个角度看，之所以会有 TDZ 是因为「用 let/const 声明的变量，不再会被[hoisting](https://developer.mozilla.org/en-US/docs/Glossary/Hoisting) 了」。

# Parameters environment(scope)
在 ES6 中还多出了「参数作用域」这个概念，当**函数参数有默认值**时，就会存在参数作用域：

```javascript
var x = 1;

function foo(x, y = function() { x = 2; }) {
  var x = 3;
  // 调用 y 函数，函数中对 x 赋值的操作是在函数作用域中进行的
  // 并没有在函数体中定义的 `var x` 的值
  // 在参数作用域中看不到函数作用域中的值
  y();
  console.log(x); // 输出 3
}

foo();

// 在函数体外定义的 x 值也未改变
console.log(x); // 1
```

参数作用域中的变量相当于是用 let 从左到右按顺序声明的，所以在参数作用域中同样也会有 TDZ 的情况：

```javascript
// 在 y 初始化之前使用 y，处于 TDZ 区域
function bar(x=y, y=2) {
    return [x, y];
}
bar(); // ReferenceError
```

# 代码解释
现在就能解释阮大发的那段代码为什么会报错了：

```javascript
var x = 1

function foo (x = x) {
    ...
}
```

这里的 foo 函数有默认参数值，所以有参数作用域，而在这个作用域中 x 还没有被初始化，所以 `x = x` 处于 TDZ，所以就报了 `ReferenceError`。

# 更多关于 TDZ 的内容

TDZ 的区域并不是真正位置上的区域，而是和代码的调用顺序有关，下面的代码中 `func` 中的 myVar 就不会包报错：

```javascript
if (true) { // 进入块级作用域, TDZ 开始
    const func = function () {
        console.log(myVar); // OK!
    };

    // 这里的区域就是 TDS
    // 使用 myVar 的话会引起 `ReferenceError`

    let myVar = 3; // TDZ 结束
    func(); // 在 TDZ 区域外调用 func 函数
}
```

`typeof` 一个没有声明的变量名，返回的是 `undefined`，而在 TDZ 中使用 typeof 也会报 ReferenceError：

```javascript
if (true) {
    console.log(typeof foo); // ReferenceError (TDZ)
    console.log(typeof aVariableThatDoesntExist); // 'undefined'
    let foo;
}
```

参考链接：
* http://exploringjs.com/es6/ch_variables.html#_the-temporal-dead-zone
* http://dmitrysoshnikov.com/ecmascript/es6-notes-default-values-of-parameters/#tdz-temporal-dead-zone-for-parameters
* https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Statements/let#Temporal_dead_zone_and_errors_with_let
* http://code.wileam.com/default-value-n-params-env/