# Log
# Some commands about system log, server log or other logs


# browse SSH invalid login log (查询SSH登录失败记录)
cat /var/log/auth.log | grep 'sshd.*Invalid' # Ubuntu
cat /var/log/secure | grep 'sshd.*Invalid' # CentOS

# clean log of command `last` (SSH login/system boot)
# 清除上次SSH登录/开机启动的日志
>/var/log/wtmp
>/var/log/btmp


# GoAccess: analyze HTTP server log (Nginx, Apache ...)

# Install: (you could install it by package management too 当然包管理安装也OK)
# latest installation: https://github.com/allinurl/goaccess#installation
wget https://tar.goaccess.io/goaccess-1.2.tar.gz;
tar -xzvf goaccess-1.2.tar.gz;
cd goaccess-1.2/;
# configure dependencies: 相关依赖:
# --enable-utf8:   sudo apt install libncursesw5-dev
./configure --enable-utf8;
make && sudo make install;

# if you want use GeoIP for goaccess (IP address to country name)
# 安装IP位置信息模块
./configure --enable-utf8 --enable-geoip=legacy
# remember install (记得安装): https://github.com/maxmind/geoip-api-c

# Usage 使用GoAccess (https://github.com/allinurl/goaccess#usage--examples)
# example: multiple log files from Nginx (included compressed)
# zcat: display gz compressed content or normal content(-f)
zcat -f access.log* | goaccess --log-format=COMBINED # -o report.html


# logrotate (automatically split log 自动切割轮循日志)
sudo apt install logrotate cron # cron is used for it for automatic

## logrotate config for Nginx: /etc/logrotate.d/nginx
daily # split log file daily. (weekly, yearly ...) 每天切割一次日志
rotate 14 # only storage 14 splitted log files. delete older log files. 仅保留14个日志文件
compress # compress older log # gz压缩旧日志
dateext # name older olg files with date but not number # 用日期给旧日志命名

# apply modified config for logratote (让修改后的配置生效)
logrotate /etc/logrotate.d/nginx
