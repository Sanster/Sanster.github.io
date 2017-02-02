title: Javascript 模块加载规范
date: 2017-01-31 21:43:45
category: Language
tags:
    - Javascript
---

简单整理下现有的模块加载规范及相应的实现库，以后要用的话再细看具体的用法。目前主流的 Javascript 模块加载规范有 CommonJS， AMD 和 CMD。

## CommonJS
Nodejs 采用的模块加载规范，使用同步加载的方式加载依赖文件，主要用于服务器端，虽然也可以用在游览器中，但是如果依赖文件较大，或者网络速度较慢，就会阻塞网页的加载，影响用户体验。关键词：`require()`，`exports.`。

## AMD(Asynchronous Module Definition)
采用异步方式加载依赖文件，比较流行的模块加载器：[Require.js](http://requirejs.org/) ，不仅适用于游览器端，还适用于服务器端。

AMD 加载依赖：
```
require(['module1','module2'], function(module1,module2) {
  ...
});
```

AMD 定义模块：
```javascript
define(moduleName, ['module1','module2'], function(module1,module2) {
  ...
});
```

## CMD(Common Module Definition)
基于该标准的模块加载器：[Sea.js](http://seajs.org/docs/)，好像是国人开发的，中文文档比较全，能够支持服务器端和游览器端，还同时支持同步和异步加载。

CMD 加载依赖：
```
define(function(require, exports) {
  // 获取模块 a 的接口
  var a = require('./a');
  // 调用模块 a 的方法
  a.doSomething();

  // 异步加载
  require.async('math', function(math) {
    math.add(1, 2);
  });
});
```

CMD 定义模块：
```
define(function(require, exports) {
  // 对外提供 foo 属性
  exports.foo = 'bar';

  // 对外提供 doSomething 方法
  exports.doSomething = function() {};
});
```

## UMD(Universal Module Definition)
使用 UMD 可以让模块兼容 AMD 规范、 CommonJS 规范，同还能支持的「全局」变量规范，UMD 规范其实只是一种写法，根据 AMD、CommonJS 规范的特点来判断当前的环境，不需要使用额外的库。
在 UMD 的 [GitHub](https://github.com/umdjs/umd) 仓库中提供了各种 [templates](https://github.com/umdjs/umd/tree/master/templates)，可以根据你的兼容性需求来选择参考的模板，下面的代码是 [returnExports](https://github.com/umdjs/umd/blob/master/templates/returnExports.js) 模板中的例子，还是比较容易看懂的：
```
(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['b'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        module.exports = factory(require('b'));
    } else {
        // Browser globals (root is window)
        root.returnExports = factory(root.b);
    }
}(this, function (b) {
    //use b in some fashion.

    // Just return a value to define the module export.
    // This example returns an object, but the module
    // can return a function as the exported value.
    return {};
}));
```

相关链接:
- AMD 官方文档：[amdjs-api](https://github.com/amdjs/amdjs-api/wiki/AMD)
- CMD 标准文档：[中文](https://github.com/seajs/seajs/issues/242)，[English](https://github.com/cmdjs/specification/blob/master/draft/module.md)
- UMD 官方文档：https://github.com/umdjs/umd
- [Sea.js 与 Require.js 的异同](https://github.com/seajs/seajs/issues/277)
- [AMD 与 CMD 的区别](https://www.zhihu.com/question/20351507)