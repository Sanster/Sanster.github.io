title: Nodejs 中读取超大 JSON 文件
date: 2017-01-07 09:37:06
category: Backend
tags: Nodejs
---

Node 中可以使用 require 函数直接加载 json 文件，node 会把文件的内容解析为一个 javascript 对象,以 data.json 文件为例：

```json
{
    "users": [
        "user1",
        "user2",
        "user3"
    ],
    "server": "localhost",
    "port": 1234,
    "timeout": 10
}
```

加载并打印文件的内容：
```javascript
var data = require('./data.json')
console.log(data)
//{ users: [ 'user1', 'user2', 'user3' ],
//  server: 'localhost',
//  port: 1234,
//  timeout: 10 }
```

对于超大的 json 文件，直接 require 的话会占用很多内存，而且 require 是一个"同步加载"（synchronous）的过程，所以还会很慢。

<!--more-->

我们可以采用 [JSONStream](https://github.com/dominictarr/JSONStream) 这个库来读取超大的 json 文件，就当上面的 data.json 是一个超大的 json 文件，我们用 JSONStream 把 data.json 文件的内容打印出来：

```javascript
var JSONStream = require('JSONStream')
var es = require('event-stream')
var fs = require('fs')

var stream = fs.createReadStream('data.json', {encoding: 'utf8'})
var parser = JSONStream.parse('*')

stream.pipe(parser)
    .pipe(es.mapSync( data => {
        console.log('-------------------')
        console.log(data)
    }))

// -------------------
// [ 'user1', 'user2', 'user3' ]
// -------------------
// localhost
// -------------------
// 1234
// -------------------
// 10
```

可以看到打印出来的仅是 value，key 并没有打出来，如果要获得 key 的话可以这样写：

```javascript
var parser = JSONStream.parse([{emitKey: true}])

stream.pipe(parser)
    .pipe(es.mapSync( data => {
        console.log('-------------------')
        console.log('key:', data.key)
        console.log('value:', data.value)
    }))

// -------------------
// key: users
// value: [ 'user1', 'user2', 'user3' ]
// -------------------
// key: server
// value: localhost
// -------------------
// key: port
// value: 1234
// -------------------
// key: timeout
// value: 10
```

`JSONStream.parse('*')` 中可以填写自定义的路径，用于选择需要的数据内容，匹配的格式可以参考：[JSONPath](http://goessner.net/articles/JsonPath/)，我实际用的时候就用了通配号`*`，处理了一个 160MB 的 json 文件。

虽然用这个库处理大 json 文件不会占用大内存，但貌似解析的过程比较慢，可以参考这个 SOF 的答案：http://stackoverflow.com/a/36591002/2002510

参考链接：
* http://stackoverflow.com/questions/11874096/parse-large-json-file-in-nodejs