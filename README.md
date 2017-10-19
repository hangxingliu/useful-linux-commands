# Useful Linux Commands

You can quickly query useful linux commands in terminal or browser.

You can install it in local or remote server

## Install in local

``` bash
	sudo npm i -g
	# And then You can use it 
	useful-commands --help
```

## Install in server

``` bash
	sudo npm i
	# Way1: just run
	npm run web -- -p ${port_number: 10765} -h ${host_name: 127.0.0.1}
	# sudo npm run web -- -p 80

	# Way2: pm2
	pm2 start ecosystem.yaml
```

### Query:

``` bash
	# in terminal:
	wget http://domain/keywords -O
	wget http://domain/keywords?color -O
	curl http://domain/filename/keywords?a=5&b=1
	curl http://domain/help

```