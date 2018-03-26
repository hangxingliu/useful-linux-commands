# Qt
# commands about Qt and QtCreator

# 下载页面
https://info.qt.io/download-qt-for-application-development

# Config Files: 配置文件所在位置
cd "$HOME/.config/QtProject/qtcreator"
cat "QtCreator.ini"
# Write To Myself: 写给自己的
# Qt Creator doesn't support line-height
# Remeber install monaco-msyhl-085h font
# A font mixed from monaco and microsoft yahei light and scale 0.85


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
# OR (5.40.0 released on 2017-11-11)
wget https://github.com/KDE/extra-cmake-modules/archive/v5.40.0.tar.gz
# Uncompress 解压...
cmake . && make && sudo make install
# Compile 编译 (需要安装完整的Qt)
export PATH="/path/to/Qt5.9.1/5.9.1/gcc_64/bin":$PATH
git clone git@github.com:fcitx/fcitx-qt5.git
cd fcitx-qt5
cmake . && make
# 复制生成的so文件到QtCreator对应目录下去
cp ./platforminputcontexts/libfcitxplatforminputcontextplugin.so ...


# Install CppChecker (Lint tools for cpp)
# Official repository:
https://github.com/danmar/cppcheck
# (1.81 released on 2017-10-08)
wget https://github.com/danmar/cppcheck/releases/download/1.81/cppcheck-1.81.tar.gz
# Uncompress ...
make
# (Optional)  Compile GUI 编译界面 (需要安装完整的Qt)
export PATH="/path/to/Qt5.9.1/5.9.1/gcc_64/bin":$PATH
cd gui && qmake HAVE_QCHART=yes && make

# Integrate to Qt Creator
# Way1. Add external tools... 添加 外部工具
# Menu -> tools -> external -> configure... -> Add
# Description: CppCheck
# Executable: /path/to/cppcheck
# Arguments: --enable-all --style %{CurrentProject:Path}
# Working directory: %{CurrentProject:Path}

# Way2. Install qtc-cppcheck plugin
# Official repository:
https://github.com/OneMoreGres/qtc-cppcheck
# (4.3.0 released on 2017-05-26) (Install 4.4.0 into QtCreator 4.3.1 will be failed!)
wget https://github.com/OneMoreGres/qtc-cppcheck/releases/download/4.3.0/QtcCppcheck-4.3.0-linux-x64.tar.gz
# Compress tar.gz file to QtCreator Path. For example:
/path/to/Qt5.9.1/Tools/QtCreator
# Restart Qt Creator just OK!
