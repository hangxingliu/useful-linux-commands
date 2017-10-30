# AWK
# 基本语法
BEGIN {...} /pattern/ {...} END {...}
# 字符串连接使用 空格. 例如: a=(prefix "content" suffix)
# 打印<开头, >结尾的行
cat file.txt | awk '/^</ && />$/ {print $0}'
# 打印 行长度大于20 的总所在行号(NR) 文件内行号(FNR) 和 第二块内容
cat file.txt | awk 'length($0) > 20 {print NR FNR $2}'
# 统计行数(类似: wc -l)
cat file.txt | awk 'BEGIN {count=0} {count++} END {print count}'
# 读写文件;
awk 'BEGIN {file="test.txt";
	while((getline line < file) > 0) print line;
	close(file);}'
# 执行命令
awk 'BEGIN {cmd="ls";
	while((cmd|getline line) > 0) print line;
	close(cmd);}'
# 常用函数
# gsub(regex, replace_to, string) 将string中的regex替换成replace_to
# index(string, substring) 找到string中substring的位置
# length(string) 
# matched = match(string, regexp, result) 匹配string中的regexp (result参数仅gawk支持)
# 例如: if(match("id:123", /id:(\d+), result/)) print(result[1])
