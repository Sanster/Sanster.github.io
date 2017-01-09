title: Git 修改提交纪录
date: 2015-11-22 11:20:48
category: Tools
tags: Git
---

**修改最近一次提交**
使用 `git commit --amend` 命令可以修改最近一次commit的内容和标题。执行该命令前，把要对最近一次commit修改的内容`git add`到暂存区中，然后执行该命令，在编辑器中会出现以下内容：

<!-- more -->

```vim
 This is a commit message.

 # Please enter the commit message for your changes. Lines starting
 # with '#' will be ignored, and an empty message aborts the commit.
 #
 # Date:      Fri Dec 11 21:31:01 2015 +0800
 #
 # On branch b4
 # Your branch is up-to-date with 'origin/b4'.
 #
 # Changes to be committed:
 #       modified:   README.md
 #
```
第一行是commit的message，可随意修改，`Changed to be committed:`中的内容即包含了这个commit老的修改以及这次操作新加入的修改。需要注意的是，只要执行了`git commit －－amend`命令，即使未对commit做任何修改，该commit的sha值也会改变。

**修改历史提交**
`git commit --amend` 命令只能修改最近的一次提交，如果想修改再之前的提交可以使用`git rebase -i`命令。执行`git rebase -i HEAD~3`后会在编辑器中显示如下内容：
```vim
pick 76338f5 1
pick b4c7566 2
pick d4ffba8 3

 # Rebase 173d2a0..d4ffba8 onto 173d2a0 (3 command(s))
 #
 # Commands:
 # p, pick = use commit
 # r, reword = use commit, but edit the commit message
 # e, edit = use commit, but stop for amending
 # s, squash = use commit, but meld into previous commit
 # f, fixup = like "squash", but discard this commit's log message
 # x, exec = run command (the rest of the line) using shell
 #
 # These lines can be re-ordered; they are executed from top to bottom.
 #
 # If you remove a line here THAT COMMIT WILL BE LOST.
 #
 # However, if you remove everything, the rebase will be aborted.
 #
 # Note that empty commits are commented out
```
前三行即为最近的三次提交，`d4ffba8 3`是最新的一次，`76338f5 1`是最早的一次提交。如果想要修改`76338f5 1`的内容，可将第一行的pick改成edit，然后保存退出编辑器。退出后，分支的`HEAD`就回到了`76338f5 1`，这时就可以通过`git commit --amend`来修改commit的内容。修改完后，执行`git rebase --continue`就可以回到`d4ffba8 3`.除了`edit`，`pick`，还有其它参数可选，以`squash`为例：
```vim
pick 76338f5 1
squash b4c7566 2
pick d4ffba8 3
```
上述修改告诉git，将`b4c7566 2`合并入`76338f5 1`，并且会保留`b4c7566 2`的message。需要注意的是，上述命令执行完以后从`76338f5 1`之后的commit的sha值都已经改变了！
