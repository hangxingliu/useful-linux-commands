# SSH (encrypted home directory)
# commands about how to use SSH server with user who encrypted his home directory

# 在HOME目录加密了的情况下 使用 公私钥 SSH登录
#  方法: 转移用户 authorized_keys 文件, 配置.profile
#  WARNING: 下面假设用户名为 your_username

# 将 authorized_keys 转移到用户HOME目录外, 并链接回去 再配置sshd_config
sudo mkdir /home/.ssh
sudo mv ~/.ssh/authorized_keys /home/.ssh/your_username
ln -s /home/.ssh/your_username ~/.ssh/authorized_keys
sudo vim /etc/ssh/sshd_config
# 编辑:
AuthorizedKeysFile      /home/.ssh/%u

# 重启
sudo reboot

# 配置.profile 让用户登陆时自动解锁HOME目录
# 使用SSH或终端登录进指定用户
sudo vim ~/.profile # 不要忘记 sudo
# 写入:
ecryptfs-mount-private
cd /home/your_username
# 然后把原来用户的.profile内容抄到这个文件下面
# 类似这样的:
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
# ...

# 最后保存, 重新登录就会发现提示输入挂载HOME目录的密码了
# 然后就能自动挂载HOME目录了
