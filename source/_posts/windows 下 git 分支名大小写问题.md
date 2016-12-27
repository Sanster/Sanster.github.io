title: windows 下 git 分支名大小写问题
date: 2016-11-11 09:38:48
category: Git
tags:
---

# 问题
最近遇到了一个由于 window 不区分大小写导致的 git 分支问题。

在出错的仓库里执行 git branch(git bash中) 查看目前的分支：
```bash
xxxxxxxx MINGW64 /d/test_git (r/234)
$git branch
 R/123
 R/234
 master
```
可以看到，git bash 中显示，当前分支为 `r/234`，但是在 git branch 的输出中却没有，只有以大写开头的 `R/234`。

当想要 push 当前分支时会提示如下错误：
```
$ git push origin r/234
fatal: r/234 cannot be resolved to branch
fatal: The remote end hung up unexpectedly
```

git 提示你分支 `r/234` 不存在。

# 复现
1. 准备测试 git 工程环境：
```
mkdir test_git
cd test_git
git init
touch readme
git add .
git commit -m "test"
```

2. 从 master 分支拉一个大写开头的分支：
```
git checkout -b R/123
```

这时的 git branch 输出是正常的，* 号显示出了当前所在的分支：
```
xxxxxxxx MINGW64 /d/test_git (R/123)
$git branch
* R/123
  master
```

3. 切换回 master 分支，再创建一个以小写开头的分支：
```
git checkout -b r/234
```
这时再查看分支就出现了开头所说的问题！

# Why？
Git 的分支是以文件形式保存在 `.git/refs/heads` 目录下的，每一个分支文件中记录着所指向的 commit 节点号。对于我们的测试项目，`.git/refs/heads` 的目录下
