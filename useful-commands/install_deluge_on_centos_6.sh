# Install Deluge on Centos 6
# Deluge: multi-platform bittorrent client

# This document is reference from:
# http://idroot.net/tutorials/how-to-install-deluge-on-centos-6/

# 1. add yum repo

vim /etc/yum.repos.d/linuxtech.repo

# 2. add following

[linuxtech]
name=LinuxTECH
baseurl=http://pkgrepo.linuxtech.net/el6/release/
enabled=1
gpgcheck=1
gpgkey=http://pkgrepo.linuxtech.net/el6/release/RPM-GPG-KEY-LinuxTECH.NET

# 3. yum update and install

yum update
yum install deluge-common deluge-web deluge-daemon

# 4. add user

useradd --system --home /var/lib/deluge deluge

# 5. edit configure file

vim /etc/init.d/deluge-daemon

# replace from

prog2=deluge
daemon --user deluge "$prog2 --ui web >/dev/null 2>&1 &"

# replace to

prog2=deluge-web
daemon --user deluge "$prog2 >/dev/null 2>&1 &"

# 6. restart deluge service

service deluge-daemon restart
chkconfig deluge-daemon on

# 7. visit web page
http://hostname:8112 default password: deluge

# 8. if you need change some configure:
# using bash in deluge account

su --shell /bin/bash --login deluge

# you can find configure files in ~/.config/deluge/
