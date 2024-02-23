## MIT Missing Semester Lecture 02

2023年06月30日

### Exercise 01

通过查阅`ls`的`manpage`，可以通过如下命令完成任务：

```shell
$ ls -alht --color=always
```

### Exercise 02

通过使用`$()`能相对便捷地完成该练习：

```shell
#!/usr/bin/env bash

marco() {
  echo "$PWD" > /tmp/work_dic
}

polo() {
  cd $(cat /tmp/work_dic)
}
```

### Exercise 03

```shell
#!/usr/bin/env bash
count=1

while true; do
        $PWD/example02.sh 1>/tmp/stdout 2>/tmp/stderr
        if [[ $? -ne 0 ]]; then
                break
        fi
        let count++
done

echo "standard output: $(cat /tmp/stdout)"
echo "standard error:  $(cat /tmp/stderr)"
echo "It takes $count times to trigger a failure run"
```

### Exercise 04

通过查阅`tldr xargs`可以得到一个直观的实现方法：

```shell
$ find . -name '*.html' -print0 | xargs -0 zip -r compressed.zip
```

或者可以通过如下方式实现：

```shell
$ find . -name '*.html' | xargs --delimiter='\n' zip -r compressed.zip
```

### Exercise 05

可以通过如下命令实现该操作：

```shell
$ head --lines 1 <(find . -type f | xargs --delimiter='\n' ls -lt) | tr -s ' ' | cut --delimiter=' ' --fields=9
```



