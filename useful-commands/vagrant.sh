# Vagrant Linux 虚拟机
## <Warning!!> 请先装好 VirtualBox 或别的虚拟机软件
## https://www.virtualbox.org/wiki/Linux_Downloads
## VirtualBox: 需要添加源来安装最新的版本
sudo apt install vagrant
# 或者在www.vagrantup.com上下载

## 安装镜像
vagrant box add centos/6

## 启动
cd ${指定目录}
vagrant init ubuntu/xenial64 #ubutnu16.04 64bits
#yakkety: 16.10 zesty: 17.04
# centos/6 centos/7
vagrant up # 下载所需镜像(如果不存在) 启动虚拟机

## 登录
vagrant ssh
ssh root@127.0.0.1 -p 2222 -i private_key_file 
#私钥文件路径可以在 vagrant ssh-config 中看到

## 目录共享
# 虚拟机内的/vagrant/于虚拟机当前目录共享目录

## 端口映射, 在Vagrantfile内的config.vm.box下面加入
config.vm.network "forwarded_port", guest: 80, host: 8080
# (将虚拟机内的80映射到本机的8080端口上)

vagrant reload # 重启虚拟机(修改配置后需要此操作让配置生效)

vagrant suspend ## 挂起虚拟机
vagrant resume ## 恢复挂起到运行

vagrant halt ## 关机
vagrant destory ## 删除虚拟机


## 打包目前的vagrant虚拟机以至于复用
vagrant package # 生成.box文件
vagrant init http://xxx.xx/xxx.box # 下次需要创建这个环境的虚拟机时(URL也可以是路径)
vagrant up

## 卸载 或者包管理器
rm /opt/vagrant -rf
rm /usr/bin/vagrant
 # 用户数据(已下载的镜像boxes, 插件plugins ...)
~/.vagrant.d