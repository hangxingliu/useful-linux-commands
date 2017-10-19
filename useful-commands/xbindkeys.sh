# 用 xbindkeys 定制鼠标上的按键
# 例如: 将鼠标上的两个方向键中的一个设置为 Ctrl+Tab

# 安装相关工具
sudo apt install xautomation x11-utils xbindkeys
# 如果xbindkeys不存在于apt中, 就去它的官网下载
# http://www.nongnu.org/xbindkeys
# 测试按键数字 button n?
xev # 然后点击指定按键

# 创建配置文件
vim ~/.xbindkeysrc
# 加入: (其中的b:7表示button 7)
"xte 'keydown Control_L' 'keydown Tab' 'keyup Tab' 'keyup Control_L'"
     b:7
# 重启xbindkeys
killall xbindkeys
xbindkeys -f ~/.xbindkeysrc
