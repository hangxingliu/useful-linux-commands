# BASH
# bash脚本if测试语句
if [[  test_expression ]]; then
	#...
else
	#...
fi
# bash脚本循环样例
for (( c=1; c<=5; c++ )); do  
   echo $c;
done
str="a b c"
for part in $str; do
	echo $part
done
# while
while [[  test_expression ]]; do
	#...
done

# 获取字符串变量长度 strlen 用 # 号
STR="hello"; echo "${#STR}"

# 使用数组
arr=("item0" 2 "hello3")
echo ${arr[2]} # hello3
echo ${#arr[*]} # 数组长度: 3

# 测试字符串
[ "$1" = "--debug" ] # 第一个参数是否为--debug (比较符: != < >)
[ -n "$1" ] # 第一个参数字符串长度是否大于0,  (-z 是否为0)

# 测试目录
[ -d $INPUT_PATH ] #是否存在且为目录(-e: 是否存在  -f: 是否存在且为文件)
#(-s: 存在且非空 -r: 可读  -w: 可写  -x: 可执行  -O: 是否归当前用户所有)

# AND OR
[ ... ] && [ ... ]
[ ... ] || [ ... ]

# Iterate arguments 迭代传入的参数
for argument in "$@"; do
    echo "$argument";
done

# 给BASH脚本记时 先设置内置变量: SECONDS=0 脚本结束时读 SECONDS 的值就OK了 

# 神奇的 BASH 字符串分割:
# 样例文件名: index.d.ts
# 1. % 操作符: 字符串变量%通配符 或 字符串变量%%通配符 (%%: 是贪婪删除)
#   匹配删除方向:  前(左) <<<=== 后(右)
echo "${FILENAME%.*}" # index.d
echo "${FILENAME%%.*}" # index
# 2. # 操作符: 字符串变量#通配符 或 字符串变量##通配符 (##: 是贪婪删除)
#   匹配删除方向:  前(左) ===>>> 后(右)
echo "${FILENAME#*.}" # d.ts
echo "${FILENAME##*.}" # ts

