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

# SSH Tunnel (Proxy/Reverse Proxy) SSH隧道(代理/反向代理)
# 3 types 三种类型

# Type 1: Tunnelling with Local port forwarding (本地端口转发)
# Example: Forward server listening at 80 on server to local port 8080
# 将服务器上的80端口的服务代理到本地的8080端口上
ssh -N -L 8080:127.0.0.1:80 root@hostname # -N: Do not execute remote command (don't open bash/zsh ...)
# Then you can visit http://127.0.0.1:8080 at local computer

# Example2: connect Redis on server via SSH Tunnel
ssh -NL 6379:127.0.0.1:6379 root@hostname
redis-cli

# Type 2: Reverse Tunnelling with remote port forwarding (反向端口转发/远程端口转发)
# Example: Visit local file via local FTP(port: 21) on remote server at 8021 port
# 让服务器上通过8021端口访问本地机器上的FTP(端口21)来读写本机文件
ssh -N -R 8021:127.0.0.1:21 root@hostname

# Example2: 打洞,通过远程服务器访问本地(LAN)计算机上的HTTP服务
# 本地执行: (假设本地HTTP服务的端口是 8080)
ssh -R 8081:127.0.0.1:8080 root@hostname # local 8080 ==> remote 127.0.0.1:8081
# 远端执行: (假设远端暴露到公网的端口是 80)
sudo ssh -g -L 80:127.0.0.1:8081 127.0.0.1 # 127.0.0.1:8081 ==> xx.xx.xx.xx:80 (公网IP)
# Tip: -g  Allows remote hosts to connect to local forwarded ports.

# Type 3: Dynamic Port Forwarding (动态端口转发)
# Example: set up proxy server via SSH at local port 1090 (通过SSH建立代理服务器,监听本地端口1090)
ssh -N -D 127.0.0.1:1090 root@hostname
# Then you set SOCKS proxy in your browser/system as "localhost:1090"


# mount ssh filesystem (SSH之间传递文件, sshfs挂载方法)
sudo apt install sshfs
mkdir -p /path/to/mount2here
sshfs root@hostname:/remote/path/to /path/to/mount2here

# sshfs: keep connection in bad network 在差网络状况下使用sshfs
sshfs hostname:/path/to /path/to -o 'reconnect,ServerAliveInterval=15,ServerAliveCountMax=3';
# -o : set options
# reconnect: reconnect when connection is broken (链接断开后重新连接)
# ServerAliveInterval=15: send a keep-alive packet to server each 15s. (每隔15发送一次心跳包给服务器)
# ServerAliveCountMax=3: disconnect if loss 3 keep-alive packets. (如果心跳包丢失了3次, 则主动断开连接)

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
