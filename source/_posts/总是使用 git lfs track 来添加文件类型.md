title: 总是使用 git lfs track 来添加 lfs 追踪文件
date: 2017-1-11 10:35:48
category: Tools
tags: 
  - Git
  - Git-LFS
---

今天遇到一个乍看之下匪夷所思的问题：使用 `git clone` 后，未对 clone 下来的仓库做任何操作，但是 `git status` 却显示有文件被修改了！感觉超级诡异...
经过一番定位，发现项目使用了 `Git LFS`，而那些显示为「已修改」的文件，正是被 lfs 追踪的文件。

## 问题复现

在命令行中运行下面的命令，创建一个测试项目：

```
git init git-lfs-bug
cd git-lfs-bug
echo 0 > lfs.bin
git add lfs.bin
git commit -m "add binary file"
echo *.bin filter=lfs diff=lfs merge=lfs -text > .gitattributes
git add .gitattributes
git commit -m "track with lfs"
git status
```

上面的命令先向仓库中 commit 了一个二进制文件，然后没有用 `git lfs track` 命令添加要跟踪的文件类型，而是使用 `echo *.bin filter=lfs diff=lfs merge=lfs -text > .gitattributes` 创建了 `.gitattributes` 文件。

最后的 git status 会显示当前的工作空间是 clean 的：

```
On branch master
nothing to commit, working directory clean
```

把这个测试工程推送到 Github 上，重新 clone 到本地，然后再执行 `git status`，这时会发现项目当中的 lfs.bin 文件显示被修改了：

```
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   lfs.bin

no changes added to commit (use "git add" and/or "git commit -a")
```

所以问题的原因就是这些文件在被加入到 .gitattributes 文件中前就已经 commit 到了库里面。然后又手工修改了 .gitattributes 文件，导致使用 git status 不会显示有文件修改，然后就 push 到库上了，别人再 clone 的时候就会显示这些文件被修改了。

## 结论

1. 如果你的库中已经发生了上述的情况，将 git status 显示的修改文件 commit 一次，git lfs 就会将这些文件追踪起来。
1. 不要手动修改 .gitattributes 文件，总是使用 git lfs track 命令来添加要追踪的文件类型（原因见下一节）。

## 扩展

在上面的结论当中提到，「总是用 `git lfs track`命令来添加要追踪的文件类型」，原因是 git-lfs 对 track 命令做了优化（1.2.0及之后的版本[链接](https://github.com/git-lfs/git-lfs/pull/1104)），track的同时会去修改被 track 文件的 `mtime/atime`，然后 git status 就会认为这个文件被修改了，下面的几行命令和问题复现中的唯一区别就是使用了 `git lfs track` 来添加追踪类型：

```
git init git-lfs-bug
cd git-lfs-bug
echo 0 > lfs.bin
git add lfs.bin
git commit -m "add binary file"
git lfs track *.bin
git add .gitattributes
git commit -m "track with lfs"
git status
```
想要了解具体细节的话可以参考以下两个 Github 的 Issue：


* https://github.com/git-lfs/git-lfs/issues/1848
* https://github.com/git-lfs/git-lfs/issues/1057
