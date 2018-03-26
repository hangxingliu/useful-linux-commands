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

# Privoxy (convert socks5 proxy to HTTP proxy)

sudo apt install privoxy
sudo vim /etc/privoxy/config
# Add a line in the bottom
#	forward-socks5	/ 127.0.0.1:1080
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

# common proxy variable in terminal
export http_proxy=http://127.0.0.1:8000
export http_proxy=http://user:pwd@127.0.0.1:8000
export http_proxy=socks5://127.0.0.1:1080
export https_proxy=http://127.0.0.1:8000
