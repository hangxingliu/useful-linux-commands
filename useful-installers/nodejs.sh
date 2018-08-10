#!/usr/bin/env bash

#===============================
#       DESCRIPTION
# This script is a
#   Nodejs installer in one step
#			Author: LiuYue
#			Date  : 2018-08-11
#===============================


NODE_URL_FOR_DEBIAN="https://deb.nodesource.com/setup_8.x"
NODE_URL_FOR_RHEL="https://rpm.nodesource.com/setup_8.x"

NODE_URL_FOR_DEBIAN_10="https://deb.nodesource.com/setup_10.x"
NODE_URL_FOR_RHEL_10="https://rpm.nodesource.com/setup_10.x"

# ================================
# ====   Colorized variables  ====
if [[ -t 1 ]]; then
	COLOR_MODE=`tput colors`;
	if [[ -n "$COLOR_MODE" ]] && [[ "$COLOR_MODE" -ge 8 ]]; then
		RED="\e[0;31m";          RED_BOLD="\e[1;31m";
		GREEN="\e[0;32m";        GREEN_BOLD="\e[1;32m";
		BLUE="\e[0;34m";         BLUE_BOLD="\e[1;34m";
		YELLOW_BOLD="\e[1;33m";
		BOLD="\e[1m";            DIM="\e[2m";           RESET="\e[0m";
	fi
fi
# ================================
# ====   Basic functions  ========
function confirm() {
	local yn;
	while true; do
		read -p "$1" yn;
		case $yn in
			Y|Yes|YES|yes|y) return 0 ;;
			N|No|NO|no|n) return 1 ;;
		esac
	done
}
function title() { echo -e "${BLUE_BOLD}# $1 ${RESET}"; }
function finish() { echo -e "\n${GREEN_BOLD}# Finish!${RESET}\n"; exit 0; }
function success() { echo -e "${GREEN} success: ${1} ${RESET}"; }
function error() { echo -e "${RED}  error: ${RED_BOLD}$1${RESET}"; exit 1; }
# ================================


# ================================
# !!!!! pre-check
PRE_CHECK=true;
if [[ -z `which curl` ]]; then PRE_CHECK=false; echo -e "  ${RED}\"curl\" is missing (used to fetch Node.js setup script)"; fi
if [[ -z `which gpg` ]]; then PRE_CHECK=false; echo -e "  ${RED}\"gpg\" is missing (used to import the GPG key of Node.js)"; fi
if [[ "$EUID" -ne 0 ]]; then # is not root user
	if [[ -z `which sudo` ]]; then PRE_CHECK=false; echo -e "  ${RED}\"sudo\" is missing (used to install Node.js)"; fi
fi
[[ "$PRE_CHECK" == false ]] && error "script dependencies are missing!";
# ================================


# ==========================
# display text
COMPAT_INFO="  This script only work in\
${RED_BOLD} Debian and Ubuntu based Linux distributions\
${RESET} and\
${RED_BOLD} Enterprise Linux and Fedora\
${RESET} OS"

COMPAT_OS_INFO="\tincluding: \
Ubuntu, Debian, Linux Mint, elementaryOS, bash on Windows, \
Red Hat® Enterprise Linux® / RHEL, CentOS and Fedora."

NODE_VERSION_INFO="  And the version of Nodejs is\
${RED_BOLD} 8.x ${RESET}or ${RED_BOLD}10.x ${RESET} "

INSTALL_DETAIL="  Installer include:\n\
\t1. Downloading nodejs binary distributions repository installer. And executing it. \n\
\t2. Install Nodejs by \"apt/yum\" \n\
\t3. Add NODE_PATH varaible to .bashrc file(and refresh variable immediately) \n\
\t4. Install \"pm2\" by \"npm\""

OPTS_TIP="  Supported options: ${BOLD}-y, --yes, 10, 8${RESET} ${DIM}(10: install Node.js 10.x; 8: install Node.js 8.x)${RESET}";
# ==========================

# ==========================
# parser arguments
opts_yes="false";
opts_ver="";
for argument in "$@"; do
	case "$argument" in
		-y|--yes) opts_yes="true" ;;
		8) opts_ver="8" ;;
		10) opts_ver="10" ;;
		*)  echo -e "${OPTS_TIP}"; error "Unknwon option: \"$argument\" " ;;
	esac
done
# ==========================


# ==========================
# Welcome banner

