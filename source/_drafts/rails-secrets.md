title: rails-secrets
date: 2016-07-09 18:58:40
category:
tags:
---

10.1 Custom secrets
Rails generates a config/secrets.yml. By default, this file contains the application's secret_key_base, but it could also be used to store other secrets such as access keys for external APIs.

The secrets added to this file are accessible via Rails.application.secrets. For example, with the following config/secrets.yml:

development:
  secret_key_base: 3b7cd727ee24e8444053437c36cc66c3
  some_api_key: SOMEKEY
Rails.application.secrets.some_api_key returns SOMEKEY in the development environment.

If you want an exception to be raised when some key is blank, use the bang version:

Rails.application.secrets.some_api_key! # => raises KeyError: key not found: :some_api_key

用来存放用于访问其它系统的 key，比如 api