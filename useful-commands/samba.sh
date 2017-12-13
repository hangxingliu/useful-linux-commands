# 通过Samba与Windows共享打印机文件夹
sudo apt install samba

sudo vim /etc/samba/smb.conf
# 在最后添加:
[共享文件夹名称]
path = /path/to/share
public = no
writable = yes
valid users = username
# 权限是防止windows创建文件(夹)后自带x权限
create mask = 0644
force create mode = 0644
directory mask = 0755
force directory mode = 0755
available = yes

# 添加samba访问用户
sudo groupadd samba-remote-group
sudo useradd samba-user1 -g samba-remote-group --no-create-home -d /dev/null # -d /dev/null: no home

# 给指定samba用户设置密码
sudo touch /etc/samba/smbpasswd
sudo smbpasswd -a username

# 启动samba服务器
sudo /etc/init.d/samba restart

# 在别的电脑挂载Samba
sudo apt install cifs-utils
mount -t cifs -o username="Username",password="Password" //IP/share /mnt/smb
umount /mnt/smb
