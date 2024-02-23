## MIT Missing Semester Lecture 06

2024年01月17日

### Exercise 02

使用`git clone https://github.com/missing-semester/missing-semester`命令将远程仓库拷贝至本地：

```sh
# Question 01
$ git log --pretty=oneline --graph
*   d38f585d656e68a526262302b382606ade6d8f8a (HEAD -> master, origin/master, origin/HEAD) Merge branch 'alexandr-gnrk/update-jupyter-binding'
|\
| * f600f32e71d5f9952ef02d758fca7a35759ba453 Update Vim binding for Jupyter
|/
* 2253e4e0896121d4b42ca867b9b1552e2b9e62cb Switch recommended app to Rectangle
...
# Question 02
$ git log --pretty="%an" -1 -- README.md
Anish Athalye
# Question 03
$ git blame _config.yml | grep 'collections:' | cut -d' ' -f1 | xargs git show --pretty=oneline --no-patch
a88b4eac326483e29bdac5ee0a39b180948ae7fc Redo lectures as a collection
```

### Exercise 03

对于需要批量修改提交历史的场景，可以采用`git filter-branch`命令 (但`Git`现在并不推荐使用该指令)：

```sh
# Introduce a large file and make some commits
$ curl https://raw.githubusercontent.com/mojombo/grit/master/lib/grit/repo.rb > repo.rb
$ git commit -am 'introduce large file repo.rb'
...
# Use tree-filter to rewrite history
$ git filter-branch --tree-filter 'rm -f repo.rb' HEAD
```

### Exercise 04

`git stash`将工作目录和索引中的修改保存到`stash entry`中，并将二者回退至`HEAD`对应的版本状态。

`git log --all`会额外列出先前保存的`stash entry`:

```sh
$ git log --all --oneline
8839d6c (refs/stash) WIP on master: d38f585 Merge branch 'alexandr-gnrk/update-jupyter-binding'
```

假设我们当前工作在`feature1`分支并且修改了工作目录，现在需要转移至`feature2`分支处理紧急情况。倘若当前对`feature1`分支的修改仍不足以形成一个合适的提交，可以使用`git stash`暂存本地修改。

### Exercise 05

```sh
$ git config --global alias.graph 'log --all --graph --decorate --oneline'
```

### Exercise 06

```sh
$ git config --global core.excludesfile ~/.gitignore_global
$ cat ~/.gitignore_global
# editor-related temporary file
*~
```
