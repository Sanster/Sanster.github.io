title: Git cherry-pick
date: 2016-12-27 15:27:48
category: Tools
tags: Git
---

git cherry-pick 命令可以用来挑选其他分支的 commit 合入当前分支：
```
git cherry-pick [节点号]
```

git 会计算目标节点与其 parent 节点之间的 diff，并使用该 diff 在当前分支上重新创建一个 commit（所以节点号会发生变化），其 Author 与原节点号相同，Commit 会变成执行 cherry-pick 命令的人，可以使用 git log --pretty=fuller 查看 Author 和 Commit：
```
commit 9cfe5103141ae22c8e4ca98715e526fe094f99b8
Author:     user1 <user1@email.com>
AuthorDate: Mon Dec 19 09:00:29 2016 +0800
Commit:     user2 <user2@email.com>
CommitDate: Mon Dec 19 09:20:29 2016 +0800
```

<!--more-->

如果 cherry-pick 的是一个 merge 节点，git 会给出以下提示，提示中显示要加上 -m 参数：
```
error: Commit xxxxxx is a merge but no -m option was given.
fatal: cherry-pick failed
```

merge 节点会有两个或两个以上的父节点：
```
commit 4b3b817a2f322209cfe5c502d4a98359a59aea6b
Merge: 9cdbc2c 1f7c0ec
Author: user <user@email.com>
```

执行 cherry-pick 命令时 git 无法确定目标 merge 节点与其哪一个父节点比较，这个父节点即可通过 `-m` 参数指定：
```
git cherry-pick -m 1 4b3b817a2f322209cfe5c502d4a98359a59aea6b
```

-m 后面跟的是一个数字，表示第几个父节点，对于上面的例子，`1f7c0ec` 为第一个父节点，`9cdbc2c` 为第二个父节点。

参考链接：
* https://git-scm.com/docs/git-cherry-pick
* http://stackoverflow.com/questions/9229301/git-cherry-pick-says-38c74d-is-a-merge-but-no-m-option-was-given　
