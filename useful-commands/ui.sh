# Linux desktop environment
# Linux desktop UI environment (Unity and Gnome)

# 系统用户界面相关 User Interface

# 查看是 Wayland 还是 X11
echo $XDG_SESSION_TYPE # x11 / wayland

# 安装 gnome 桌面环境
sudo apt install gnome-shell
# 必装相关工具
sudo apt install gnome-tweak-tool dconf-editor

# 切换显示管理器(display manager) (例如: gdm3 花屏问题 需要切换到 LightDM)
sudo dpkg-reconfigure lightdm
# 安装显示管理器
sudo apt install lightdm gdm3

# Gtk-WARNING **: Unable to locate theme engine in module_path: "adwaita"
sudo apt install gnome-themes-standard

# 让Ubuntu长的更像Mac系统(攒钱买Mac...)

# Unity 主题包:(下载后看README)
https://github.com/B00merang-Project/macOS-Sierra/releases
# GTK/GNOME 主题: (Gnome-OSX) For GTK3
https://www.gnome-look.org/p/1171688/
# GTK主题安装: 在HOME目录下创建一个 .themes 目录 然后复制压缩包内的内容进去

# GTK/GNOME 更加好看的 OSX Shell 主题:
https://www.gnome-look.org/p/1215571/ # macOS High Sierra DARK
https://www.gnome-look.org/p/1213208/ # macOS High Sierra

# 图标包: Unity/GNOME
cd /usr/share/icons/
cd ~/.icons # 不存在就创建一个
git clone https://github.com/keeferrourke/la-capitaine-icon-theme.git
# GTK图标安装: 在HOME目录下创建一个 .icons 目录 然后复制压缩包内的内容进去

# 然后在unity-tweak-tool/gnome-tweak-tool中选择样式和图标集就OK了
# https://www.gnome-look.org

# modify Gnome workspace labels 修改GNOME-WORKSPACE LABELS(工具区的名称)
# dconf-editor /org/gnome/desktop/wm/workspace-names
["Internet", "VM", "Coding", "Terminal"]

# modify Gnome screenshot save directory 修改屏幕截图的保存位置
# dconf-editor /org/gnome/gnome-screenshot/auto-save-directory
file:///path/to/dir # set this value to directory you want and save

# WARNING: if the screenshot pictures are still in original directory, try these:
#  open "system settings" > "Keyboard" > "Keyboard shortcuts"
#  cancel shortcut for "Save a screenshot to Pictures"
#  and create a new shortcut with command is `gnome-screenshot` and keys are "Print"
#  then screenshots are saved into your custom directory after you press "Print"

