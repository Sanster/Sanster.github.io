title: 数字签名、数字证书和 HTTPS
date: 2017-04-24 20:18:54
category: Web
tags:
 - HTTPS
 - Certificate Authority
 - Digital Signature
---

对于数字证书、数字签名的概念一直很模糊，虽然网上看了很多文章，但是自己脑子里想完整地梳理一遍的时候就还是乱乱的，所以动手整理了下，在写作的过程中各个概念之间的关系慢慢变得清晰了。

# 公钥、私钥和数字签名
首先是公钥和私钥的概念。公钥（Public Key）和私钥（Private Key）是一对使用特定加密算法产生的密钥对（两串字符串），可以使用 [OpenSSL](https://zh.wikipedia.org/wiki/OpenSSL) 或者 OpenSSH 的 ssh-keygen 工具生成。公钥和私钥都可以用来加密数据，经过私钥加密的数据，只有通过公钥才可以解密出来，反之亦然。

私钥自己保留，公钥用于发放给别人。为什么要发给别人呢？因为这样就可以实现和对方之间的加密通讯，过程如下：

- Susan 有 Bob 的公钥，在给 Bob 发消息前使用公钥对消息进行加密，这样就只有拥有私钥的 Bob 才可以解密消息。
- Bob 使用他的私钥可以在数据上进行数字签名，即先将要发送的数据进行 Hash 运算，然后使用私钥加密 Hash 运行的结果，最后加密的结果就是叫数字签名（Digital Signature）。
- Bob 把数字签名随同数据一起发给 Susan，Susan 通过 Bob 的公钥可以获得两个信息：
  1 - 如果使用公钥成功解密数字签名，则说明这个信息确实是通过 Bob 的私钥加密的
  2 - 对传输的数据进行 Hash 运算，如果结果与解密出来的 Hash 值一致，则说明数据没有被篡改过。

> [Hash 算法](https://zh.wikipedia.org/wiki/%E6%95%A3%E5%88%97%E5%87%BD%E6%95%B8)会将数据变成一段固定长度的 message digest，且不同的原始数据经过运算后会产生截然不同的结果，可以认为不存在使用不同的原始数据来伪造相同的 hash 值的情况。

如果按照以上的流程，Bob 向 Susan 发送的数据是没有加密的（即使用私钥加密了数据，别人也能用公钥解开），那如何保证数据不被窃取呢？具体的例子可以看 HTTPS 一节的介绍。

# 中间人攻击与数字证书
上文中的加密通讯是在 Susan 正确获得 Bob 公钥的前提下进行的，如果 Susan 和 Bob 的通讯被 Doug 拦截，Doug 将 Bob 发给 Susan 的公钥替换成自己的公钥（至于替换的方式我们先不管），这样 Susan 就会认为 Doug 是 Bob，把原本要发给 Bob 的消息使用 Doug 的公钥加密并发送，Doug 收到后可以用自己的私钥解密，获得数据内容，然后再用 Bob 的公钥加密发送给 Bob，Bob 会认为这些信息是 Susan 发过来的。在这个过程中 Doug 可以任意篡改信息，Doug 就是在进行中间人攻击。

数字证书（Digital Certificate）就是用来确保 Susan 拿到的确实是 Bob 的公钥，而不是中间人 Doug 的。数字证书是由 Certificate Authority（CA）机构颁发的，所谓数字证书就是 CA 机构使用自己的私钥，对 Bob 的公钥和一些相关信息（如国家、公司、域名）一起加密的结果，CA 机构在颁发证书前会有一套严格的流程来确保相关信息的准确性。以网站来举例，Github 证书经过 CA 公钥解密后获得的一定就是 Github 的公钥。知名 CA 机构的根证书会内置于游览器中，用来确保 CA 机构本身的身份，其中就包含了 CA 机构自身的公钥。有了证书以后，网站发送信息只要附带上自己的证书，就能证明自己的身份。下图是使用 Chrome 查看 Github 的证书：

![GitHub Cert](/images/GitHub_cert.png)

# HTTPS
那么 HTTPS 与数字证书之间是什么关系呢？网上找了一张介绍 HTTPS 的流程图，如果前面的概念都理解了的话，那一看这个流程图就能大概了解 HTTPS 是怎么回事了。

![https](/images/https.png)

图中的第四步中 `validata crt` 我理解就是使用 CA 的公钥验证服务器端发送的证书的有效性，如颁发机构是否有效、证书中的域名和访问的域名是否一致、证书是否过期、是否被吊销等。如果证书有问题，游览器会给出警告。如果证书有效，客户端会产生一个随机字符，并使用从证书中获得的服务器端公钥加密后传输给服务器，这个信息只有服务器端的私钥才能解密，服务器端解密获得了随机字符后，便使用该随机字符对发送出去的内容进行[对称加密](https://zh.wikipedia.org/wiki/%E5%B0%8D%E7%A8%B1%E5%AF%86%E9%91%B0%E5%8A%A0%E5%AF%86)，服务器端就可以使用相同的随机字符进行解密，这样就实现了加密通讯。

从上面的过程看，HTTPS 通讯是有一定性能损耗的，但毕竟更安全了嘛。

参考链接：
- http://www.ruanyifeng.com/blog/2011/08/what_is_a_digital_signature.html
- http://www.youdzone.com/signature.html
- https://jamielinux.com/docs/openssl-certificate-authority/index.html
- https://zh.wikipedia.org/wiki/%E4%B8%AD%E9%97%B4%E4%BA%BA%E6%94%BB%E5%87%BB
- https://zh.wikipedia.org/wiki/%E5%85%AC%E5%BC%80%E5%AF%86%E9%92%A5%E5%8A%A0%E5%AF%86
- http://www.jianshu.com/p/671e3cf26974