# Qt/QtCreator 相关

# 下载页面
https://info.qt.io/download-qt-for-application-development

# Qt Creator 无法用中文输入法的故障
# 首先安装必要组件
sudo apt install fcitx-libs-qt fcitx-libs-qt5 fcitx-frontend-qt5 
# 思路: 能用现有的so文件解决就用现有的, 不能解决就手动编译
# 现有的so文件大致位置:
cp /usr/lib/x86_64-linux-gnu/qt5/plugins/platforminputcontexts/libfcitxplatforminputcontextplugin.so \
	~/QtCreator安装位置/lib/Qt/plugins/platforminputcontexts/

# 手动编译:
sudo apt install cmake fcitx-libs-dev 
sudo apt install libgl1-mesa-dev libglu1-mesa-dev libxkbcommon-dev bison
# 编译 extra-cmake-modules
wget https://launchpad.net/ubuntu/+archive/primary/+files/extra-cmake-modules_1.4.0.orig.tar.xz
# 解压...
cmake && make && sudo make install

# 编译 (需要安装完整的Qt)
export PATH="/path/to/Qt5.9.1/5.9.1/gcc_64/bin":$PATH
git clone git@github.com:fcitx/fcitx-qt5.git
cd fcitx-qt5
cmake . && make
# 复制生成的so文件到QtCreator对应目录下去