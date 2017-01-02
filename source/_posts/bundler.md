title: Bundler
date: 2016-07-26 20:42:31
category: Backend
tags:
  - Gems
  - Ruby
---

ruby 通过 Gem 包的方式来管理组件包，你可以在[这里]找到你所需的 Gem 包。一个 Ruby 项目如果需要依赖很多 Gem 包，管理所需的依赖包以一件很麻烦的事情，[Bundler](http://bundler.io/) 便是一个可以用来管理 Gem 包的 Gem 包（有点绕口），大名鼎鼎的 [Rails](https://github.com/rails/rails) 其实也就是一个 Gem 包。

<!-- more -->

# 定义 Gemfile
像所有 Gem 包一样，可以通过如下命令安装 Bundler：
```bash
gem install bundler
```

然后你需要在你的 Ruby 项目中添加一个 **Gemfile** 文件，该文件用来管理这个项目所需的所有 Gem 包，Rails 程序初始化时会自动创建 **Gemfile** 文件。一个简单的 **Gemfile** 文件看起来是这样的：
```ruby
#1
source  'https://rubygems.org'
gem ‘nokogiri’
#2
gem ‘rack’, ‘~>1.1’
#3
gem ‘rspec’, :require => ‘spec’
```

1. 定义 Gem 包的下载源（国内可以用[淘宝](https://ruby.taobao.org/)的源）
2. 定义所需 Gem 包的名称和版本，如果没有定义的话，模式会使用最新的版本。
3. 定义 Gem 包的依赖关系，bundler 会进行解析，并将所有依赖的 Gem 都下载下来。

某些情况下，可能需要使用某个 Gem 包未正式发布的代码，这时有两种选择：
1. 指定 Gem 包的 git 仓库以及其分支
```ruby
gem 'nokogiri', :git => 'https://github.com/tenderlove/nokogiri.git', :branch => '1.4'
```
2. 将 Gem 包代码下载到本地，通过路径加载
```ruby
gem 'extracted_library', :path => './vendor/extracted_library
```

有些 Gem 包可能只是开发环境上用于调试使用，而生产环境上是不需要的，可以通过 **Group** 的形式来区分：
```
group :development do
	gem 'ffaker'
  ...
end
```

# 使用 bundle install 安装 Gem 包
定义好 Gemfile 后，即可执行 [bundle install](http://bundler.io/v1.12/man/bundle-install.1.html) 命令安装所需的 Gem 包，如果是第一次运行，在与 Gemfile 相同的目录下会产生一个 **Gemfile.lock** 文件，该文件会记录 Gemfile 文件中每一个 Gem 包解析出来的具体版本和依赖。**Gemfile.lock** 文件的意义在于：如果别人运行你的程序，那 `bundle install` 命令会先检测是否存在 Gemfile.lock 文件，如果存在，则不会去重新解析 Gemfile 文件（Gemfile文件未修改的话），而是根据 Gemfile.lock 文件下载依赖，这样就能保证程序在不同的机子上不会因为某个 Gem 包更新了版本之类的情况导致各种莫名的问题。

# 使用 bundle update 更新 Gem 包
如果想更新 Gemfile.lock 中的 Gem 版本，直接修改 Gemfile 中的 Gem 版本，再执行 bundle install 命令，这时会提示 Gem 包的版本已经被锁定在了 x.x.x，如：
```
The bundle currently has rails locked at 4.2.7.
```

这时可以执行[bundle update]来更新 Gem 包的版本。


# 使用 bundle exec 执行任务
Gemfile 中定义的 Gem 包是如何应用到你的程序当中的呢？使用 [bundle exec](http://bundler.io/v1.12/man/bundle-exec.1.html) 命令执行程序会将环境变量设置好，使用 Gemfile 里指定的 Gem 包来运行你的程序，这样就保证了在不同环境下执行程序时，总会使用指定的 Gem 包版本来执行某个操作。