# Double banner color
C0="$GREEN_BOLD"; C1="$RESET";
echo -e $C0'  _   _           _       _     ' $C1 '  ___           _        _ _           ';
echo -e $C0' | \ | | ___   __| | ___ (_)___ ' $C1 ' |_ _|_ __  ___| |_ __ _| | | ___ _ __ ';
echo -e $C0' |  \| |/ _ \ / _` |/ _ \| / __|' $C1 '  | || '\''_ \/ __| __/ _` | | |/ _ \ '\''__|';
echo -e $C0' | |\  | (_) | (_| |  __/| \__ \' $C1 '  | || | | \__ \ || (_| | | |  __/ |   ';
echo -e $C0' |_| \_|\___/ \__,_|\___|/ |___/' $C1 ' |___|_| |_|___/\__\__,_|_|_|\___|_|   ';
echo -e $C0'                       |__/     ' $C1 '                                       ';
echo -e "                                   Author: ${BOLD}LiuYue ${RESET} Date: ${BOLD}2018-08-11\n";

echo -e "$COMPAT_INFO"
echo -e "$COMPAT_OS_INFO"
echo -e "$NODE_VERSION_INFO"
echo -e "$INSTALL_DETAIL"
echo -e "${OPTS_TIP}";

if [[ "$opts_ver" == "10" ]]; then
	NODE_URL_FOR_DEBIAN="$NODE_URL_FOR_DEBIAN_10";
	NODE_URL_FOR_RHEL="$NODE_URL_FOR_RHEL_10";
	echo -e "  ${BLUE}Enable ${BOLD}Node.js 10.x${RESET}${BLUE} installation!${RESET}\n";
else
	echo -e "  ${BLUE}Current install Node.js version is ${BOLD}8.x${RESET}\n";
fi
# ==========================

# ==========================
# User confirm
if [[ "$opts_yes" == "false" ]]; then
	confirm "Do you confirm?(Y/n) > " || error "You cancelled!"
fi
# ==========================

# ====================
# START  =====>

IS_RHEL="$(which yum)"
URL="$NODE_URL_FOR_DEBIAN"
PACKAGE_MANAGER="apt-get"
BASHRC_FILE="${HOME}/.bashrc"

# ======= STEP 1 ====================================
title "Downloading and executing Nodejs install script..."

if [[ -n `which apt` ]]; then
	PACKAGE_MANAGER="apt"; # apt-get => apt
else
	if [[ -n "$IS_RHEL" ]]; then
		URL="$NODE_URL_FOR_RHEL"
		PACKAGE_MANAGER="yum"
	fi
fi

echo "${URL}";
if [[ "$EUID" -eq 0 ]]; then # is root ?
	curl --silent --location "${URL}" | bash -
else
	curl --silent --location "${URL}" | sudo bash -
fi
[[ $? -ne 0 ]] && error "Download or execute nodejs install script failed!";

# ======= STEP 2 ====================================
title "${PACKAGE_MANAGER} installing ...";

if [[ "$EUID" -eq 0 ]]; then # is root ?
	${PACKAGE_MANAGER} install -y nodejs
else
	sudo ${PACKAGE_MANAGER} install -y nodejs
fi
[[ $? -ne 0 ]] && error "${PACKAGE_MANAGER} install nodejs failed!"

# ======= STEP 3 ====================================
title "Setting up NODE_PATH variable in bashrc file"

if [[ -n "$NODE_PATH" ]]; then
	echo -e "${YELLOW_BOLD} The NODE_PATH has been set up in your computer: ${NODE_PATH}"
else
	[[ ! -f "$BASHRC_FILE" ]] && error "${BASHRC_FILE} is not exists!";

	SET_NODE_PATH="$(npm root -g)";
	echo "$SET_NODE_PATH";
	[[ -z "$SET_NODE_PATH" ]] && error "can not set NODE_PATH, because \`npm root -g\` print empty path info!";

	echo "" >> "$BASHRC_FILE"
	echo "# =============================" >> "$BASHRC_FILE"
	echo "# NodeJs environment variable:" >> "$BASHRC_FILE"
	echo "export NODE_PATH=\"${SET_NODE_PATH}\"" >> "$BASHRC_FILE"
	echo "# =============================" >> "$BASHRC_FILE"

	# ======= STEP 3.5
	export NODE_PATH="${SET_NODE_PATH}"
fi

# ======= STEP 4 ====================================
title "Installing pm2 (Production process manager for Node.js)"

# is root ?
if [[ "$EUID" -eq 0 ]]; then   npm i pm2 -g;
else                      sudo npm i pm2 -g;
fi
[[ $? -ne 0 ]] && error "Install pm2 failed!";

echo "";
echo -e "===================================";
echo -e " Node.js version: $(node --version)";
echo -e " NPM version:      $(npm --version)";
finish
