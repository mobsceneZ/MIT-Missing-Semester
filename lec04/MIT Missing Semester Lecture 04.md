## MIT Missing Semester Lecture 04

2023年08月13日

### Exercise 02

可以通过如下方式找出至少包含3个`a`字符并且不以`'s`结尾的单词个数：

```shell
$ cat /usr/share/dict/words | grep -vE "'s\$" | grep '.*a.*a.*a.*' | wc -l
```

在此基础上，下述命令能指出这些单词中3个最常见的末尾双字符以及出现的双字符组合个数：

```shell
$ cat /usr/share/dict/words | grep -vE "'s\$" | grep '.*a.*a.*a.*' | sed -E 's/.*(..)$/\1/' | tr [:upper:] [:lower:] | sort | uniq -c | sort -nk1,1 | tail -n3 | awk '{print $2}' | paste -sd,
$ cat /usr/share/dict/words | grep -vE "'s\$" | grep '.*a.*a.*a.*' | sed -E 's/.*(..)$/\1/' | tr [:upper:] [:lower:] | sort | uniq -c | wc -l
```

没有出现的双字符组合可以通过`comm`命令和`procss substitution`找出：

```shell
$ cat /usr/share/dict/words | grep -vE "'s\$" | grep '.*a.*a.*a.*' | sed -E 's/.*(..)$/\1/' | tr [:upper:] [:lower:] | sort | uniq | comm -23 <(echo {a..z}{a..z} | tr " " "\n") -
```

### Exercise 03

在`bash`中输出重定向会将文件`input.txt`的内容清空使得在`sed`的输入流为空，因而无法完成就地替换。由于这是`bash`本身特性导致的，因此不局限于`sed`命令。

若想要实现就地替换，可使用命令`sed -i s/REGEX/SUBSTITUTION/ input.txt`。

### Exercise 04

参考`lecture notes`给出的`R`语言指令，可通过如下方式获得系统启动时间的平均值、中位数和最大值：

```shell
$ journalctl | grep 'Startup finished in [\.0-9]*s\.$' | sed -E 's/.* ([0-9\.]+)s\.$/\1/' | R -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
```

### Exercise 05

```shell
$ touch uniq_messages
$ journalctl -b -2 | grep -v 'Logs begin at' | sed -E 's/[^ ]+ [^ ]+ [^ ]+ [^ ]+ (.*)/\1/' | sort | uniq >> uniq_messages
$ journalctl -b -1 | grep -v 'Logs begin at' | sed -E 's/[^ ]+ [^ ]+ [^ ]+ [^ ]+ (.*)/\1/' | sort | uniq >> uniq_messages
$ journalctl -b -0 | grep -v 'Logs begin at' | sed -E 's/[^ ]+ [^ ]+ [^ ]+ [^ ]+ (.*)/\1/' | sort | uniq >> uniq_messages

$ cat uniq_messages | sort | uniq -c | awk '$1 != 3 { print $0 }'
```

### Exercise 06

根据给出的第二个链接下载得到`table-1.xls`表，并使用命令行工具`xls2csv`和`csvtool`获取其中的列数据：

```shell
# find the min and max of one column (Population in table-1)
$ xls2csv table-1.xls | csvtool format '%(2)\n' - | sed '/^$/d' | sed '/^ $/d' | tail -n+2 | sort -nk1,1 | sed -n '1p;$p'

# calculate the difference of the sum of each column (Population and Violent crime in table-1)
$ echo "$(xls2csv table-1.xls | csvtool format '%(3)\n' - | sed '/^$/d' | sed '/^ $/d' | tail -n+3 | paste -sd+ | bc -l)-$(xls2csv table-1.xls | csvtool format '%(2)\n' - | sed '/^$/d' | sed '/^ $/d' | tail -n+2 | paste -sd+ | bc -l)" | bc -l | sed 's/-//'
```



