title: windows 下 git 分支名大小写问题
date: 2016-12-27 09:38:48
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
Git 的分支是以文件形式保存在 `.git/refs/heads` 目录下的，每一个分支文件中记录着所指向的 commit 节点号。对于我们的测试项目，`.git/refs/heads` 的目录内容是这样的：
```
refs
|__heads
   |_R
   | |_123
   | |_234
   |_master
```
创建分支时，如果名称中不包含`/`符号，git 就会直接在 heads 目录下创建一个对应的分支文件，如 master 分支。否则，git 会先创建一个文件夹，再将 / 后面的字符作为分支文件名称保存，如果存在多个 / 的话则会创建多层文件夹。

在之前的操作中，我们先创建了 **R/123** 分支，git 就创建了对应的 R 文件夹，后面再创建 **r/234** 分支时，正确的姿势应该是创建一个 r 文件夹，但是**在 windows 下，文件夹名称不区分大小写！**这就导致了我们的分支文件直接创建在了 R 目录下，所以执行 git branch 命令时并没有显示 r/234 分支，而是显示 **R/234**。

# 补充如果
在 windows 中创建大小写同名分支时，如果分支名中不包含 / 的话，git 会提示相同的分支已经存在:
```
git checkout -b test
Switched to a new branch 'test'

git checkout -b TEST
fatal: A branch named 'TEST' already exists.
```


# 解决问题
知道了原因以后修正起来就方便了，可以直接在 `.git/refs/heads` 目录下按照你想要的方式修改文件夹/文件名，或者删了分支文件，重新拉一个分支都可以。

参考链接：
* http://stackoverflow.com/questions/15371866/why-is-git-capitalizing-my-branch-name-prefix
