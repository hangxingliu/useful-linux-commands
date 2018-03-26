# monitor and usage report
# some commands about system monitor and resource usage report

# 系统启动时间和负载
uptime # (load average: 1min, 5min, 15min)
# load average 的最充分使用是: CPU核心数*3

# 进程(htop需要安装)
top
htop
kill 3940
kill -s TERM 3940
killall http*

# 驱动器使用情况概况
df -h --total # human read-able and total

# 某个目录下的空间占用
du # only folder
du -a # and file
du -c # show total
# du升级版 ncdu 可排序命令行下交互操作
sudo apt install ncdu
ncdu folderName

# 各种系统信息
vmstat -s -S M # -S M 表示以mb为显示单位

# 网络使用情况(需要安装nethogs)
nethogs # 进程实时使用网络带宽情况
# m: 改变显示单位, r: 按接收量排序, s: 按发送量排序
# q: 退出

# iptraf(需要安装iptraf)
sudo iptraf

# netstat
netstat -ntulp # 查看本机所有监听端口
# n: 不解析名称(不会将127.0.0.1变成localhost)
# t: tcp u: udp l: listening p: 程序信息和pid
netstat -a # 查看所有端口信息(包括监听端口和非监听的)

# CentOS7 安装netstat ifconfig
yum install net-tools

# 查看内存信息
free # free -m # mb显示
