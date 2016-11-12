title: Angular：在 factory 中运行 controller 的 callback 函数
date: 2016-08-31 20:54:13
category: Frontend
tags: Angular1
---

示例代码效果：每隔 10 秒钟查询一次气温并刷新数据（防止不小心一直发，$timeout先注释掉了）。

下面的代码是改了下 codecademy 上 Angularjs-1.x 教程中的例子，更新数据的方法采用的是 factory 初始化时传递一个 callback 函数：

{% jsfiddle bbxx8hLv html,js,result dark 100% 700px %}

SOF 也有相关的问题，采用的是另一种方法

