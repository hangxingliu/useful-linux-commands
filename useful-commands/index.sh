# Miscellany
# miscellaneous commands

# Install Ubuntu unity tweak tools
sudo apt install unity-tweak-tools

# Bash auto completion(press tab) for Centos/RHEL (给Centos/RHEL 安装bash补全)
yum install bash-completion

# 修改默认目录的语言(reboot required)
vim ~/.config/user-dirs.locale # en_US
# 改变默认目录的位置 Ubuntu
vim ~/.config/user-dirs.dirs
# 如果还是无效,就去掉这个文件的写权限
chmod -w ~/.config/user-dirs.dirs
# 也可以改变 默认目录位置
vim /etc/xdg/user-dirs.defaults

# 改变键盘布局 keyboard layout
sudo vim /etc/default/keyboard
XKBLAYOUT="us" # 改成us就可以了

# tar 解压缩查看
tar -xvzf xxx.tar.gz #x: 解压 v: 详细 z: gzip f: 跟着文件
tar -tzf xxx.tar.gz #t: test 列举出文件
tar -cvf xx.tar #c: 创建
# --wildcards '*.txt' 匹配中压缩包内所有txt文件
# -C /to/path 解压到指定目录

# Hide a file/directory in nautilus(file explorer) 在文件浏览器中隐藏一个文件/文件夹
echo "file or directory" >> .hidden

# Modify/Change password 修改密码
passwd
passwd username
passwd -g group_name

# Clean DNS cache 清理DNS缓存
sudo /etc/init.d/dns-clean restart

# 配置DNS
sudo vim /etc/resolvconf/resolv.conf.d/base
# or old time execute `sudo vim /etc/resolv.conf`
# Format:
#	nameserver 8.8.8.8
#	nameserver 4.4.4.4
# edit finish and then
sudo resolvconf -u

# 查看系统信息
uname -a

# 查询一个域名的IP
host -v $HOST_NAME

# 创建文件链接
ln -s originalFolder new.lnk

# 查找含有指定关键字的文件
## -r: 递归 -n 行号 -w 整个单词 -i 忽略大小写
## --include=\*.{c,h} 只包含c的源文件和头文件(*.c 和 *.h)
## --exclude=*.o 不包含*.o文件
## --exclude-dir={dist, *-obj} 不包含dist和以-obj结尾的目录
grep -rnwi 'path/to/folder' -e 'keyword'

# Resolve `alt` conflict between VSCode and system. 解决VSCode的alt键与系统冲突的问题
gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier "<Super>"

# grep display before lines and after lines. grep查询关键字以及上3行下5行
grep -A 5 -B 3 -e "keyword"

# show date in special format. 按照YYMMDD hhmmss显示时间
date "+%y/%m/%d %H:%M:%S"

# copy text to system clipbord. 将文本复制到系统剪切板
echo 'helloworld' | xclip -selection clipboard

# 无需密码执行sudo nopassword
sudo vim /etc/sudoers
# 或 sudo vim /etc/sudoers.d/allow_xx_do_xx
# 添加内容, 语法参考
#  允许 xyz 无需密码运行sudo所有命令
xyz ALL=(ALL) NOPASSWD: ALL
# 允许 xyz 无需密码运行 node 和 npm
xyz ALL=(ALL) NOPASSWD: /usr/bin/node, /usr/bin/npm
# 允许 x 组的所有成员无需密码运行sudo所有命令
%x ALL=(ALL) NOPASSWD: ALL
# === sudoer 配置出错无法使用 sudo 的解决方法:
pkexec visudo -f /etc/sudoers.d/allow_xx_do_xx

# screen 命令
#  命令行多屏screen
screen commands...
#  将当前screen放置后台
Ctrl+a d
#  查看目前后台的screen
screen -ls
#  切换到某个后台screen
screen -r screen_id

# 将img或img.xz镜像写入磁盘(U盘,做启动盘,装树莓派啥的)
# <drive address>可以在 gnome-disks中看到, 类似 /dev/sdc
xzcat xxx.img.xz | sudo dd of=<drive address> bs=32M
sudo dd if=xxx.img of=<drive address> bs=32M

