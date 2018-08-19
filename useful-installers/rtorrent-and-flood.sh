#!/usr/bin/env bash

# =============   User Config   =================
INSTALL_TO_DIR="/rtorrent";
RTORRENT_DOWNLOAD_DIR="/rtorrent/downloads";
RTORRENT_SESSION_DIR="/rtorrent/.session";
FLOOD_DIR="/rtorrent/flood";

FLOOD_HOST="0.0.0.0"
FLOOD_PORT="9000"

USER_RTORRENT="rtorrent"
USER_FLOOD="flood"

SYSTEMD_DIR="/etc/systemd/system"
RTORRENT_SERVICE_FILE="$SYSTEMD_DIR/rtorrent.service"
FLOOD_SERVICE_FILE="$SYSTEMD_DIR/flood.service"

RTORRENT_RC_FILE="/home/$USER_RTORRENT/.rtorrent.rc"

NODEJS_URL="https://deb.nodesource.com/setup_8.x"
FLOOD_REPO="https://github.com/jfurrow/flood.git"

# =========   Generated Config File   ===========
CONFIG_RTORRENT="
directory = $RTORRENT_DOWNLOAD_DIR
session = $RTORRENT_SESSION_DIR

# Which ports rTorrent can use (Make sure to open them in your router)
port_range = 50000-50000
port_random = no

# Setup download and upload rate (0: unlimited, 200: 200kb)
download_rate = 0
upload_rate = 200

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
User=$USER_RTORRENT
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
WorkingDirectory=$FLOOD_DIR
ExecStart=/usr/bin/npm start
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=notell
User=$USER_FLOOD
Group=$USER_FLOOD
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
"

# ============   Color Variables   ==============
if [[ -t 1 ]]; then # is terminal
	CM=`tput colors`; # color mode
	if [[ -n "$CM" ]] && [[ "$CM" -ge 8 ]]; then
		RED="\e[31m"; BLUE="\e[34m"; CYAN="\e[36m"; GREEN="\e[32m";
		BOLD="\e[1m"; DIM="\e[2m"; RESET="\e[0m";
	fi
fi

# ============   Print Functions   ==============
doing() { echo -e "${BLUE}${BOLD}[.] $1${RESET}"; }
success() { echo -e "${GREEN}${BOLD}[+] success: all done!${RESET}"; }
throw() { echo -e "${RED}${BOLD}[-] fatal: $1${RESET}"; echo -e "${RED}script exit with code 1${RESET}"; exit 1; }
has_install() { test -n "$(which "$1")"; }

# ==================================================
#      __  __             _
#     |  \/  |    __ _   (_)   _ __
#     | |\/| |   / _` |  | |  | '_ \
#     | |  | |  | (_| |  | |  | | | |
#     |_|  |_|   \__,_|  |_|  |_| |_|
#
# ==================================================

echo -e "${CYAN}";
echo -e "======================================================="
echo -e "  ${BOLD}rTorrent and flood(Web UI) install script for Ubuntu${RESET}${CYAN}"
echo -e "  Install to: ${INSTALL_TO_DIR}"
echo -e "  Update at:  2018-08-19"
echo -e "======================================================="
echo -e "${RESET}";

# ============
doing "checking is current user root";
[[ $EUID -eq 0 ]] || throw "root user is required!";

# ============
doing "checking systemd is available";
has_install systemctl || throw "systemd is not available!";

# ============
DEPS="python-dev build-essential git gnupg gawk curl rtorrent screen pwgen";
doing "installing basic dependencies ($DEPS)";
apt update || throw "apt update failed!";
apt install $DEPS -y || throw "install dependencies failed!\n  Please install dependencies manually ($DEPS)";
# "gnupg" is used for installing Node.js
# "python-dev" and "build-essential" are used for node-gyp build flood project

# ============
doing "checking is Node.js installed";
if ! has_install node; then

	doing "installing Node.js"
	curl -sL "$NODEJS_URL" | bash - || throw "add Node.js apt repository from $NODEJS_URL failed!";
	apt install nodejs -y || throw "install nodejs failed!";
fi


