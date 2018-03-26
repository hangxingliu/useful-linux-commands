# Vagrant
# manage virtual machies by vagrant command line toolkit

## <Warning!!> 请先装好 VirtualBox 或别的虚拟机软件
## https://www.virtualbox.org/wiki/Linux_Downloads
## VirtualBox: 需要添加源来安装最新的版本
sudo apt install vagrant
# 或者在www.vagrantup.com上下载

## 安装镜像
vagrant box add centos/6

## Move .vagrant.d (改变.vagrant.d目录的位置)
export VAGRANT_HOME=/path/to/vagrant; # in .bashrc

## 启动
cd /path/to/vm
vagrant init ubuntu/xenial64 #ubutnu16.04 64bits
#yakkety: 16.10 zesty: 17.04
# centos/6 centos/7
vagrant up # 下载所需镜像(如果不存在) 启动虚拟机

## 登录
vagrant ssh
ssh root@127.0.0.1 -p 2222 -i private_key_file
### There maybe exist permission problem in NTFS lead to ssh login failed
### (NTFS可能导致权限问题,无法正常SSH登录)
### 私钥文件路径可以在 `vagrant ssh-config` 中看到

## 目录共享
### 1. 虚拟机内的/vagrant/ 相当与 Vagrantfile所在的目录
### 2. 在Vagrantfile中可以如下配置:
config.vm.synced_folder "~/share_to_vagrant_vm", "/vagrant_share"

## Vagrantfile Configurations: 配置
### 端口映射, 在config.vm.box下面加入
config.vm.network "forwarded_port", guest: 80, host: 8080
### 设置名字
config.vm.hostname="ubuntu"
### 禁止每次 vagrant up 都检查是否最新版(GFW)
config.vm.box_check_update = false
# (将虚拟机内的80映射到本机的8080端口上)
### 针对VirtualBox的配置
config.vm.provider "virtualbox" do |v|
	v.name = "vm_name"
	v.memory = 1024
	v.cpus = 2
end

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
