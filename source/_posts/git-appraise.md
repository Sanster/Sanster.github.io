title: Distributed Code Review For Git: git-appraise
date: 2017-02-04 15:14:48
category: Tools
tags:
  - Git
  - git-appraise
---

[git-appraise](https://github.com/google/git-appraise) 是 Google 推出的一款分布式代码检视工具，安装这个工具以后，团队成员可以在本地使用 git-appraise 提供的命令发起检视请求、对特定代码行评论、接受检视意见等操作，这类操作一般都是要依托于 GitHub 或者 GitLab 这样的代码托管平台来完成。所有的检视请求(reviews)和检视意见(discuss)都会保存在 .git 文件夹中，从而实现分布式。

根据 [git-appraise tutorial](https://github.com/google/git-appraise/blob/master/docs/tutorial.md) 整理的两个用户之间使用 git-appraise 进行检视的场景。

## 用户 A 操作
1. 从 master 拉一个新分支 **cwq/start**，commit 一次，使用`git appraise request`发起一次 `Review request`：
```
$ git appraise request
Review requested:
Commit: 7a8dbc31023f4d12d7c4be1f03f44db025e3086f
Target Ref: refs/heads/master
Review Ref: refs/heads/cwq/start
Message: "start branch commit"
```

和 GitHub 的 Pull Request 类似，review request 有目标分支（target ref）和源分支（review ref）。**Commit/Message 是 cwq/start 分支的最新节点**，后续的 git-appraise 操作都是针对这个节点号进行操作的。

2. 使用 `git appraise push` 把 review request 推送到远端：
```
$ git appraise push
Counting objects: 3, done.
Delta compression using up to 8 threads.
Compressing objects: 100%(3/3), done.
Writing objects: 100% (3/3), 427 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To git@github.com:Sanster/test.git
 * [new branch] refs/notes/devtolls/reviews -> refs/notes/devtools/reviews
```

review request 和 branch 类似，就是一个存放 sha 值的指针文件，但这个指针文件当中的 sha 值在整个操作过程当中都不会涉及，应该只是 git-appraise 内部使用的。

## 用户 B 操作
1. 使用 `git appraise pull` 从远端获取 review request：
```
$ git appraise pull
...
From git@github.com:Sanster/test.git
 * [new ref] refs/notes/devtolls/reviews -> refs/notes/devtools/reviews
```

2. 使用 `git appraise list` 可以查看当前的 review request，这个操作可以在任意分支上进行。可以看到有一个处于 pending 状态的 review request：
```
$ git appraise list
Loaded 1 open reviews:
[pending] 7a8dbc31
  start branch commit
```

3. 使用 `git appraise show --diff [sha]` 查看某个 review request 的 diff，其实就是目标分支和源分支的 changes，这里发现可能会存在问题，见文章后一节**发现的问题**。

4. 使用 `git appraise comment` 对 review request 中的特定文件的某行进行评论：
```
git appraise comment -f READMED.md -l 2 -m "Ah, so that's what this is" 7a8dbc31
```
```
* -f 指定要评论的文件
* -l 指定要品论的行，这里的行指的是整个文件当中的第几行，可以评论文件的非 diff 区域
* -m 是评论的内容
* 7a8dbc31：代表被检视的节点
```

4. 评论完后使用 `git appraise show [sha]` 查看具体的 review request 内容，可以看到评论。

5. 使用 `git appraise push` 把评论提交到远端

## 用户 A 继续操作
1. 使用 `git appraise pull` 下载远端评论

2. 使用 `git appraise accept [sha]` 接受用户 B 的 review

3. 使用 `git appraise submit --merge [sha]` 接受某个 review，这个操作会把 cwq/start 分支(Review ref)合入 master(Target Ref)，并产生一个 merge 节点，该节点的 commit message 中包含了被 review 过的 commit sha(即：7a8dbc31)。

4. 使用 `git appraise list` 查看 review，可以看到用户 A 提出的 review 已经被接受了：
```
Loaded 1 open reviews:
[accepted] 7a8dbc31
   start branch commit
```

# 总结
git-appraise 的 review request 流程和 GitHub/GitLab 的 Pull/Merge Request 流程很相似，区别是把所有操作都放到了命令行当中，所有的检视请求和检视意见都跟着仓库跑，实现了分布式。这个工具要用的话就要整个团队一起用，学习和使用的成本也较高，感觉也不是很方便啊，对于喜欢用命令行的 Geek 来说可能 Cool 吧，我还是比较喜欢在网页上操作。

# 发现的问题
如果用户 A 在一个分支上发起了一个 review request，然后又新加了一个 commit，再执行 git appraise push，此时 review request 中的 commit 节点号并没有更新。用户 B 执行 git appraise pull 以后，通过 git appraise show --diff 查看到的 diff 是最新节点与 target ref 的 diff，而不是 review request 中的 commit sha 与 target ref 的 diff。