# 重启Ubuntu的资源(文件)管理器 explorer
# (有时候出现bug的时候可以使用)
nautilus -q

# 禁止Ubuntu的游客模式(Guest)
sudo vim /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
# 添加一行
allow-guest=false
# 重启, 如果还不行的话就再添加一行(因为ubuntu-session的原因)
greeter-session=unity-greeter

# Ubuntu挂载了硬盘后无法读写
# 在磁盘(Disk)(gnome-disks)中找到对应分区
# 在挂载选项中加入:
rw
# 如果还不行, 就到mnt下对应的挂载点chown和chgrp一下
chown username /mnt/disk_xxx
chgrp groupname /mnt/disk_xxx

# Sogou PinYin(IME) Bug 搜狗拼音bug问题
cd /home/ly/.config/SogouPY
git init
# 通过建立git仓库的办法让Sogou拼音坏了的时候还可以被恢复回来

# fix Android Studio (IntelliJ IDEA, and JetBrains IDEs) could not input Chinese
# 修复 Android Studio, IDEA 等 JetBrains 全家桶无法输入中文的 Bug
# For example fix Android Studio:

# Way 1 (please try way 2 if this solution have no effect):
vim /path/to/android-studio/bin/studio.sh
# insert following commands before last command (last command is looks like "$JAVA_BIN" \ ...)
# 在最后一句命令前加入以下命令: (最后一句命令大致长这个样: "$JAVA_BIN" \ ...)
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
export GTK_IM_MODULE="fcitx"

# Way 2: set environment variables about language (设置相应的语言环境变量)
vim /path/to/android-studio/bin/studio.sh
# replace last command from: "$JAVA_BIN" \ ... 替换最后一句命令
# to:
env \
  LANG=zh_CN.UTF-8 \
  LANGUAGE=zh_CN:en_US:en \
  LC_CTYPE="zh_CN.UTF-8" \
  LC_COLLATE="zh_CN.UTF-8" \
  LC_MESSAGES="zh_CN.UTF-8" \
"$JAVA_BIN" \
  ${AGENT} # ...


# install youtube-dl
# -H set home variable into sudo
sudo -H pip install --upgrade youtube-dl

# iconv convert encoding/charset from GBK to UTF-8. 将 GBK 转成 utf8
iconv -f GBK -t UTF-8 file.txt -o utf8_file.txt

# font directory in Ubuntu. Ubuntu字体路径
ls ~/.local/share/fonts/

# 查看软件包含文件的位置
dpkg -L $软件名称
# 查找某个文件是那个软件的
dpkg -S $文件路径

# 安装可在 Linux 上交叉编译Windows程序的 mingw
sudo apt install mingw-w64
# 编译: -static-libxxx 是为了让相应的库静态存储到 exe文件中 防止电脑上缺失这些库
i686-w64-mingw32-g++ main.cpp -o bin.exe -static-libstdc++ -static-libgcc

# 内存盘 RAM DISK
sudo mount -t tmpfs -o size=512m tmpfs /path/mount/to
# 开机设置
vim /etc/fstab
tmpfs /path/mount/to tmpfs rw,relatime,size=512m 0 0

# find duplicated/repeated files.  查找重复的文件
sudo apt install fdupes
fdupes -r /path/to/dir

# Set huamn language by environment variable to English
# 设置当前Shell下的显示语言 到 English
export LC_ALL=C # C: English

# Set Timezone by environment variable 时区
export TZ=Asia/Shanghai
TZ=Asia/Tokyo date # show tokyo date string

# Ubuntu 17.04 加密主目录后启动很久 (booting bug: encrypted home in 17.04)

# step1 edit /etc/crypttab
# replace 替换这行
cryptswap1 UID=XXXXXXXX /dev/urandom ...
# to 成:
cryptswap1 /swapfile /dev/urandom ...

# step2 edit /etc/fstab
# make /swapfile line as a comment (注释掉/swapfile那行)
# it looks like this:
#/swapfile none swap sw 0 0
/dev/mapper/cryptswap1 none swap sw 0 0
# Then reboot
# ==== DONE ====

