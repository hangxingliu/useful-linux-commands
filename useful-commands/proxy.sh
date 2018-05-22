# Network Proxy
# some useful network proxy software and commands for Linux

# Shadowsocks

# (Depercated: version is too old) In Ubuntu just apt install:
sudo apt install shadowsocks-libev

# WARNING!!! If you build shadowsocks-libev by yourself to overwrite apt package
apt purge --autoremove shadowsocks-libev # please exexcute this command firstly

# Shadowsocks dependencies in Centos 7
yum update
yum install epel-release -y
yum install gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto udns-devel libev-devel -y

# Shadowsocks dependencies in Ubuntu
sudo apt update
sudo apt install --no-install-recommends \
    build-essential autoconf libtool \
    libssl-dev gawk debhelper dh-systemd init-system-helpers pkg-config asciidoc \
    xmlto apg libpcre3-dev zlib1g-dev libev-dev libudns-dev libsodium-dev libmbedtls-dev libc-ares-dev automake
# install asciidoc, xmlto must remember: --no-install-recommends
# else you will install some very huge package. such as texlive-latex-extra-doc

## install ss
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
./autogen.sh
./configure
# if configure failed because asciidoc
# you can add option: "--disable-documentation" follow ./configure
# or sudo apt install asciidoc
make && sudo make install


# if make failed like " ... undefined reference to  ..."
# And you build and install libsodium/mbedtls like above by yourself
# You should ./configure again like this:
undefined reference to
./configure --with-sodium-include=/usr/local/include \
    --with-sodium-lib=/usr/local/lib \
    --with-mbedtls-include=/usr/local/include \
    --with-mbedtls-lib=/usr/local/lib

## if install failed: "mbed TLS libraries not found"
wget https://tls.mbed.org/download/mbedtls-2.4.2-gpl.tgz
# or latest file could be find in https://tls.mbed.org/
tar zxvf mbedtls-2.4.2-gpl.tgz
cd mbedtls-2.4.2-gpl
make && sudo make install

## fix libsodium.so bug
sudo -i
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
sudo ldconfig

## Usage
ss-server -c config.json
## Usage in background
ss-server -c config.json -f ss_is_running.pid

## Example Config
{
  "server":"server_ip",
  "server_port":8888,
  "local_port":1080,
  "password":"password",
  "timeout":600,
  "method":"chacha20-ietf-poly1305"
}

# Privoxy (forward socks5 proxy to HTTP proxy)

sudo apt install privoxy
sudo vim /etc/privoxy/config
# # Add a line in the bottom 在最后添加一行
# # IMPORTANT!!! (There is a dot character '.' in the end, means this is the last forward)
# # 重要!!! (下面这行的最后一个字符是一个点号, 表示这个转发是最后一层)
#
#	forward-socks5	/ 127.0.0.1:1080 .
sudo service privoxy restart
# now http proxy is running on 127.0.0.1:8118

# Proxychains (force proxy for terminal commands)

git clone https://github.com/rofl0r/proxychains-ng
cd proxychains-ng
./configure --prefix=/usr --sysconfdir=/etc
make
sudo make install
sudo make install-config # (installs proxychains.conf)
vim /etc/proxychains.conf

# common proxy variable in terminal (终端约定的 HTTP/HTTPS 代理相关的环境变量)
export http_proxy=http://127.0.0.1:8000
export http_proxy=http://user:pwd@127.0.0.1:8000
export https_proxy=http://127.0.0.1:8000
# some software only recognize `http_proxy` without prefix protocol "http://" (某些软件不认 http_proxy 变量中的 http 协议前缀)
# for example: `go get`, software written by golang
export http_proxy=127.0.0.1:8000; export https_proxy=127.0.0.1:8000;
