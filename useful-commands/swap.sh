# 创建swap

# 创建swap文件(2048mb)
dd if=/dev/zero of=/swapfile count=2048 bs=1M
chmod 600 /swapfile
# 设置swap
mkswap /swapfile
#启用
swapon /swapfile
# 查看一下
free -m
# 开机自启
vim /etc/fstab
# add line:
/swapfile   none    swap    sw    0   0