# Ubuntu 开机菜单无法显示 (No grub boot menu)
vim /etc/default/grub
# replace
#   GRUB_HIDDEN_TIMEOUT=0
# to:
#   GRUB_HIDDEN_TIMEOUT=
sudo update-grub

# ffmpeg .ts => .mp4
ffmpeg -i input.ts -acodec copy -vcodec copy output.mp4

# Nvidia Graphics Driver 显卡(N卡)驱动
# The easiest way, via ppa. 最简单方便的方法,且能一直更新
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
apt-cache search nvdia # or search in GUI "Software & Updates" 或在系统设置里面"软件与更新"里面选择安装
# current: `sudo apt install nvidia-390`

# Runlevel 运行级别
runlevel #查看当前运行级别
sudo init $level #切换运行级别到$level
# 运行级别说明
#  0 停机，关机
#  1 单用户，无网络连接，不运行守护进程，不允许非超级用户登录
#  2 多用户，无网络连接，不运行守护进程
#  3 多用户，正常启动系统
#  4 用户自定义
#  5 多用户，带图形界面
#  6 重启

# 在 64位 Ubuntu 上安装 VirtualBox/Chrome 等软件时 apt 警告:
# apt note: Skipping acquire of configured file 'main/binary-i386/Packages' as repository
# for example: install VirualBox/Chrome on 64 bit Ubuntu
# you can add `[arch=amd64]` after `deb` in source list file (在deb后面加入 [arch=amd64])
deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main

# 自定义 Grub
sudo add-apt-repository ppa:danielrichter2007/grub-customizer
sudo apt update
sudo apt install grub-customizer

# 随机字符串 Random String
openssl rand -hex 16 # 16是长度

# Split 分割文件
# -b 每个块的大小 -d 按照数字命名每个文件块(否则是字母)
# -a 3 后缀长度为3
split file -b 1k -d path/prefix.
# 这个例子会生成文件 path/prefix.01 path/prefix.02 ...
split file.txt -l 10 part.txt.
# 这个例子会将文本文件分割成每10行一个文件

# Quick HTTP static server (one line command start file HTTP server) 快速开一个静态HTTP服务器
busybox httpd -f -p 8000 # busybox
python -m SimpleHTTPServer 8000 # python 2
python -m http.server 8000 # python 3

# 彻底删除一个文件(覆写,删除)
# Delete file secure/can not recovered
shred -u -z fileName
# -u: remove file after overwriting
# -z: add a zero to hide shredding
# -n 25: over write 25 times random characters (default: 25)

# Compile htop (manual)
sudo apt install libtool libncursesw5-dev;
git clone https://github.com/hishamhm/htop.git;
cd htop;
./autogen.sh && ./configure && make && sudo make install;

# get group of current user
id -g

# enable/disable postfix server
sudo update-rc.d postfix disable/enable

# Start system slowly (开机慢)
## 1. Check if there are any errors in system logs (GUI: gnome-logs)
##    For example, could not found device referenced in /etc/fstab
## 2. echo services elapsed times:
systemd-analyze blame
## 3. reference wiki:
##    https://wiki.archlinux.org/index.php/Improving_performance/Boot_process

# 软件文本渲染出现杂质 (试着降级安装 libfreetype6)
# libfreetype6_2.8-0.2_amd64.deb
http://snapshot.debian.org/package/freetype/2.8-0.2/#libfreetype6_2.8-0.2

# holding back deb packages: prevent upgrade. 阻止某个 deb 包被升级
sudo apt-mark hold <package-name>
sudo apt-mark unhold <package-name>

# 为 apt 设置代理: (Set proxy for apt)
sudo vim /etc/apt/apt.conf
# 添加入下: Append like following statement:
Acquire::http::Proxy "http://user:pass@proxy_host:port";
Acquire::https::Proxy "https://user:pass@proxy_host:port";

# send desktop notification in bash  显示桌面通知
notify-send -i $ICON $TITLE $MESSAGE
