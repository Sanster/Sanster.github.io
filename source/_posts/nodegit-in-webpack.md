title: nodegit 与 webpack
date: 2016-11-12 20:51:31
category: Frontend
tags:
  - webpack
  - nodegit
---

nodegit 在与 webpack 一起使用时，如果不做任何配置，会报以下错误，导致打包失败。

<!--more-->

```
WARNING in ../~/nodegit/build/Release/nodegit.node
Module parse failed: /Users/cwq/Github/static-git/node_modules/nodegit/build/Release/nodegit.node Unexpected character '�' (1:0)
You may need an appropriate loader to handle this file type.
(Source code omitted for this binary file)
 @ ../~/nodegit/dist/nodegit.js 11:11-51
 @ ../app/plugins/git/index.js
 @ ../app/src/main.js

WARNING in ../~/promisify-node/index.js
107:14 Critical dependency: the request of a dependency is an expression

ERROR in ../~/nodegit/package.json
Module parse failed: /Users/cwq/Github/static-git/node_modules/nodegit/package.json Unexpected token (2:9)
You may need an appropriate loader to handle this file type.
| {
|   "_args": [
|     [
|       {
 @ ../~/nodegit/dist/nodegit.js 945:18-39
 @ ../app/plugins/git/index.js
 @ ../app/src/main.js
```

解决的办法是，在 webpack 的配置当中添加 [externals](https://webpack.github.io/docs/configuration.html#externals) 属性，这个属性用来告诉 webpack 那些 package 不需要打包：
```
externals: [
  function(context, request, callback) {
    if(/^nodegit/.test(request))
      return callback(null, 'commonjs' + " " + request);
    callback();
  },
]
```

这样配置以后就可以在 webpack 要处理的 js 代码中继续使用 `require('nodegit')`，webpack 会使用 commonjs 方式加载 nodegit，并且不会去打包 nodegit。

> "webpack": "^2.1.0-beta.25
> "nodegit": "^0.16.0"