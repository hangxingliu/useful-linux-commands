# inotify
# a filesystem events listening tools. some commands about inotifywait

# Install
sudo apt install inotify-tools

# Block wait until file is modified (阻塞等待一个文件被修改了)
inotifywait -e modify file1 file2 ... # -e: --event

# Continuous watch filesystem events (持续监听文件系统变化)
inotifywait -m -r /path/to/dir -e 'modify,delete' # -m: --monitor (continuous) -r: --recursive
# and you can use option `--exclude <pattern>`

# inotify events (inotify 事件)
# access, create, modify, close, open, delete, move
# attrib, close_write, close_nowrite, moved_to, moved_from, move_self, delete_self, unmount

# Error ENOSPC, because too many files to be watched. (文件过多无法监听的错误)
# Solution: Increase maximum of watcher (增大最大值)
sudo vim /etc/sysctl.conf
# append:
#  fs.inotify.max_user_watches=524288
# and save it, then
sudo sysctl -p;
# you can get the current maximum limit by command:
cat /proc/sys/fs/inotify/max_user_watches
