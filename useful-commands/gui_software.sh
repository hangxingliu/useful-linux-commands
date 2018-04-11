# GUI softwares for Linux
# commands about how to install some GUI softwares on Linux

# Multi-media player (VLC)
# install vlc media player in ubuntu
# libavcodec-extra is support streaming or transcoding
sudo apt-get install vlc browser-plugin-vlc libavcodec-extra

# 屏幕Gif录制工具
# Screen GIF capture (Peek)
sudo add-apt-repository ppa:peek-developers/stable
sudo apt update && sudo apt install peek

# Screen color picker 屏幕取色工具
sudo apt install gpick

# Add context menu(right-click) into file manager(Nautilus)
# Ubuntu文件管理器右键菜单编辑
sudo apt install nautilus-actions

# Install Google Chrome (non-opensource)
# 1. Add key
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
# 2. Set repository
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
# 3. Install
sudo apt update
sudo apt install google-chrome-stable

# Install Chromium (OpenSource)
sudo apt install -y chromium-browser
# Optional: Install flash plugin for Chromium
sudo apt install -y pepperflashplugin-nonfree
sudo update-pepperflashplugin-nonfree --install

# focus-control: set focus follow mouse/sloppy/click
gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy'
gsettings set org.gnome.desktop.wm.preferences focus-mode 'mouse'
# or click to get focus: (by default)
gsettings set org.gnome.desktop.wm.preferences focus-mode 'click'