# ============
doing "creating system users for rtorrent and flood"
HAVE_YOU="Have you installed rtorrent by this script?";
id -u "$USER_RTORRENT" 2>/dev/null && throw "$HAVE_YOU\n  You can delete user \"$USER_RTORRENT\" and try again";
id -u "$USER_FLOOD" 2>/dev/null && throw "$HAVE_YOU\n  You can delete user \"$USER_FLOOD\" and try again";

useradd --create-home --comment 'user for rtorrent' "$USER_RTORRENT" || throw "create user $USER_RTORRENT failed!";
useradd --create-home --comment 'user for flood'    "$USER_FLOOD"    || throw "create user $USER_FLOOD failed!";

# ============
doing "creating directories"
try_mkdir() { [[ -d "$1" ]] && return 0;  mkdir -p "$1" || throw "create dir $1 failed!"; }
try_mkdir "$INSTALL_TO_DIR";
try_mkdir "$RTORRENT_DOWNLOAD_DIR";
try_mkdir "$RTORRENT_SESSION_DIR";

# ============
doing "setting up .rtorrent.rc"
echo "$CONFIG_RTORRENT" > "$RTORRENT_RC_FILE" || throw "write $RTORRENT_RC_FILE failed!";

# ============
doing "granting permission of directories to $USER_RTORRENT "
chmod 775 -R "$INSTALL_TO_DIR"                                || throw "chmod failed!";
chown "$USER_RTORRENT:$USER_RTORRENT" -R "$INSTALL_TO_DIR"    || throw "chown failed!"
chown "$USER_RTORRENT:$USER_RTORRENT"    "$RTORRENT_RC_FILE"  || throw "chown failed!"

# ============
doing "setting up systemd services"
echo "$CONFIG_RTORRENT_SERVICE" > "$RTORRENT_SERVICE_FILE"  || throw "write $RTORRENT_SERVICE_FILE failed!";
echo "$CONFIG_FLOOD_SERVICE" > "$FLOOD_SERVICE_FILE"        || throw "write $FLOOD_SERVICE_FILE failed!";
systemctl enable rtorrent.service || throw "systemctl enable rtorrent.service failed!"
systemctl enable flood.service    || throw "systemctl enable flood.service failed!"

# ============
doing "installing node-gyp (it is used for compile flood)"
if ! has_install node-gyp; then
	npm install -s node-gyp -g || throw "install node-gyp failed!";
fi

# ============
doing "cloning flood(Web UI)"
if [[ -d "$FLOOD_DIR" ]]; then
	[[ -f "$FLOOD_DIR/package.json" ]] || throw "$FLOOD_DIR is existed but files are missing!";
	echo -e "skip git clone, because flood has been git into $FLOOD_DIR";
else
	git clone "$FLOOD_REPO" "$FLOOD_DIR" || throw "git clone $FLOOD_REPO failed!";
fi

# ============
doing "configuring flood"
pushd "$FLOOD_DIR";
TMPL_CONFIG="config.template.js"
[[ -f "$TMPL_CONFIG" ]] || throw "$TMPL_CONFIG is missing!";
gawk \
	-v secret=`pwgen 1024 1` \
	-v host="${FLOOD_HOST}" \
	-v port="${FLOOD_PORT}" '
	/^\s*floodServerHost:/ {
		print "  floodServerHost: \"" host "\",";
		next
	}
	/^\s*floodServerPort:/ {
		print "  floodServerPort: " port ",";
		next
	}
	/^\s*secret:/ {
		print "  secret: \"" secret "\",";
		next
	}
	{
		print $0
	}'\
	"$TMPL_CONFIG" > "config.js" || throw "generate config.js from $TMPL_CONFIG failed!";
popd;

# ============
doing "installing flood(Web UI)"
pushd "$FLOOD_DIR";
npm install -s || throw "npm install failed!";
npm run build || throw "npm run build failed!\n  WARNING: if your memory is less than 2G, please turn the swap on!";
popd;

# ============
doing "granting permission of directories to $USER_FLOOD "
chown -R "$USER_FLOOD:$USER_FLOOD" "$FLOOD_DIR" || throw "chown failed!"

# ============
doing "start services"
systemctl start rtorrent || throw "systemctl start rtorrent failed!"
systemctl start flood    || throw "systemctl start flood failed!"

# ============
success
