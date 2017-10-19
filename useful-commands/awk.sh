# AWK
# 基本语法
BEGIN {...} /pattern/ {...} END {...}
# 打印<开头, >结尾的行
cat file.txt | awk '/^</ && />$/ {print $0}'
# 打印 行长度大于20 的总所在行号(NR) 文件内行号(FNR) 和 第二块内容
cat file.txt | awk 'length($0) > 20 {print NR FNR $2}'
# 统计行数(类似: wc -l)
cat file.txt | awk 'BEGIN {count=0} {count++} END {print count}'