# cURL
# useful cURL snippets
# cURL is a command line tool for getting or sending files using URL syntax.
# (In fact, `HTTPie` is another good choice about command line HTTP client)

# 自动跳转(301/302...)
curl -L $URL
# 在返回内容前面 显示 HTTP Response 头部信息
curl -i $URL
# 显示详细的通信过程 包括 Request 信息 和 Response
curl -v $URL
curl --trace output.log $URL # 更加详细

# 发送表单(application/x-www-form-urlencoded)
# --data => -d
curl -X POST --data "k1=v1" --data "k2=v2" $URL
curl -X POST --data-urlencode "k1=v1" --data-urlencode "k2=v2" $URL #自带URLEncode
# 文件上传表单(multipart/form-data)
curl --form fieldName=@localfilename --form fieldName2=value $URL

# header, Cookies, Referer 和 UserAgent
# --header => -H
curl --header "Content-Type:..." --cookie $COOKIES \
	--referer $REFERER --user-agent $UA $URL
# header扩展 断点续传 下载指定范围
curl --header "Range:bytes=2345-2347" $URL

# 保存 Set-Cookie 和 使用 Set-Cookie
curl -c fileName $URL # 保存服务器发来的Cookies
curl -b fileName $URL # 从本地文件加载Cookies发送到服务器

# HTTP 验证
curl --user name:password $URL

# 发送JSON数据(POST)
curl -X POST -H "Content-Type: application/json" -d '{"id":1}' $URL
curl -X POST -H "Content-Type: application/json" -d "@file.json" $URL
