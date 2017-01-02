title: 在 Electron-v1.4.3 中使用 nodegit
date: 2016-10-16 13:12:31
category: Frontend
tags:
  - electron
  - nodegit
---

[Nodegit](https://github.com/nodegit/nodegit) 是 [libgit2](https://libgit2.github.com/) 的 Nodejs 客户端，同时也支持 [Electron](https://github.com/electron/electron),官方的教程说在 `package.json` 里面指定 engines 就能使用：

```
{
  "name": "elec-app",
  "displayName": "My Electron app",
  "version": "0.0.1",
  "description": "",
  "main": "main.js",
  "author": "",
  "engines": {
    "electron": "0.20.7"
  }
}
```

Electron 最新版本是 1.4.3，想用最新版本试下 electron 集成 nodegit，但是一旦在`app/index.js`中 `require(nodegit)`，运行时就一直会提示如下错误：
```
Module version mismatch. Expected 50, got 48
```

尝试了删除`node_modules`重新`npm install`，`electron-rebuild`, `npm rebuild` 各种方法都不行，折腾了好久，后来在 cnpm 的安装日志里面发现，安装 nodegit 的时候是从[淘宝源](https://npm.taobao.org/mirrors/nodegit/v0.16.0)上下载的预编译版本 `nodegit-v0.16.0-node-v48-darwin-x64.tar.gz`。这个预编译版本标识的是 node-v48，所以怀疑上面的错误和这个有关。

electron 的 abi 输出的是 50，但是很奇怪，最新的[nodejs-release](https://nodejs.org/en/download/releases/)版本的 `NODE_MODULE_VERSION` 是 48，electron 的 abi 和 node 的 abi 是什么关系？难道不是一个东西么？？
```
$electron -v
v1.4.3

$electron --abi
50
```

所以要自己编译下才能在最新的 electron 中使用 nodegit，在执行 npm install 前设置下环境变量：
```
export BUILD_ONLY=1
export npm_config_target=1.4.3
export npm_config_disturl=https://atom.io/download/atom-shell
export npm_config_runtime=electron
export npm_config_build_from_source=true
npm install nodegit --save
```
