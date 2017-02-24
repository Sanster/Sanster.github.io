title: git 文件名大小写问题
date: 2017-02-08 20:43:18
category: Tools
tags:
    - Git
---

今天又遇到了在《[总是使用 git lfs track 来添加 lfs 追踪文件](http://sanster.github.io/2017/01/11/%E6%80%BB%E6%98%AF%E4%BD%BF%E7%94%A8%20git%20lfs%20track%20%E6%9D%A5%E6%B7%BB%E5%8A%A0%E6%96%87%E4%BB%B6%E7%B1%BB%E5%9E%8B)》中提到的问题：windows 下 git clone 以后未做任何修改，但是 git status 却显示有文件修改了！看了一下项目的文件结构，并没有使用 git-lfs，在请教了同事后总算搞明白了：问题的原因和 windows 下文件、文件夹不区分大小写有关。

<!--more-->

假设你的 GitHub 仓库中有一个 `file.txt` 文件，文件内容如下：
```
This is origin file.
```

向仓库中添加一个 `FILE.txt` 文件（通过 Github 网页操作，或者在 linux 上 push 上来），文件内容如下：
```
THIS IS MODIFIED FILE.
```

然后在 windows 上 clone 这个库，git status 就会显示 file.txt 文件被修改了，此时 file.txt 的内容变成了后来添加的 `FILE.txt` 的内容：`THIS IS MODIFIED FILE.`

### 补充
在 macOS 上，文件系统默认也是大小写不敏感的，所以同样会存在本文所说的问题，以及《[windows 下 git 分支名大小写问题](http://sanster.github.io/2016/12/27/windows%20%E4%B8%8B%20git%20%E5%88%86%E6%94%AF%E5%90%8D%E5%A4%A7%E5%B0%8F%E5%86%99%E9%97%AE%E9%A2%98/)》中的问题。