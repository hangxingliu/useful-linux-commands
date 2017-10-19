#!/usr/bin/env bash

#===============================
#       DESCRIPTION
# This script is a 
#   Nodejs installer in one step
#			Author: LiuYue
#			Date  : 2017-04-23
#===============================


NODE_URL_FOR_DEBIAN="https://deb.nodesource.com/setup_8.x"
NODE_URL_FOR_RHEL="https://rpm.nodesource.com/setup_8.x"
SET_NODE_PATH="/usr/lib/node_modules"

#================================
#====   Colorized variables  ====
RED="\e[0;31m"
RED_BOLD="\e[1;31m"
YELLOW_BOLD="\e[1;33m"
GREEN="\e[0;32m"
GREEN_BOLD="\e[1;32m"
BLUE_BOLD="\e[1;34m"
BOLD="\e[1m"
RESET="\e[0m"
#================================
#====   Basic functions  ========
function yes_no() {
	local yn text=$1
	while true; do
	read -p "${text}" yn
		case $yn in
			[Yy]* ) echo "yes"; break ;;
			[Nn]* ) echo "no"; break ;;
		esac
	done
}
function title() { echo -e "${BLUE_BOLD}# $1 ${RESET}"; }
function finish() { echo -e "\n${GREEN_BOLD}# Finish!\n"; exit 0; }
function success() { echo -e "${GREEN} success: ${1} ${RESET}"; }
function error() { echo -e "${RED}  error: ${RED_BOLD}$1${RESET}"; exit 1; }
#================================

WARNING_INFO="  This script only work in\
${RED_BOLD} Debian Ubuntu based Linux\
${RESET} and\
${RED_BOLD} RHEL, CentOS, Fedora\
${RESET} OS"

NODE_VERSION_INFO="  And the version of Nodejs is\
${RED_BOLD} 8.x ${RESET}"

INSTALL_DETAIL="  Installer include:\n\
\t1. Downloading nodejs binary distributions repository installer. And executing it. \n\
\t2. Install Nodejs by \"apt/yum\" \n\
\t3. Add NODE_PATH varaible to .bashrc file(and refresh variable immediately) \n\
\t4. Install \"pm2\" by \"npm\" \n"

PLEASE_EXECUTE_AS_ROOT="${RED_BOLD} Please execute this script in root account"

DO_YOU_CONFIRMED="Do you confirm?(Y/n)"

echo '  _   _           _      _                   ';
echo ' | \ | |         | |    (_)                  ';
echo ' |  \| | ___   __| | ___ _ ___               ';
echo ' | . ` |/ _ \ / _` |/ _ \ / __|              ';
echo ' | |\  | (_) | (_| |  __/ \__ \              ';
echo ' |_| \_|\___/ \__,_|\___| |___/              ';
echo '                       _/ |                  ';
echo '      _____           |__/     _ _           ';
echo '     |_   _|         | |      | | |          ';
echo '       | |  _ __  ___| |_ __ _| | | ___ _ __ ';
echo '       | | | `_ \/ __| __/ _` | | |/ _ \ `__|';
echo '      _| |_| | | \__ \ || (_| | | |  __/ |   ';
echo '     |_____|_| |_|___/\__\__,_|_|_|\___|_|   ';
echo -e "             Author: ${BOLD}LiuYue ${RESET} Date: ${BOLD}2017-04-23\n";

echo -e "$WARNING_INFO"
echo -e "$NODE_VERSION_INFO"
echo -e "$INSTALL_DETAIL"

OK=`yes_no "$DO_YOU_CONFIRMED"`;
[[ "$OK" == "no" ]] && error "You cancelled!"

# ====================
# START  =====>

IS_RHEL="$(which yum)"
URL="$NODE_URL_FOR_DEBIAN"
PACKAGE_MANAGER="apt"
BASHRC_FILE="${HOME}/.bashrc"

# ======= STEP 1
title "Downloading and executing Nodejs install script..."

if [[ -n "$IS_RHEL" ]]; then
	URL="$NODE_URL_FOR_RHEL"
	PACKAGE_MANAGER="yum"
fi

sudo curl --silent --location "${URL}" | sudo bash -

[[ $? -ne 0 ]] && error "Download or execute nodejs install script failed!";

# ======= STEP 2
title "${PACKAGE_MANAGER} installing ...";

sudo ${PACKAGE_MANAGER} install -y nodejs
[[ $? -ne 0 ]] && error "${PACKAGE_MANAGER} install nodejs failed!"

# ======= STEP 3
title "Setting up NODE_PATH variable in bashrc file"

if [[ -n "$NODE_PATH" ]]; then
	echo -e "${YELLOW_BOLD} The NODE_PATH has been set up in your computer: ${NODE_PATH}"
else
	
	[[ ! -f "$BASHRC_FILE" ]] && error "${BASHRC_FILE} is not exists!";

	echo "" >> $BASHRC_FILE
	echo "# =============================" >> $BASHRC_FILE
	echo "# NodeJs environment variable:" >> $BASHRC_FILE
	echo "export NODE_PATH=\"${SET_NODE_PATH}\"" >> $BASHRC_FILE
	echo "# =============================" >> $BASHRC_FILE

	# ======= STEP 3.5
	export NODE_PATH="${SET_NODE_PATH}"

fi

# ======= STEP 4
title "Installing pm2 (Production process manager for Node.js)"
sudo npm i pm2 -g
[[ $? -ne 0 ]] && error "Install pm2 failed!";

finish