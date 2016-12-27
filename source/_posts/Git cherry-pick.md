title: Git cherry-pick 
date: 2016-12-27 15:27:48
category: Git
tags:
---

git cherry-pick 命令可以用来挑选其他分支的 commit 合入当前分支：
```
git cherry-pick [节点号]
```

git 会计算目标 commit 与其 parent commit 之间的 diff，并使用该 diff 在当前分支上重新创建一个 commit（所以节点号会发生变化），其 Author 与原节点号相同，Commit 会变成执行 cherry-pick 命令的人，可以使用 git log --pretty=fuller 查看 Author 和 Commit：
```
commit 9cfe5103141ae22c8e4ca98715e526fe094f99b8
Author:     user1 <user1@email.com>
AuthorDate: Mon Dec 19 09:00:29 2016 +0800
Commit:     user2 <user2@email.com>
CommitDate: Mon Dec 19 09:00:29 2016 +0800
```
参考链接：
* https://git-scm.com/docs/git-cherry-pick
* http://stackoverflow.com/questions/9229301/git-cherry-pick-says-38c74d-is-a-merge-but-no-m-option-was-given　
