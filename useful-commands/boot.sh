# Boot
# Commands about system boot (grub)

# Ubuntu 开机菜单无法显示
# The grub menu is not displayed.
vim /etc/default/grub
# replace
#   GRUB_HIDDEN_TIMEOUT=0
# to:
#   GRUB_HIDDEN_TIMEOUT=
sudo update-grub

# 自定义 Grub
# Customize grub menu
sudo add-apt-repository ppa:danielrichter2007/grub-customizer
sudo apt update
sudo apt install grub-customizer

# Add Windows booting Item to grub menu quickly. (快速添加 Windows 到 Grub 启动菜单)
sudo os-prober # check is any OS can be probed.
sudo update-grub # update Grub menu.
