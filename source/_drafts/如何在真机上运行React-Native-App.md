title: 如何在真机上运行React-Native App
date: 2016-02-08 19:29:18
category: react-native
tags:
---

初上手 Xcode，感觉 Apple 的开发套件还是做的不错的，已经形成了一套完整的系统，各类设备的模拟器也应有尽有，让开发者专注于 App 的开发。但是模拟器毕竟和真机的感觉还是差了点，而且也想尝试一下 RN 写的 App 到底如何在真机上跑，于是就开始了尝试。

之前就知道要为苹果开发 App 需要注册并且缴费，一年 688RMB，不便宜，据说是因为苹果提供了「大量」的资料给开发者。还好如果只是在自己的机子上调试的话，Xcode 7 已经支持了，不需要缴纳注册费，有个帐号就可以了。

回到 RN，按照教程顺利见了一个 Demo，就是那个显示电影列表的 App（AwesomeProject），如果想要在真机上运行有[两种方式](http://facebook.github.io/react-native/docs/running-on-device-ios.html#content)：

**第一种：联机调试**
只需要把`AwesomeApp/ios/AwesomeApp/AppDelegate.m`中的`localhost`改成自己电脑的 ip（需要处于同一Wifi网络下），然后 build 的目标选择自己的手机即可。

**第二种：脱机独立运行**
同样是`AppDelegate.m`文件，去掉下面这行代码的注视，选择自己的手机运行即可。
```
jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
```

其实在`AppDelegate.m`文件当中，关于两种运行方式都有写说明内容，仔细读一下就能了解，不过刚开始的时候可能不知道要在这个文件当中修改。

React-Native 自带了4个 Demo 其中要一个是 UIExplorer 包含了很多「组件」和「API」的示例，是一个很好的学习的例子。要在真机上运行，除了去掉上述提到的那一行代码的注释外，还需要「下载」一个`main.jsbundle`文件，这个文件包含了所有 Javascript 的代码。下面是 UIExplorer Demo 中的具体说明。
```
/**
 * OPTION 2
 * Load from pre-bundled file on disk. To re-generate the static bundle, `cd`
 * to your Xcode project folder and run
 *
 * $ curl 'http://localhost:8081/Examples/UIExplorer/UIExplorerApp.ios.bundle?platform=ios' -o main.jsbundle
 *
 * then add the `main.jsbundle` file to your project and uncomment this line:
 */
```

获得了 main.jsbundle 文件后，很重要的一步是 `add the main.jsbundle file to your project`，由于对 Xcode 不熟完全没有意识到这句话的意思，真机运行一直不成功，后面在 SOF 上找到了原因：http://stackoverflow.com/questions/29374410/how-to-build-react-native-app-for-iphone

最后，还有一个疑问没去查，为什么 UIExplorer 需要执行 curl 命令下载 main.jsbundle，而 AwesomeProject 却不需要呢？这歌问题先放着吧，随着之后的学习应该会找到答案。
