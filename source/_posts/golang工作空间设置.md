title: golang工作空间设置
date: 2016-01-10 09:11:13
category: go
tags:
---

{{indent}}linux／Mac下，go语言默认安装到`/usr/local/go`目录下，安装完成后需要将`/usr/local/go/bin`添加到**PATH**当中，目前用的是zsh，所以在`~/.zshrc`文件当中添加`export PATH=$PATH:/usr/local/go/bin`即可。

<!-- more -->

如果是将Go安装到了自定义的目录下，那么就需要设置下`GOROOT`变量，将`GOROOT`设置为go所在的安装目录：
```
export GOROOT=$HOME/go   ［这里配制成自定义安装的go目录］
export PATH=$PATH:$GOROOT/bin
```
需要注意的是，`GOROOT`这个变量只有在自定义了go的安装目录时才需要去设置。

除了`GOROOT`之外还有一个很重要环境变量`GOPATH`，go的设计理念是将项目放到一个**workspace**中管理，一个workspace就是一个文件夹路径，工作前需要将`GOPATH`设置为某个或多个workspace的路径。在workspace中，按照go的约定需要创建三个文件夹：`src，bin，和pkg`。项目的源码必须放在**src**文件夹中，例如我有一个Hello项目，那么它最终的路径应当是`workspace/src/hello/`。然后可使用`go install hello`命令生成编译并安装hello项目，这里**安装**的意思是：如果hello项目最终是生成一个可执行文件，那么该文件将会被放到`workspace/bin`文件夹中，如果是生成一个包文件，那么该文件将会被放到`workspace/pkg`文件当中。

当然其实你也可以不按照约定来设定上述的目录，在项目文件夹中执行`go build`一样可以生成可执行文件或者包文件。如果只是想跑一下程序可以使用`go run hello.go`命令，该命令会在零时文件夹生成可执行文件，然后运行并输出结果。