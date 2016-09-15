title: redis-sentinel
date: 2016-07-04 20:47:35
category:
tags:
---

Redis 的高可用方案
[http://redis.io/topics/sentinel](http://redis.io/topics/sentinel)

[https://fnordig.de/2015/06/01/redis-sentinel-and-redis-cluster/](https://fnordig.de/2015/06/01/redis-sentinel-and-redis-cluster/)

具备的功能：
- 监控 master 和 slave 的状态
- 通知，服务挂了可以通过 api 通知
- 自动故障转移：master 挂了自动使用 slave
- client 全都连接到 Sentinel 上

sentinel 本身也是一个分布式的系统，可以部署在多台机子上

Redis2.8 3.0自带，现在版本是 Sentinel 2

```
redis-sentinel /path/to/sentinel.conf
```

运行 sentinel 一定要有一个配置文件，这个配置文件用来保存系统重启前的状态，以便重新加载。所以配置文件的权限必须是可写的。

监听TCP端口26379

部署的条件：
- 至少需要三个 Sentinel 实例部署在三台机子上，不能两台！因为他有一个投票机制，服从多数
- Sentinel + Redis distributed system does not guarantee that acknowledged writes are retained during failures, since Redis uses asynchronous replication. However there are ways to deploy Sentinel that make the window to lose writes limited to certain moments, while there are other less secure ways to deploy it.
- 客户端需要针对 Sentinel 做出修改
- There is no HA setup which is safe if you don't test from time to time in development environments, or even better if you can, in production environments, if they work. You may have a misconfiguration that will become apparent only when it's too late (at 3am when your master stops working).
