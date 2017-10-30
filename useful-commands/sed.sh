# SED
# SED的处理单位为 一行
sed '4d' # 删除第4行
sed '2,4d' # 删除第2到第4行

# 替换regexp到replace_to
# s后面的第一个字符表示分界符(可以使任意字符)
# g:替换行内全部 i:忽略大小写 ...
sed 's:regexp:replace_to:g' 
sed 's/regexp/replace_to/gi'
sed 's/regexp/replace_to/'
