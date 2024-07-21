## MIT Missing Semester Lecture 07

2024年07月20日

### Digression

终端颜色控制：`\x1b`表示转义符(`Escape Code`)，其可与左方括号`[`一同构成控制序列引入符(`Control Sequence Introducer, CSI`)，而后紧跟参数和命令。

例如`\x1b[0;1;34m`可以被解读为调用命令`m`并且传入参数`0;1;34`，其中各参数含义跟`m`命令代表的`Set Graphics Mode`有关，这里为关闭先前设置的所有属性并将文本颜色设为(粗体/明亮)蓝色。

`ANSI Escape Sequences Cheatsheet`：https://gist.github.com/ConnerWill/d4b6c776b509add763e17f9f113fd25b

### Exercise 01

```shell
$ journalctl --since "1 day ago" | grep 'USER=root'
TTY=pts/2 ; PWD=/home/lain/missing_semester/lec07 ; USER=root ; COMMAND=/usr/bin/strace -e lstat ls -l
TTY=pts/2 ; PWD=/home/lain/missing_semester/lec07 ; USER=root ; COMMAND=/usr/bin/strace -e lstat ls -l
TTY=pts/2 ; PWD=/home/lain/missing_semester/lec07 ; USER=root ; COMMAND=/usr/bin/ls
```

### Exercise 03

根据`shellcheck`给出的提示，总共存在三处问题：

- 不要使用`ls`来获取匹配的文件名称，这会导致非预期行为(例如包含空格的文件名会被分割为若干单词)，请使用`POSIX`标准的`glob pattern`来遍历匹配的文件；
- `grep`的匹配模式需要用引号括起(否则会和`bash`自身的`globbing`冲突)，`$f`同理；
- 如果需要变量展开，使用双括号而非单括号；

经过修正后，正确的脚本应该如下所示：

```shell
#!/bin/bash
# Example: a typical script with several problems
for f in ./*.m3u
do
        grep -qi 'hq.*mp3' "$f" \
                && echo -e "Playlist $f contains a HQ file in mp3 format"
done
```

### Exercise 04

`Reversible Debugging`允许开发者反向或正向执行他们的代码以破解“谋杀案”，对于偶发漏洞或许会很有用。

`Reversible Debugger`的核心思想是记录程序中的非确定行为，例如用户输入、线程切换等。

`C/C++`场景可以使用`rr debugger`，对应技术报告发表在`ATC'17`：https://www.usenix.org/system/files/conference/atc17/atc17-o_callahan.pdf

### Exercise 05

使用`cProfile`(以`tottime`作为排序指标)和`line_profiler`来比较插入排序和快速排序的运行时间：

```shell
$ python3 -m cProfile -s tottime sorts.py
   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
33948/1000    0.021    0.000    0.032    0.000 sorts.py:20(quicksort)
      ...
     1000    0.017    0.000    0.017    0.000 sorts.py:9(insertionsort

$ kernprof -l -v sorts.py
...
Total time: 0.111035 s
File: sorts.py
Function: insertionsort at line 9

Line #      Hits         Time  Per Hit   % Time  Line Contents
==============================================================
     9                                           @profile
    10                                           def insertionsort(array):
    11
    12     25296       3439.3      0.1      3.1      for i in range(len(array)):
    13     24296       3279.9      0.1      3.0          j = i-1
    14     24296       3369.3      0.1      3.0          v = array[i]
    15    216849      39078.1      0.2     35.2          while j >= 0 and v < array[j]:
    16    192553      31664.4      0.2     28.5              array[j+1] = array[j]
    17    192553      26205.4      0.1     23.6              j -= 1
    18     24296       3849.5      0.2      3.5          array[j+1] = v
    19      1000        149.6      0.1      0.1      return array

Total time: 0.0528151 s
File: sorts.py
Function: quicksort at line 21

Line #      Hits         Time  Per Hit   % Time  Line Contents
==============================================================
    21                                           @profile
    22                                           def quicksort(array):
    23     33838       5974.8      0.2     11.3      if len(array) <= 1:
    24     17419       2100.6      0.1      4.0          return array
    25     16419       2190.3      0.1      4.1      pivot = array[0]
    26     16419      15388.0      0.9     29.1      left = [i for i in array[1:] if i < pivot]
    27     16419      17130.0      1.0     32.4      right = [i for i in array[1:] if i >= pivot]
    28     16419      10031.4      0.6     19.0      return quicksort(left) + [pivot] + quicksort(right)
```

使用`memory_profiler`查看二者的内存使用情况，发现并不存在显著区别。插入排序理应比快速排序使用更少的内存，因为其不涉及到递归调用。

```shell
$ python3 -m memory_profiler sorts.py
Line #    Mem usage    Increment  Occurrences   Line Contents
=============================================================
     9   18.402 MiB   18.402 MiB        1000   @profile
    10                                         def insertionsort(array):
    11
    12   18.402 MiB    0.000 MiB       26074       for i in range(len(array)):
    13   18.402 MiB    0.000 MiB       25074           j = i-1
    14   18.402 MiB    0.000 MiB       25074           v = array[i]
    15   18.402 MiB    0.000 MiB      227828           while j >= 0 and v < array[j]:
    16   18.402 MiB    0.000 MiB      202754               array[j+1] = array[j]
    17   18.402 MiB    0.000 MiB      202754               j -= 1
    18   18.402 MiB    0.000 MiB       25074           array[j+1] = v
    19   18.402 MiB    0.000 MiB        1000       return array

Line #    Mem usage    Increment  Occurrences   Line Contents
=============================================================
    21   18.402 MiB   18.402 MiB       33622   @profile
    22                                         def quicksort(array):
    23   18.402 MiB    0.000 MiB       33622       if len(array) <= 1:
    24   18.402 MiB    0.000 MiB       17311           return array
    25   18.402 MiB    0.000 MiB       16311       pivot = array[0]
    26   18.402 MiB    0.000 MiB      156143       left = [i for i in array[1:] if i < pivot]
    27   18.402 MiB    0.000 MiB      156143       right = [i for i in array[1:] if i >= pivot]
    28   18.402 MiB    0.000 MiB       16311       return quicksort(left) + [pivot] + quicksort(right)
```

### Exercise 08

直接运行`stress -c 3`会导致`3`个`CPU`的占用率直接达到`100%`。

`taskset --cpu-list 0,2 stress -c 3`命令会强制仅使用`#0`和`#2`号`CPU`，即`stress`程序被强制绑定到这两个`CPU`上运行。

使用`cgroups`控制进程所使用的资源，例如内存：

```shell
$ sudo cgcreate -g memory:cgrouptest
# set memory limit to 40MB
$ echo $((40 * 1024 * 1024)) | sudo tee /sys/fs/cgroup/memory/cgrouptest/memory.limit_in_bytes
# the actual memory consumption will not exceed 40MB
$ sudo cgexec -g memory:cgrouptest stress -m 4
```

### Exercise 09

使用`http`作为过滤器查看`curl`命令收发的网络包，`curl`发出`GET`请求获取`ipinfo.io`的根目录，`ipinfo.io`返回状态码为`200`的网络包并在数据载荷部分将`IP`地址等信息以`JSON`格式返回。
