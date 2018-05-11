# HTTPie
# Some useful snippet about HTTPie, a cURL replacement.
# (HTTPie is a command line HTTP client that will make you smile.)


# Install HTTPie 安装 HTTPie
sudo apt install httpie
# or install via pip (latest version) 或者通过pip安装最新版本
pip install --upgrade httpie

# Querystring:
http github.com/search q==httpie type==Repositories

# Custom Request Headers 自定义请求头
http httgbin.org/get 'User-Agent: Changed' 'X-Test-Header: Test Header'

# HTTP GET
http -v httpie.org # `-v`` for details info included request headers (-v 可以显示详细信息包括请求头)

# HTTP POST

# 1. application/x-www-form-urlencoded; charset=utf-8
http -f POST httpbin.org/post key=value key2=value2 # -f: as form 表单形式

# 2. application/json (JSON by default, JSON是默认请求表单类型)
http POST httpbin.org/post jsonKey=value key=stringValue key2:=100 key3:='["hello","world"]'

# 3. multipart/form-data
http -f POST httpbin.org/post key=value fileName@localFilePath

# HTTP Authentication (HTTP 认证)
http -a username:password example.org
http -a user example.org # And input password later 稍后输入密码
http -A digest -a username:password exmaple.org # Digest auth HTTP摘要认证
