title: JSON Web Token Authentication
date: 2017-07-10 19:54:17
category: Web
tags:
---

# 什么是 JWT？
[JSON Web Token Authentication](https://jwt.io/) 可以用来在 web 应用中处理用户认证的，下图是 [JWT 官网](https://jwt.io/introduction/) 上关于 JWT 工作流程的介绍：首先客户端将用户名和密码 POST 到服务器端，服务器验证用户信息后，根据 JWT 的数据格式生成使用 secret 加密过的 token，并返回给客户端，客户端保存该 token（如 localStorage），并在每次请求中把 token 附带在 Header 里发送给服务器，服务器使用 secret 解密后即可获得用户会话信息。

<!--more-->

![jwt-diagram](/images/jwt-diagram.png)

# JWT 的数据结构
一个 JSON Web Token 看起来是这个样子的：

![jwt-structure](/images/jwt-structure.png)

以`.`为区分，分为三部分：
- Header
- Payload
- Signature

前两部分 Header、Payload 是由 Base64 编码获得的结果，这个示例 JWT 的原始数据如下：

Header：
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

Payload:
```json
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true
}
```

Payload 是存放业务信息的地方，但由于是 Base64 加密的，所以不能放敏感的数据。

最后一段 Signature 是由 Header 中指定的算法对 header 和 payload 进行加密的结果：
```ruby
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  secret)
```

 其中 secret 是服务器端的私钥，计算这个签名的目的是为了使服务器端能够验证 header 和 payload 中的数据是没有经过篡改的。

# JWT 的优势、可能的问题
网上提到比较多的基于 Session 的认证问题主要集中在_资源消耗_和_扩展性_上。基于 Session 的认证机制依赖服务器端保存用户会话信息（内存或者数据库中），服务器端通过客户端发过来的 session id 找到对应的用户会话信息，在用户量较多的场景下，服务器的内存销也会较大（但是感觉大多数小网站都不用担心这个吧。。）。

如果要实现多个 web 应用 session 信息的共享，则需要额外部署一个共享信息的数据库，如 redis，如果系统本来没有使用 redis 的话，就相当于额外多了一个组件，增加了系统的复杂性。

由于 JWT 认证的方式是将用户会话信息放在客户端，所以就不存在上述的内存开销和共享信息的问题，无论是哪个客户端应用只要带上 token 即可，不需要关心跨域（CORS）、子域名等问题。由于这个特点，JWT 很适合作为单点登录（SSO）的实现方式，各个应用系统之间不用共享 session 信息，共享一个 secret 就可以了，感觉上是方便很多，不过没有实际实现过，实际实现过程中可能也会有很多坑吧。

# JWT 的安全性
从 JWT 的数据结构可以看出，使用 JWT 并不能解决数据传输的安全性，所有传输的数据都是公开的，它只能保证传输的数据没有经过篡改，确实是由 token 中记录的用户发出来的，但是如果 token 被别人拿走的话，也就可以伪造你的身份了。要确保数据安全还是要用 HTTPS。

参考链接：
- [StackExchange：Session Authentication vs Token Authentication](https://security.stackexchange.com/questions/81756/session-authentication-vs-token-authentication)
- [Token-based authentication with Ruby on Rails 5 API](https://www.pluralsight.com/guides/ruby-ruby-on-rails/token-based-authentication-with-ruby-on-rails-5-api)
- https://jwt.io/introduction/
- [传统 Web 应用中的身份验证技术](http://www.jianshu.com/p/6ca51a8d66bd)