# Virtual Machine
# Commands about virtual machine (VirtualBox, Vagrants ...)

# VirtualBox

# Install: https://www.virtualbox.org/wiki/Linux_Downloads
# 1. add item into sources.list
# 2. download and `apt-key add` keys
# 3. `apt install`

# modify type of disk for VirtualBox (Dynamic to fixed) 调整VirtualBox的vdi磁盘 动态尺寸=>固定尺寸
VBoxManage clonehd [old-VDI] [new-VDI] --variant Standard
VBoxManage clonehd [old-VDI] [new-VDI] --variant Fixed
# resize disk for VirtualBox 调整VirtualBox的vdi磁盘尺寸(记得还要用GParted分配一下空白空间)
VBoxManage  modifyhd [VDI] --resize [Size/Unit:MB]
