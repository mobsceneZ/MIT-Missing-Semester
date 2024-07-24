## MIT Missing Semester Lecture 09

2024年07月24日

### Exercise Entropy.01

`correcthorsebatterystaple`的熵为：$entropy = log_2(100000^4)=66.44\ bits$

### Exercise Entropy.02

`rg8Ql34g`的熵为：$entropy = log_2(62^8)=47.63\ bits$

### Exercise Entropy.03

显然，`correcthorsebatterystaple`的熵更高，因此是更强的密码。

### Exercise Entropy.04

对于`correcthorsebatterystaple`而言需要`317097920`年，对于`rg8Ql34g`而言需要`692`年。

### Exercise Hash.01

从兰州大学镜像站下载`Debian`镜像，并使用`sha256sum`检查是否跟官网给出的一致：

```shell
$ sha256sum debian-12.6.0-amd64-netinst.iso
ade3a4acc465f59ca2496344aab72455945f3277a52afc5a2cae88cdc370fa12  debian-12.6.0-amd64-netinst.iso
```

### Exercise Symmetric.01

我们使用`README.md`进行测试：

```shell
$ openssl aes-256-cbc -salt -in README.md -out README.enc.md
$ hd README.enc.md
00000000  53 61 6c 74 65 64 5f 5f  55 f1 e8 a0 fa cc 46 94  |Salted__U.....F.|
...
000000b0  4b 93 fb b2 ff ab 34 ad  aa 6a e9 dc 72 b5 97 c2  |K.....4..j..r...|
000000c0
$ openssl aes-256-cbc -d -in README.enc.md -out README.dec.md
$ md5sum README.dec.md README.md
bca19b7b4c67dd2f0c1655c574e188fe  README.dec.md
bca19b7b4c67dd2f0c1655c574e188fe  README.md
```

### Exercise Asymmetric.04

为作练习用途，我们在最新提交上新建标签：

```shell
$ export GPG_TTY=$(tty)
$ git tag -s TestGPG HEAD
$ git tag -v TestGPG
object c4ba200cf2c5fa4d1e50bd68eb1ae19b7f57b5e6
type commit
...
This tag is mainly used to test GPG signing.
...
gpg: Good signature from "Lingming Zhang <zjuzlm01@gmail.com>" [ultimate]
```



