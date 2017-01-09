title: Git 找回丢失的节点
date: 2017-01-09 21:25:58
category: Tools
tags: Git
---

最近有一次 git 操作失误，checkout 到了一个 commit id 上，并且对新的修改做了 commit，后来切回别的分支干了一会儿活，想要再找的时候这个 commit 就找不到了......。最后想起来可以用 git reflog 看历史记录，然后再创建个分支，免得以后找不到：git branch new_branch_name [commit_id]

不过用 reflog 有个坏处是，如果是很早以前的记录，又忘了 commit 的 message 的话，那在一堆历史记录里面找起来可能就比较麻烦了（git 有二分法查找的命令，不过我没用过），这种离散在 branch 之外的 commit 可以用  `git fsck` 命令找:

```
$ git fsck --lost-found
Checking object directories: 100% (256/256), done.
Checking objects: 100% (40055/40055), done.
dangling commit 9ab33dd5c1972654291e4a3a2aba195dc8046ca8
```

> dangling 不是拼音！人家的意思是「悬、挂」...


参考链接：
* http://stackoverflow.com/questions/10099258/how-can-i-recover-a-lost-commit-in-git