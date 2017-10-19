# 安装MYSQL
sudo apt-get update
sudo apt-get install mysql-server mysql-client
sudo mysql_secure_installation
# sudo mysql_install_db

# 登录mysql 示例(本机可以忽略-h,端口3306可以忽略-P)
mysql -u root -h 127.0.0.1 -P 3306 -p # -p表示提示输入密码
# 创建数据库
CREATE DATABASE `DB_NAME` CHARACTER SET utf8 # COLLATE utf8_bin

# MYSQL 允许非本机访问
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
#	bind-address	= 127.0.0.1 # remove this line
# 记得配置root权限

# 升级mysql后本地无法登录了 ERROR 1698 (28000): Access denied
# 因为plugin变成了 auth_socket 所以需要改回来
# 用下面的skip-grant-tables方式启动mysqld_safe
use mysql;
update user set plugin='mysql_native_password' where user='root';

# MYSQL密码恢复

# 关闭现有的MYSQL服务器
sudo systemctl stop mysql # service mysql stop # mysqld
# 启动无授权表模式的MYSQLD
sudo mysqld_safe --skip-grant-tables &
# 如果出现 /var/run/mysqld 相关的socket 错误
sudo mkdir /var/run/mysqld; sudo chown mysql /var/run/mysqld

# 修改User表内的密码
use mysql;
# MYSQL因为版本原因有两种不同的密码列
select user, password, host from user;
select user, authentication_string, host from user;
# 修改密码
update user set authentication_string=PASSWORD("newpassword") where 
	user='root' and host='localhost';
flush privileges;
# 记得重启mysql或者系统

# MYSQL分配权限(包括支持远程访问)
# GRANT 权限 ON 数据库/表 TO 用户/主机 [IDENTIFIED BY/WITH] [WITH GRANT OPTION]
# WITH GRANT OPTION 分配一个 "分配权限" 的权限
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; 
# 创建用户
CREATE USER 'test'@'localhost' IDENTIFIED BY 'password';
# 删除用户
DROP USER 'test'@'localhost';