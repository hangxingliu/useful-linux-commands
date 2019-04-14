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

# Execute command 执行命令
awk 'BEGIN {cmd="ls";
	while((cmd|getline line) > 0) print line;
	close(cmd);}'

# String operation example 字符串操作样例
awk '{
	gsub("name", "Steve", $0);   # replace "name" to "Steve" in the line
	gsub(/\s/, " ", $0);         # replace empty string (regex) to space char in the line
	print index("abcdefg", "b"); # result: 2
	print length("abc");         # result: 3
	len = split("ab--cd--efg", part, "--");    # len is 3
	print part[2];                             # result: "cd"
	len = match("a-b-cde-f", /(\w+)/, part);   # len is 4
	print part[3];                             # result: "cde"

}'
