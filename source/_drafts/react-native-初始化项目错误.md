title: react native 初始化项目报错
date: 2016-01-31 09:45:03
category: react-native
tags:
---

在 Mac 上按照 React Native 官网的 [Getting Start](http://facebook.github.io/react-native/docs/getting-started.html#content) 初始化一个 Demo 项目，但是在 Xcode 里面 run 的时候却 build failed。

开发环境：
```
node: v5.5.0
nvm: 0.28.0
npm: 3.3.12
react-native-cli: 0.1.10
react-native: 0.19.0
```

错误信息：
```
+ react-native bundle --entry-file index.ios.js --platform ios --dev true --bundle-output /Users/user/Library/Developer/Xcode/DerivedData/RNApp-ckxusxiznabgxxcrqessfpbjyrks/Build/Products/Debug-iphonesimulator/RNApp.app/main.jsbundle --assets-dest /Users/user/Library/Developer/Xcode/DerivedData/RNApp-ckxusxiznabgxxcrqessfpbjyrks/Build/Products/Debug-iphonesimulator/RNApp.app
bundle: Created ReactPackager
uncaught error Error: ReferenceError: [BABEL] /Users/user/Desktop/RNApp/node_modules/react-native/node_modules/react-transform-hmr/node_modules/react-proxy/node_modules/react-deep-force-update/lib/index.js: Unknown option: /Users/user/Desktop/RNApp/node_modules/react-native/node_modules/react-transform-hmr/node_modules/react-proxy/node_modules/react-deep-force-update/.babelrc.stage
    at Logger.error (/Users/user/Desktop/RNApp/node_modules/react-native/node_modules/babel-core/lib/transformation/file/logger.js:41:11)
    at OptionManager.mergeOptions (/Users/user/Desktop/RNApp/node_modules/react-native/node_modules/babel-core/lib/transformation/file/options/option-manager.js:262:18)
    at OptionManager.addConfig (/Users/user/Desktop/RNApp/node_modules/react-native/node_modules/babel-core/lib/transformation/file/options/option-manager.js:221:10)
    at OptionManager.findConfigs (/Users/user/Desktop/RNApp/node_modules/react-native/node_modules/babel-core/lib/transformation/file/options/option-manager.js:364:16)
    at OptionManager.init (/Users/user/Desktop/RNApp/node_modules/react-native/node_modules/babel-core/lib/transformation/file/options/option-manager.js:412:12)
    at File.initOptions (/Users/user/Desktop/RNApp/node_modules/react-native/node_modules/babel-core/lib/transformation/file/index.js:191:75)
    at new File (/Users/user/Desktop/RNApp/node_modules/react-native/node_modules/babel-core/lib/transformation/file/index.js:122:22)
    at Pipeline.transform (/Users/user/Desktop/RNApp/node_modules/react-native/node_modules/babel-core/lib/transformation/pipeline.js:42:16)
    at transform (/Users/user/Desktop/RNApp/node_modules/react-native/packager/transformer.js:59:24)
TransformError: /Users/user/Desktop/RNApp/node_modules/react-native/node_modules/react-transform-hmr/node_modules/react-proxy/node_modules/react-deep-force-update/lib/index.js: [BABEL] /Users/user/Desktop/RNApp/node_modules/react-native/node_modules/react-transform-hmr/node_modules/react-proxy/node_modules/react-deep-force-update/lib/index.js: Unknown option: /Users/user/Desktop/RNApp/node_modules/react-native/node_modules/react-transform-hmr/node_modules/react-proxy/node_modules/react-deep-force-update/.babelrc.stage
See logs /var/folders/g9/m3cmg0m10cl80xt362wpsld00000gn/T/react-packager.log
    at SocketClient._handleMessage (SocketClient.js:139:23)
    at BunserBuf.<anonymous> (SocketClient.js:53:42)
    at emitOne (events.js:77:13)
    at BunserBuf.emit (events.js:169:7)
    at BunserBuf.process (/Users/user/Desktop/RNApp/node_modules/react-native/node_modules/bser/index.js:289:10)
    at /Users/user/Desktop/RNApp/node_modules/react-native/node_modules/bser/index.js:244:12
    at nextTickCallbackWith0Args (node.js:419:9)
    at process._tickCallback (node.js:348:13)
Command /bin/sh failed with exit code 1
```

刚开始只盯着最后一行错误信息`Command /bin/sh failed with exit code 1`搜索，但是搜不出相关的内容，最后耐心的看了一下错误信息，发现似乎和[Babel]这歌包有关，google 了以下以后，在 SOF 上找到了答案：http://stackoverflow.com/questions/34975286/reactnativecli-init-helloworld-project-build-error-with-babel-transformerror。

具体原因可以看上面的链接中的解释，想要先快速解决的话，可以直接在项目文件夹里面执行以下命令：
```
find ./node_modules -name react-packager -prune -o -name '.babelrc' -print | xargs rm -f
```