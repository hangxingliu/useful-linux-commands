# Delopy By PM2

## 1. Install Node.js environment

[Installing Node.js via package manager](https://nodejs.org/en/download/package-manager/)

Example for Ubuntu/Debian

``` bash
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
```

## 2. Add user for this querying server

[PM2](http://pm2.keymetrics.io)   
[PM2 Startup Script](http://pm2.keymetrics.io/docs/usage/startup/#disabling-startup-system)

``` bash
# `node-app` is a example username in here
sudo useradd node-app --create-home --user-group -d /home/node-app;
sudo passwd node-app # set up password for user `node-app`
```

## 3. Install PM2 and setup startup with system

``` bash
sudo npm install pm2 -g
pm2 startup --user node-app --hp /home/node-app # set pm2 startup with user `node-app` and profiles are located in directory `/home/node-app/.pm2`
```

## 4. Log into user `node-app` and resolve this repo

``` bash
su - node-app
git clone https://github.com/hangxingliu/useful-linux-commands.git
cd useful-linux-commands
npm install --production
```

## 5. Copy launch configuration and modify it

``` bash
cp ecosystem.prod.yaml my.ecosystem.prod.yaml;

# modify it:
# you can add `PORT`/`SEO_URL` envrionment variables into it under field `env`
vim my.ecosystem.prod.yaml;
```


## 6. Launch this querying server and save them for auto startup

``` bash
pm2 start my.ecosystem.prod.yaml
pm2 save # save current state to pm2 profile for startup this server automatically
```
