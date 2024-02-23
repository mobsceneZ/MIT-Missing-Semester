## MIT Missing Semester Lecture 05

2023年08月17日

### Job Control Exercise 01

`pgrep`指令的`-a`选项会罗列进程号以及完整的命令，而`pgrep`和`pkill`的`-f`选项允许匹配整条命令而不单是进程名：

```shell
$ pgrep -af 'sleep 10000'
58206 sleep 10000
$ pkill -f 'sleep 10000'
[1]+  Terminated              sleep 10000
```

### Job Control Exercise 02

`wait pid`命令会等待由进程号`pid`指定的进程完成并返回其退出状态：

```shell
$ sleep 60 &
$ wait $! ; ls
```

类似地，可采用`kill -0 pid`的形式判断目标进程是否完成执行：

```shell
pidwait() {
        while [ -z "$(kill -0 $1 2>&1)" ]
        do
                sleep 1
        done

        ls $PWD
}
```

### Aliases Exercise 01

```shell
$ alias dc=cd
```

### Aliases Exercise 02

```shell
$ alias top10="history | awk '{\$1=\"\";print substr(\$0,2)}' | sort | uniq -c | sort -n | tail -n 10"
```

### Remote Machines Exercise 01-07

有关`VirtualBox`虚拟机的`ssh`服务设置可以参考：https://averagelinuxuser.com/ssh-into-virtualbox/

在`WSL`中访问主机的`localhost`需要主机的`ipv4`地址，相关问题可参考：https://stackoverflow.com/questions/64763147/access-a-localhost-running-in-windows-from-inside-wsl-2

使用`ssh-keygen`命令生成公私钥对：

```shell
$ ssh-keygen -o -a 100 -t ed25519
```

`~/.ssh/config`文件配置如下，其中`HostName`是主机的`ipv4`地址：

```
Host vm
        User kali
        Port 2222
        HostName 10.162.9.147
        IdentityFile ~/.ssh/id_ed25519
        LocalForward 9999 localhost:8888
```

`ssh-copy-id vm`命令可将生成的`ssh`公钥添加到虚拟机端：

```shell
$ ssh-copy-id vm
```



在虚拟机一侧使用如下命令启动`WebServer`：

```shell
$ python3 -m http.server 8888
Serving HTTP on 0.0.0.0 port 8888 (http://0.0.0.0:8888/) ...
127.0.0.1 - - [18/Aug/2023 01:31:09] "GET / HTTP/1.1" 200 -
```

当在`WSL2`中使用`ssh vm`连接到虚拟机后，在主机浏览器中访问`http://localhost:9999/`时虚拟机能成功接收到`GET`请求。



如果将虚拟机侧`/etc/ssh/sshd_config`的`PasswordAuthentication`选项设置为`no`，将不允许以密码验证的形式登录虚拟机：

```shell
$ ssh -p 2222 kali@10.162.9.147
kali@10.162.9.147: Permission denied (publickey).
```

类似地，当`PermitRootLogin`选项被设置为`no`时，将不允许用户以管理员身份登录：

```shell
$ ssh -p 2222 root@10.162.9.147
root@10.162.9.147's password:
Permission denied, please try again.
```



可采用如下命令实现后台的端口转发：

```shell
$ ssh -p 2222 -L 9999:localhost:8888 -N -f kali@10.162.9.147
```

