# Useful Linux Commands

A program for querying useful linux commands in terminal or browser.

It is a command line toolkit and also a querying server.

## Install

``` bash
git clone https://github.com/hangxingliu/useful-linux-commands.git;
cd useful-linux-commands;
sudo npm install --global
```

## Use as a command line toolkit

``` bash
useful-commands keyword ...  # query commands
useful-commands --help       # get help information
```

## Use as a querying server

``` bash
# Way1: launch server directly
useful-commands-server -p ${port_number:10765} -h ${host_name:127.0.0.1}

# Way2: launch server by pm2
cd useful-linux-commands;
pm2 start ecosystem.yaml;

# Then query in browser ...
```

## Query:

``` bash
	# in terminal:
	wget http://domain/keywords -O
	wget http://domain/keywords?color -O
	curl http://domain/filename/keywords?a=5&b=1
	curl http://domain/help
```

## Author

[LiuYue @hangxingliu](https://github.com/hangxingliu)

## License

[GPL-3.0](LICENSE)
