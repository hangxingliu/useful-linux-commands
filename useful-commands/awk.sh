# AWK
# AWK get started and useful AWK scripts (AWK: AWK is a programming language designed for text processing
# and typically used as a data extraction and reporting tool.)

# Basic syntax example (基本语法演示)
BEGIN {...} /pattern/ {...} END {...}

# string concat by blank character (字符串连接使用 空格)
awk 'BEGIN { strHelloWorld="Hello" "World"; }'

# Print line starts with '<' and ends with '>' (打印 < 开头 并且以 > 结尾的行)
cat file.txt | awk '/^</ && />$/ {print $0}'

# Print line number, line number in file and line that length of line more than 20
# 打印 行长度大于20 的总所在行号(NR) 文件内行号(FNR) 和 第二块内容
cat file.txt | awk 'length($0) > 20 {print NR FNR $2}'

# Count line numbers 统计行数(类似: wc -l)
cat file.txt | awk 'BEGIN {count=0} {count++} END {print count}'

# Read/Write File 读写文件;
awk 'BEGIN {file="test.txt";
	while((getline line < file) > 0) print line;
	close(file);}'

# Execute command执行命令
awk 'BEGIN {cmd="ls";
	while((cmd|getline line) > 0) print line;
	close(cmd);}'

# Useful commands 常用函数
# gsub(regex, replace_to, string) # replace `replace` to `replace_to` in `string`. 将string中的regex替换成replace_to
# index(string, substring) # find the index of `substring` in `string`. 找到string中substring的位置
# length(string)
# matched = match(string, regexp, result) # match regexp in string (result be only supported gawk). 匹配string中的regexp (result参数仅gawk支持)
# 例如: if(match("id:123", /id:(\d+), result/)) print(result[1])
