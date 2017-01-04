title: javascript 中的 IIFEs
date: 2017-01-02 09:13:53
category: Language
tags: Javascript
---

IIFEs 的全称为 Immediately Invoked Function Expressions（立即执行函数表达式），在 js 的代码里经常可以看到，主要作用有两个：
* 让函数在定义的时候就马上执行
* 提供一个变量作用域，在 IIFE 中声明的变量不会对 IIFE 外的代码产生影响

普通的函数在声明了以后，需要调用一次才回执行，例如：

```javascript
function foo() {
    console.log("Hello!")
}

foo();
// Hello!
```

以上代码的 IIFE 写法如下：

```javascript
(function IIFE() {
    console.log("Hello!")
})();
// Hello!
```

<!--more-->

可以看到，IIFE 函数被包裹在 `( .. )` 中，这是 javascript 的语法，括号中的内容被认为是一个 [function expression](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/function)，表达式结尾的 `();` 就是用来执行函数表达式的内容。

> 上面的 IIFE 也可以将括号的位置换一下，等价于以下写法：
 ```javascript
 (function IIFE() {
     console.log("Hello!")
 }());
 ```

如果把括号去掉写成这种形式就会报错：
```javascript
function IIFE() {
    console.log("Hello!")
}();
// Uncaught SyntaxError: Unexpected token )
```

这种写法相当于先使用了 [function declaration](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function) 定义一个函数，然后再执行一个空的表达式，相当于如下代码，第一行与第二行没有任何关系：
```javascript
function IIFE() { console.log("Hello!") }
();
```

如果按照以下这种写法可以看出 IIFE 和非 IIFE 写法其实是很相似的：

```javascript
function foo() { .. }

// `foo` function reference expression,
// then `()` executes it
foo();

// `IIFE` function expression,
// then `()` executes it
(function IIFE(){ .. })();
```

IIFE 本身是一个函数，所以它会提供变量用域，定义在 IIFE 中的变量不会影响函数外的变量：

```javascript
var a = 42;

(function IIFE(){
    var a = 10;
    console.log( a );   // 10
})();

console.log( a );       // 42
```


原文链接：
* [You Don't know JS-IIFE](https://github.com/getify/You-Dont-Know-JS/blob/master/up%20%26%20going/ch2.md#immediately-invoked-function-expressions-iifes)
* [Immediately-Invoked Function Expression (IIFE)](http://benalman.com/news/2010/11/immediately-invoked-function-expression/#iife)
