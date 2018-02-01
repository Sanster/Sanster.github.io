title: HTTP POST 方法 body 的编码方式
date: 2017-08-10 18:50:58
category: Web
tags:
  - RESTful
---

发起 HTTP POST 请求时，参数通常会放在 body 中，body 中数据的编码方式由 header 中的 Content-Type 决定，
常见的格式有 application/x-www-form-urlencoded、application/json 等。
<!--more-->

- application/x-www-form-urlencoded：通过 form 表单发送的 POST 请求默认为该种格式，传递的数据使用 [URL encoding](https://en.wikipedia.org/wiki/Percent-encoding) 方式编码，会将数据中的特殊字符进行转义，例如 @ -> %40，空格 -> %20
- multipart/form-data：上传二进制文件时需要指定该格式，在 form 表单中可以通过 enctype 指定 Content-Type 为该格式。 multipart/form-data 需要和 boundary 一起使用，以下是一次请求的示例：
```
POST  HTTP/1.1
Host: www.demo.com
Content-Type:multipart/form-data; boundary=----WebKitFormBoundary5oPhaUlEyeiBv4to

------WebKitFormBoundary5oPhaUlEyeiBv4to
Content-Disposition: form-data; name="user"

admin
------WebKitFormBoundary5oPhaUlEyeiBv4to
Content-Disposition: form-data; name="file"; filename="SibSetup.msi"
Content-Type: application/octet-stream

------WebKitFormBoundary5oPhaUlEyeiBv4to--
```

`boundary` 是一个游览器随机生成的用于分割数据的字符串，body 中每段数据用 `--boundary` 分割，最后以 `--boundary--` 结束。示例中的第一段参数，key 为 user，value 为 admin，第二段参数中的 name，filename 表明这是要上传的二进制文件，各类语言的服务器端都会有相应的解析库解析参数对、获得上传的文件。

- application/json：使用该格式就表明 POST 过来的数据是经过序列化的 JSON 字符串，在服务器端需要反序列化生成 JSON 对象

参考：
- https://stackoverflow.com/questions/3508338/what-is-the-boundary-in-multipart-form-data
- http://www.jianshu.com/p/4f9e79eb0163
- https://imququ.com/post/four-ways-to-post-data-in-http.html
