#!/usr/bin/env bash

FLOOD_HOSTNAME="0.0.0.0"
FLOOD_PORT="8600"

RTORRENT_USER="rtorrent"
FLOOD_USER="flood"

SYSTEMD_DIR="/etc/systemd/system"
RTORRENT_SERVICE_FILE="$SYSTEMD_DIR/rtorrent.service"
FLOOD_SERVICE_FILE="$SYSTEMD_DIR/flood.service"
RTORRENT_RC_FILE="/home/$RTORRENT_USER/.rtorrent.rc"

#================    Configurations     ================#
CONFIG_RTORRENT="
directory = /rtorrent/downloads
session = /rtorrent/.session

# Which ports rTorrent can use (Make sure to open them in your router)
port_range = 50000-50000
port_random = no 

check_hash = yes
dht = auto
dht_port = 6881
peer_exchange = yes
use_udp_trackers = yes
encryption = allow_incoming,try_outgoing,enable_retry

scgi_port = 127.0.0.1:5000
"

CONFIG_RTORRENT_SERVICE="
[Unit]
Description=rTorrent
After=network.target
 
[Service]
User=$RTORRENT_USER
Type=forking
KillMode=none
ExecStart=/usr/bin/screen -d -m -fa -S rtorrent /usr/bin/rtorrent
ExecStop=/usr/bin/killall -w -s 2 /usr/bin/rtorrent
WorkingDirectory=%h
 
[Install]
WantedBy=default.target
"
CONFIG_FLOOD_SERVICE="
[Unit]
Description=flood

[Service]
WorkingDirectory=/rtorrent/flood
ExecStart=/usr/bin/node server/bin/www
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=notell
User=$FLOOD_USER
Group=$FLOOD_USER
Environment=NODE_ENV=production
 
[Install]
WantedBy=multi-user.target
"

#================       Functions       ================#
function newline()  { echo -e ""; }
function line()  { echo -e "========================="; }
function title() { echo -e "\n# $1 "; }
function error() { echo -e "\n  error: $1\n"; exit 1; }
function check() { [[ "$?" == "0" ]] || error "$1"; }
#=======================================================================#
#                                                                       #
#             Script start from here                                    #
#                                                                       #
#=======================================================================#
line
newline
echo '  rTorrent and flood(web UI) install script For Ubuntu'
echo '                        relevant directory: /rtorrent/'
echo '                                     Unattended script'
newline
line
newline

[[ "`whoami`" == "root" ]]
check "please executing this script by root user"

# install necessary software
title "Adding Nodejs apt repository.."
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - 
check "Add Nodejs apt repository failed!"

title "Installing apt package ..."
apt install rtorrent git curl screen pwgen nodejs -y
check "Apt package install failed!"

title "Creating necessary users ..."
useradd --create-home --comment 'user for rtorrent' $RTORRENT_USER
useradd --create-home --comment 'user for flood' $FLOOD_USER
check "create users failed! (deluser $FLOOD_USER; deluser $RTORRENT_USER)"

title "Creating necessary directories ..."
mkdir -p /rtorrent
mkdir -p /rtorrent/downloads
mkdir -p /rtorrent/.session
check "create directories failed!"

title "Writing .rtorrent.rc ..."
echo "$CONFIG_RTORRENT" > $RTORRENT_RC_FILE
check "write .rtorrent.rc failed!"

title "Fixing permission of directories ..."
chmod 775 -R /rtorrent 
chown $RTORRENT_USER:$RTORRENT_USER -R /rtorrent
chown $RTORRENT_USER:$RTORRENT_USER $RTORRENT_RC_FILE
check "Fixing permission of directories failed!"

title "Installing Flood ..."
pushd /rtorrent
git clone https://github.com/jfurrow/flood.git
pushd flood
npm install --production
check "Install Flood failed!"

title "Configuring Flood ..."
gawk \
-v secret=`pwgen 1024 1` \
-v host="${FLOOD_HOSTNAME}" \
-v port="${FLOOD_PORT}" \
'/^\s*floodServerHost:/ {print "  floodServerHost: \"" host "\",";next}
/^\s*floodServerPort:/ {print "  floodServerPort: " port ",";next}
/^\s*secret:/ {print "  secret: \"" secret "\",";next}
{print $0}' config.template.js > config.js
check "Configure Flood failed!"

title "Fixing permission of flood directory ..."
chown -R $FLOOD_USER:$FLOOD_USER /rtorrent/flood/
check "Fix permission of flood directory failed!"

title "Installing systemd services ..."
echo "$CONFIG_RTORRENT_SERVICE" > $RTORRENT_SERVICE_FILE
echo "$CONFIG_FLOOD_SERVICE" > $FLOOD_SERVICE_FILE
systemctl enable rtorrent.service
systemctl enable flood.service
check "Install services failed!"

title "Starting services ..."
systemctl start rtorrent
systemctl start flood
check "Start services failed!"

newline
line
echo "  Success!"
line
newline