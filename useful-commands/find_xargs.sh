# find 命令 和 xargs 命令

find /path/to -maxdepth 2 -name "*.js" -type f -size -2M
# 说明: -maxdepth: 最深查找层级 -name 文件名限制 -iname 不分大小写的文件名限制
# -type f 限制必须是文件. d: 目录 l:符号链接
# -size 限制文件大小. -2M: 小于2MB +10k: 大于10kb 

find /path/to ! -type d \( -iname "*.js" -o -iname "*.ts" \)
# 说明: ! 表示反义 NOT.  -o 表示 OR 或 记得用括号的时候要转义 ( => \(
# 上述命令查找 /path/to 下的所有js和ts非目录的(文件, 连接, 块设备...)

# 查找文件 通过时间限制
-atime -7 # 7天内访问过的
-mtime +7 # 7天或更早前 修改过的
-ctime +7 # 7天或更早前 修改过元数据(权限...)的
-amin -mmin -cmin # 对应上述三个条件的 以分钟为单位的限制

# 文件权限限制
-perm 644 # 权限为644的
-user username # username 用户拥有的

# 配合xargs使用 (打印所有js文件的第一行)
find . -type f -iname "*.js" | xargs -I xx head xx -n1

# 递归统计文件数量
find path/to/folder -type f | wc -l