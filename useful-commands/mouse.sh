# Commands about mouse
# Two tools: xbindkeys and imwheel. Remmaping mouse button. Configure mouse wheel.
# Xbindkeys is a program that grab keys and mouse button events in X and starts associated shell command.
# Imwheel is a mouse wheel and stick interpreter for X Windows

# Xbindkeys
# Install Xbindkeys and related utils (安装 Xbindkeys 和相关工具)
sudo apt install xautomation x11-utils xbindkeys
# if xbindkeys is missing in the package management, you can visit its homepage:
# http://www.nongnu.org/xbindkeys

# get your button id: (测试按键数字 button n:)
xev # Click and get information in the output (然后点击指定按键)

# Xbindkeys config file (Xbindkeys 配置文件)
vim ~/.xbindkeysrc
# add: (b:7 means button 7)
"xte 'keydown Control_L' 'keydown Tab' 'keyup Tab' 'keyup Control_L'"
     b:7

# restart xbindkeys
killall xbindkeys
xbindkeys -f ~/.xbindkeysrc

# example .xbindkeysrc (bind mouse side buttons to `HOME` and `END`)
"xte 'keydown Home' 'keyup Home'"
     b:9
"xte 'keydown End' 'keyup End'"
     b:8


# imwheel
# http://imwheel.sourceforge.net/imwheel.1.html
# Actually, "imwheel" can fix mouse random/wired jump bug in browser/editor (Chrome, Visual Studio Code)
# Related Github issue: https://github.com/Microsoft/vscode/issues/28795
# imwheel 这个工具不仅可以定制鼠标按键和速度, 还能修复在浏览器和编辑器中鼠标乱滚的Bug
sudo apt install imwheel

# More documents: (更多资料)
#   https://wiki.archlinux.org/index.php/Imwheel
# Mapping button in config ~/.imwheelrc (在imwheelrc中定义按键映射)
# ID | Name         |  ID | Name
# ---+--------------+-----+--------------
# 1  | Left click   |  2  | Middle click
# 3  | Right click  |     |
# 4  | Wheel up     |  5  | Wheel down
# 6  | Wheel left   |  7  | Wheel right
# 8  | Thumb1       |  9  | Thumb2
# 10 | ExtBt7       |  11 | ExtBt8
# Mapping example: (映射样例)
# Bind Button8 and Button9 to "End" and "Home" for all windows
".*"                  # for all windows (对于所有窗口)
None, Thumb1, End     # Button 8        (Button8 映射到 End 键)
None, Thumb2, Home    # Button 9        (Button9 映射到 Home 键)

