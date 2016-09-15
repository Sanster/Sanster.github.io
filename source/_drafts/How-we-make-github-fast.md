title: How_we_make_github_fast
date: 2016-07-03 09:07:16
category:
tags:
---

[How we made github fast](https://github.com/blog/530-how-we-made-github-fast)

就每一个技术选择给出理由，扩展一个 Web app 的方法有很多

# 理解协议
三种协议：
- HTTP
- SSH
- Git

通过追踪每种协议的传播途径来理解架构

**HTTP 请求**

一个文件树 HTTP 请求[http://github.com/mojombo/jekyll](http://github.com/mojombo/jekyll)

请求首先会到负载均很器(Load Balancer)，使用[Idirectord](http://horms.net/projects/ldirectord/)。
有两个实例`lb1a`和`lb1b`，一个处于激活状态，一个处于等待状态，以防 master 失效。
Load balancer 根据请求的 IP 和 端口，把 TCP packets 发给不同的服务器，并可以移除 misbehaving 的请求。
如果没有服务器可以响应请求，它会返回静态的页面，而不是拒绝请求。
发给主站的请求会被负载均衡器发送给四台前端机器，每一台的配置：8核，16GB 内存。`fe1`,...,`fe4`。

Nginx 建立连接并将请求发送到 Unix domain socket，Unicorn 的 worker 进程连接着这个 socket。其中一个 worker 获得请求，并运行对应的 Rails 代码来实现它。

许多页面需要查询数据库，MySQL 数据库运行在两个8核，32GB 内存的物理机上（硬盘转速 15k）。名字`db1a`,`db1b`，一个是 master，一个是 slave，MySQL 的备份同步通过[DRDB](http://www.drbd.org/)完成。

如果一个页面需要的关于 Git 仓库的数据没有缓存过，那就会用 [Grit](http://github.com/mojombo/grit)来获得这些数据，对 Grit 做了一些改造，来适应特殊的需求

把 Grit::Git 的操作通过 RPC 的方式发送到一个 Smoke 服务器上（grit 是沙子的意思，Smoke 是在天上的沙子）

[ProxyMachine](https://github.com/mojombo/proxymachine)
[HAProxy](http://haproxy.1wt.eu/)

ProxyMachine 允许使用 Ruby 来编写路由代理规则。

The stubbed Grit makes RPC calls to smoke which is a load balanced hostname that maps back to the fe machines. Each frontend runs four ProxyMachine instances behind HAProxy that act as routing proxies for Smoke calls. ProxyMachine is my content aware (layer 7) TCP routing proxy that lets us write the routing logic in Ruby. The proxy examines the request and extracts the username of the repository that has been specified. We then use a proprietary library called Chimney (it routes the smoke!) to lookup the route for that user. A user’s route is simply the hostname of the file server on which that user’s repositories are kept.

Chimney 通过 Redis 来找到路由。Redis 允许在数据库的服务器上。使用 Redis 来储存路由信息和其它一些信息。

Smoke proxy 确定了用户的路由以后，就会与对应的文件服务器建立起传输代理。有四组文件服务器，`fs1a`,`fs1b`,...,`fs4a	`,`fs4b`，使用的是8核，16GB 的物理服务器，每一个有6块300GB 的硬盘（15000转）使用 RAID10。一台是 master 一块是 slave，通过 DRDB 从 master 备份到 slave。

每一台文件服务器在 HAProxy 后面跑两个 RPC 服务器[ernie](https://github.com/mojombo/ernie)。每个 Ernie 跑15个 worker。这些 worker 用来处理 RPC 的调用，并执行 Grit 的方法。响应的请求通过 Smoke 代理给 Rails app。

当 Unicorn 完成了 Rails 的动作，请求会通过 Ngnix 直接返回给客户端（出去的请求不会经过 lB）

上述这个过程是缓存没有命中的时候，在很多情况下 Rails 应用使用用 Ruby 封装的[memcached](https://github.com/arthurnn/memcached)来向[Memcache](http://memcached.org/)服务器发送请求，Memcache 跑在 slave 文件服务器上。这些服务器比较空闲，在每台服务器上设置了12GB 的 Memcache。命名为`memcache1`,...,`memcache4`.

#BERT and BERT-RPC
数据的序列化和 RPC 协议我们用的是 BERT 和 BERT-RPC。在那时这是全新的东西。之所以使用这个是因为对现有的其它选择不满意，这篇文章介绍了为什么使用它，想通过它解决什么问题[Introducing BERT and BERT-RPC](http://github.com/blog/531-introducing-bert-and-bert-rpc)

使用 Ruby 封装的库，[BERT](https://github.com/mojombo/bert)，[BERT-RPC-client](http://github.com/mojombo/bertrpc)，[BERT-RPC-server](http://github.com/mojombo/ernie)

# Tracing an SSH Request
Git 使用SSH 来加密客户端和服务器端之间的通信，为了便于理解处理 SSH 链接的架构，先从简单的开始介绍

Git 依赖于 SSH 允许在远端执行命令的能力。例如可以通过`ssh tom@frost ls -al`来在`forst`服务器运行`ls -al`命令，命令的输出可以在本地的终端中看到，SSH hooking up 远端机器的STDIN，STDOUT，和 STDERR。

当执行`git clone tom@frost:mojombo/bert`命令时，Git 所做的是与`frost`建立 SSH 链接，用 tom 用户鉴权，然后远端会执行``git upload-pack mojombo/bert`命令。然后客户端就可以通过 SSH 链接与远端的进行进行读写。

当然，允许执行任意的命令是不安全的，SSH 具有限制哪些命令可以执行的能力。简单地说，你可以通过[git-shell](https://www.kernel.org/pub/software/scm/git/docs/git-shell.html)
来限制，git-shell 是 git 自带的。这个脚本的作用就是确认执行的命令是`git upload-pack`,`git receive-pack`，`git upload-archive`中的一个，如果是其中的一个就使用[exec](http://linux.die.net/man/3/exec)命令来执行。

这是 Git 的 SSH 如何工作的一个简单例子，下面看下在 GitHub 的架构下是如何处理的。

首先你的 Git 客户端初始化一个 SSH session，发到 load balancer 上。然后链接发送到前端的一台机子上，通过[SSHD]()处理。我们改造了 SSH 进程，通过 MySQL 数据库来寻找公钥，你的 key 表示你在 Github 上的用户信息，这个 key 是通过
From there, the connection is sent to one of the frontends where SSHD accepts it. We have patched our SSH daemon to perform public key lookups from our MySQL database. Your key identifies your GitHub user and this information is sent along with the original command and arguments to our proprietary script called Gerve (Git sERVE). Think of Gerve as a super smart version of git-shell.

Gerve 根据传过来的参数验证用户对仓库有权限。如果你是仓库的所有者，那不会有查数据库的动作，否则会去查几次数据库来确定权限。

访问一经验证，Gerve 就使用 Chimney 去查找仓库的路由。现在的目标就是要在对应的文件服务器上来执行你的原始命令，并且将你的机器与远程的进程 hook 起来。采用的方法依然是 remote SSH execution

这听起来很疯狂，但是却很有用，Gerve 简单地使用`exec(3)`来 replace 他自己`ssh git@<route> <command> <arg>. 这么调用以后你的客户端就和一个前端机器连接起来了，这个机器对应连接这一台文件服务器。

简单地说就是：在确定了权限和仓库的位置后，前端变成一台转发的代理。这个方案的唯一缺点就是内部的 SSH不需要加密解密。我们可能使用其它方式来代替这个内部的 SSH 调用，但是这个方法足够简单足够快，以至于还不用太担心。

# Tracing aGit Request

