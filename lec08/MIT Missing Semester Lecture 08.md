## MIT Missing Semester Lecture 08

2024年07月23日

### Exercise 01

假设所有源文件都被`git`所管理，新生成的目标文件是`untracked`状态，那么可以使用`git ls-files -o`罗列需要删除的文件。

修改后的`Makefile`文件如下所示：

```makefile
.PHONY: clean
paper.pdf: paper.tex plot-data.png
        pdflatex paper.tex
plot-%.png: %.dat plot.py
        ./plot.py -i $*.dat -o $@
clean:
        git ls-files -o | xargs rm -f
```



### Exercise 02

`Caret`标记：默认设置，允许进行与`Semantic Versioning`兼容的软件更新，形如`^1.2.3`。

`Tilde`标记：只允许最小版本更新。如果声明主、次与补丁版本或只声明主次版本，只有补丁修改版本能更新。如果只声明主版本，只有次版本和补丁版本更新能被采纳，例如`~1.2.3`只允许更新到在`1.2.3`到`1.3.0`之间的版本。

`Wildcard`标记：允许版本中`wildcard`放置的位置为任意版本，如`1.2.*`。

`Comparison`和`Multiple Version`标记：允许声明特定版本或者版本范围，例如`>= 1.2, < 1.5`。

### Exercise 03

`pre-commit hook`允许用户在执行`git commit`操作之前进行一系列检查，若检查返回非零值则终止本次提交。

```shell
#!/bin/bash
pushd "$PWD/lec08" ; make paper.pdf >/dev/null 2>&1

if [ $? -ne 0 ]
then
        echo -e "\x1b[1;31mMake fails with non-zero exit status, please check.\x1b[0m"
        make clean ; popd ; exit 1
else
        make clean ; popd ; exit 0
fi
```

### Exercise 05

下述`GitHub Actions`脚本实现的仅是使用`proselint`来检查`pull request`中所有`Markdown`文档的语法错误，并在对应`pull request`下评论输出信息。为防止`proselint`返回非零值导致流程失败，在运行`proselint`时将`continue-on-error`设置为`true`。

示例效果可见：https://github.com/mobsceneZ/MIT-Missing-Semester/pull/1

```yaml
name: use proselint to polish markdown texts

on:
  workflow_dispatch:
  pull_request:

permissions:
  contents: read
  pull-requests: write

jobs:

  check_lint_on_markdown:
    name: check markdown lint

    runs-on: ubuntu-latest

    steps:
      - name: checkout
        uses: actions/checkout@v4

      - name: update repository
        run: sudo add-apt-repository universe

      - name: install proselint
        run: sudo apt install python3-proselint

      - name: run proselint
        continue-on-error: true
        run: proselint *.md >suggestions.md 2>&1

      - name: PR commit with file
        uses: thollander/actions-comment-pull-request@v2
        with:
          filePath: suggestions.md
```

