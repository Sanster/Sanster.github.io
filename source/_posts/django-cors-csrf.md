title: Django 中的 CORS 和 CSRF
date: 2016-08-19 21:15:54
category: Backend
tags: Django
---

CORS 的全称为 Cross-origin resource sharing（跨域资源共享），是 W3C 的一个标准，它的作用是允许使用 AJAX 向不同源的服务器发送 GET、POST 等请求，CORS 标准的实现需要游览器端和客户端都支持，现代的游览器一般都支持，发请求时开发者在自己的代码里不需要为支持 CORS 做任何改动，如果服务器端允许 CORS 访问就可以进行跨域的资源共享，具体的介绍可以看阮一峰的博客：[跨域资源共享 CORS 详解](http://www.ruanyifeng.com/blog/2016/04/cors.html)

<!--more-->

在 Django 中可以使用 [Django CORS headers](https://github.com/ottoyiu/django-cors-headers) 来使服务器端支持 CORS，可以方便地设置允许跨域的 URL 表达式、允许跨域访问的白名单等。参考文章：[Django CORS](http://www.vinta.com.br/blog/2015/django-cors/)

CSRF 的全称为 Cross Site Request Forgery（跨站域请求伪造），是一种网络攻击方式，具体的攻击方法和应对方法可见：[CSRF 攻击的应对之道](http://www.ibm.com/developerworks/cn/web/1102_niugang_csrf/)。

在 Django 中，提供了`django.middleware.csrf.CsrfViewMiddleware`中间件来方便地为网站提供 CSRF 保护，为网站的表单生产随机的 token，并验证请求中的 csrf_token：[Cross Site Request Forgery protection](https://docs.djangoproject.com/en/1.10/ref/csrf/)

如果要想禁止对某些 views 访问的 CSRF 保护，可以使用`@csrf_exempt`，参考:[How to disable Django's CSRF validation?](http://stackoverflow.com/questions/16458166/how-to-disable-djangos-csrf-validation)
```python
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def my_view(request):
    return HttpResponse('Hello world')
```

还可以通过设置[CSRF_COOKIE_DOMAIN](https://docs.djangoproject.com/en/1.10/ref/settings/#csrf-cookie-domain) 或 [CSRF_TRUSTED_ORIGINS](https://docs.djangoproject.com/en/1.10/ref/settings/#csrf-trusted-origins) 来使某些客户端能通过 HTTP Referer 字段的验证。

**2016-08-20更新**
调试的时候目前的 `django-cors-headers 1.1.0` 不支持 Django 1.10，会出现如下错误，暂时规避的方法可以参考[django-cors-headers#Issue-102](https://github.com/ottoyiu/django-cors-headers/issues/102)
```
    module = import_module(module_path)
  File "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/importlib/__init__.py", line 37, in import_module
    __import__(name)
  File "/Users/cwq/mysite/mysite/wsgi.py", line 16, in <module>
    application = get_wsgi_application()
  File "/Library/Python/2.7/site-packages/django/core/wsgi.py", line 14, in get_wsgi_application
    return WSGIHandler()
  File "/Library/Python/2.7/site-packages/django/core/handlers/wsgi.py", line 153, in __init__
    self.load_middleware()
  File "/Library/Python/2.7/site-packages/django/core/handlers/base.py", line 82, in load_middleware
    mw_instance = middleware(handler)
TypeError: object() takes no parameters
```
