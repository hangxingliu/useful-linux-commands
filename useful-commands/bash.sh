# Bash
# Bash basic statement and useful bash snippets
# (Bash is a Unix shell and command language written by Brian Fox.)

# if condition statement in BASH (BASH 脚本 if 语句)
if [[  test_expression ]]; then
	#...
else
	#...
fi

# loop/for statments in BASH (BASH脚本循环样例)
for (( c=1; c<=5; c++ )); do
   echo $c;
done

str="a b c"
for part in $str; do
	echo $part;
done

# loop/while
while [[  test_expression ]]; do
	#...
done

# case/switch statments in BASH (BASH脚本中的 case 样例 (switch))
case "$argument" in
	-h);& --help)  echo "help" ;; # ;; means `break` (;;等同于break)
	-f*);& --file=*)  echo "file argument: $argument" ;;
	*) echo "unknown argument: $argument" ;; # default
esac

# length of string (获取字符串变量长度 strlen 用 # 号)
STR="hello"; echo "${#STR}"

# array (使用数组)
arr=("item0" 2 "hello3")
echo ${arr[2]}   # "hello3"  3rd element of array (数组的第3个元素))
echo ${#arr[@]}  # "3"       length of array (数组长度)

# array slice (数组切片, 截取)
A=( foo bar tiny large )
B=("${A[@]:1:2}") # bar tiny
C=("${A[@]:1}")   # bar tiny large
argument_without_first=("${@:2}")

# test string (测试字符串)
[ "$1" = "--debug" ] # 第一个参数是否为--debug (比较符: != < >)
[ -n "$1" ] # 第一个参数字符串长度是否大于0,  (-z 是否为0)

# test is directory (测试目录)
[ -d $INPUT_PATH ] #是否存在且为目录(-e: 是否存在  -f: 是否存在且为文件)
#(-s: 存在且非空 -r: 可读  -w: 可写  -x: 可执行  -O: 是否归当前用户所有)

# AND OR
[ ... ] && [ ... ]
[ ... ] || [ ... ]

# Iterate arguments (迭代传入的参数)
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

# Useful one-liner bash: get directory of current script located in.
# WARNING! bash source file could not a symbol link
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Useful bash snippet: Get directory of current script located in.
# 获得此BASH脚本文件所在的目录 (代码片段)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )";
	SOURCE="$(readlink "$SOURCE")"; [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE";
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
# From: https://stackoverflow.com/questions/59895/

# Terminal Color Cheat Sheet: 颜色速查
# 8colors => BgValue = FgValue + 10;
# FgValues: Black:30 Red:31 Green:32 Yellow:33 Blue:34 Magenta:35(洋红) Cyan:36(青) White:37 Gray:90
# Reset:0 Bold:1 Italic:3 Underline:4 DotLine:5 Revert:7 Hide:8
# For Example: starts with `\x1b[`  ends with `m`
GREEN_BOLD="\x1b[1;32m"; RESET="\x1b[0m"; GREY_BG="\x1b[100m"
echo -e "$GREEN_BOLD text $RESET $GREY_BG greyBg $RESET";
