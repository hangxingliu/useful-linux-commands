# lsyncd
# Live Syncing Daemon (实时同步)
# https://github.com/axkibe/lsyncd.git

sudo apt install lsyncd # 截止 2017/10/20 最新版本: 2.2.2
# 命令行用法参考 man lsyncd 或 lsyncd --help

# lsyncd 配置文件 + 服务
# 创建相关文件/文件夹
sudo mkdir /var/log/lsyncd # lsyncd 日志文件所在
sudo mkdir /etc/lsyncd
sudo vim /etc/lsyncd/lsyncd.conf.lua
# 配置内容: (https://axkibe.github.io/lsyncd/manual/config/file/)
settings {
	logfile = "/var/log/lsyncd/lsyncd.log",
	statusFile = "/var/log/lsyncd/lsyncd.status"
}
sync {
--  # rsync ssh mode
	default.rsyncssh,
--  # duration: 1 second; default value: 15 seconds
	delay = 1,
	exclude =  {"*.tmp", ".git"},
	source = "source path",
	host = "user@host", targetdir = "path in host",
	rsync = {
		archive = true, compress = false, whole_file = false,
--		# UserKnownHostsFile: 避免 Host key verification failed 错误
		rsh = "ssh -p 22 -i /home/user/.ssh/id_rsa -o UserKnownHostsFile=/home/user/.ssh/known_hosts"
	}
}
sync {...} ...

# 重启lsyncd服务
sudo service lsyncd restart
# 如果出现异常可以 journalctl 查看日志 或查看/var/log/lsyncd下的日志
