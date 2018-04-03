# SSH
# generate key pair, connect by SSH and more commands about SSH

ssh-keygen -t rsa # create RSA key pair: public/private keys. 创建公私钥对
ssh-copy-id xxx@hostname # copy public key to server. 复制公钥到服务器
ssh-copy-id -i ~/.ssh/id_rsa.pub xx@hostname
# or append content of public key into ~/.ssh/authorized_keys on server
# 或者如下将公钥  追加  到服务器的~/.ssh/authorized_keys内

ssh -i xxx/id_rsa xxx@xx # use special ssh private key 使用指定私钥登录

# get ssh public key fingerpoint 获得SSH公钥的 fingerpoint 指纹
ssh-keygen -lvf ~/.ssh/id_rsa.pub
# It looks like: 4096 SHA256://Unxhus.... xxx@mail.com (RSA)
ssh-keygen -E md5 -lvf ~/.ssh/id_rsa.pub
# It looks like: 4096 MD5://f0:23:5d... xxx@mail.com (RSA)

# Remove fingerpoint in file known_hosts
ssh-keygen -R hostname

# SSH permissions
chmod 700 ~/.ssh
chmod 644 ~/.ssh/id_rsa.pub  # public key  -rw-r--r--
chmod 600 ~/.ssh/id_rsa      # private key -rw-------
chmod 644 ~/.ssh/known_hosts
chmod 640 ~/.ssh/authorized_keys

# Add config to /etc/ssh/ssh_config
# Config:
	UserKnownHostsFile /dev/null
	StrictHostKeyChecking no

# add this config could keep alive(100s发一次心跳包给服务器)
	ServerAliveInterval 100

# conifg ssh server SSH 服务器配置:
vim /etc/ssh/sshd_config
# disallow use SSH by password but only use private key (关闭密码登录SSH, 只允许公私钥登录, 更加安全)
	PasswordAuthentication no # 禁止使用密码登录
	PermitRootLogin without-password
	# root账户通过SSH登录时只能用公私钥方式登录
	# 上一句配置可以设置成 no (意味着不能直接ssh root@hostname登录)
	# 而是需要 ssh otherUser@hostname 登录后 sudo -i 进入
# change port of SSH server (更改SSH端口)
	Port xxxx # 在sshd_config中

# restart ssh server 配置更改后 重启SSH
service sshd restart #CentOS/Fedora/Redhat
service ssh restart #Ubuntu/Debian

# 注意: 如果系统配置了HOME目录加密
# 需要使用公私钥登录 SSH 则参阅: -fssh_enc
useful-commands ssh -fssh_enc

# 配置fail2ban的爆破攻击
TODO...

# proxy vis ssh 通过SSH进行代理
ssh -N -D 127.0.0.1:1090 root@hostname

# mount ssh filesystem (SSH之间传递文件, sshfs挂载方法)
sudo apt install sshfs
mkdir -p /path/to/mount2here
sshfs root@hostname:/remote/path/to /path/to/mount2here
# unmout sshfs
fusermount -u /path/to/mount2here

# SSH rsync
rsync -avz -e ssh --progress root@hostname:/path/to/remote  /path/to/

# use Git without password via SSH (SSH 免密访问Git)
ssh-keygen -t rsa -b 4096 -C "you@mail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# verify/view ssh private keys 验证 SSH 私钥密码/查看 SSH 私钥
ssh-keygen -yf ~/.ssh/id_rsa

# install ssh server for ubuntu desktop. 给桌面版电脑安装SSH服务器
sudo apt-get install openssh-server

# force use only password to login ssh 强制密码登录
ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no user@address
