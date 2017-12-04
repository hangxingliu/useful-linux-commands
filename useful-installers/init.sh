#!/usr/bin/env bash

#==================================================
#                DESCRIPTION
#  This script is a basic soaftware and environment
#     installer for a new linux OS
# - Include:
#   - git, vim, htop, gawk, bash-completion
#   - Git config | alias
#   - Bash alias
#
# - Supported OS:
#   - ths OS has "yum" package manager  
#   - ths OS has "apt" package manager 
#
#							Author: LiuYue
#							Date  : 2017-12-03
#==================================================

# CONFIG_BLOCK ====================>

SOFTWARES="git vim htop gawk bash-completion";
SOFTWARES_READABLE=`echo "$SOFTWARES" | tr ' ' ',' `;
YOUTUBE_DL_BASE_OPTS="--proxy socks5://127.0.0.1:1080/ --socket-timeout 10 ";
ALIASES=(
	"cl='clear'"
	"cls='clear'"
	"proxy='proxychains4'"
	"e='xdg-open .'"
	"grepab='grep -A 5 -B 3 -e'"
	"2cb='xclip -selection clipboard'"
	"sudo='sudo '"
	"vi='vim'"
	"youtube=\"youtube-dl ${YOUTUBE_DL_BASE_OPTS} \
		-f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' \""
	"youtube-music=\"youtube-dl ${YOUTUBE_DL_BASE_OPTS} \
		-f 'bestvideo[ext=mp4][height<=360]+bestaudio' \""
	"youtube-sub=\"youtube-dl ${YOUTUBE_DL_BASE_OPTS} --all-subs \
		-f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' \""
)
GIT_GRAPH_BASE_OPTS="--graph --branches --all --decorate";
GIT_CONFIGS=(
	"core.editor vim"
	"alias.g log ${GIT_GRAPH_BASE_OPTS} \
--format=format:'%C(yellow)%h%C(auto)%d%C(white): %s %C(dim)(%ad)' --date=format:'%m/%d'"
	"alias.g2 log ${GIT_GRAPH_BASE_OPTS} \
--format=format:'%C(yellow)%h%C(reset) %C(green dim)%ad (%ar) %C(auto)%d%n    %C(white)%s%n' \
--date=format:'%y-%m-%d %H:%M'"
	"alias.g3 log ${GIT_GRAPH_BASE_OPTS} \
--format=format:'%C(yellow)%h%C(reset) %C(green dim)%ad (%ar) %C(auto)%d%n    %C(white)%s%n%b' \
--date=format:'%y-%m-%d %H:%M'"
	"alias.co checkout"
	"alias.br branch"
	"alias.cfg config"
);
BASHRC_FILE="$HOME/.bashrc";

# <==================== CONFIG_BLOCK

IGNORE_INSTALL_SOFTWARE="false"
IGNORE_SET_BASH_ALIASES="false"
IGNORE_SET_GIT_CONFIG="false"

#================================
#====   Colorized variables  ====
RED="\e[0;31m"
RED_BOLD="\e[1;31m"
YELLOW_BOLD="\e[1;33m"
GREEN="\e[0;32m"
GREEN_BOLD="\e[1;32m"
BLUE="\e[0;34m"
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
function subTitle() { echo -e "${BLUE}## $1 ${RESET}"; }
function finish() { echo -e "\n${GREEN_BOLD}# Finish!\n  ${GREEN}Please re-login to activate config.\n"; exit 0; }
function warn() { echo -e "${YELLOW_BOLD} warning: ${1} ${RESET}"; }
function success() { echo -e "${GREEN} success: ${1} ${RESET}"; }
function error() { echo -e "${RED}  error: ${RED_BOLD}$1${RESET}"; exit 1; }
#================================

DIV_LINE="===============================================";
echo -e "\n${DIV_LINE}"
echo -e "  _____       _ _                   _       _   "
echo -e " |_   _|     (_) |                 (_)     | |  "
echo -e "   | |  _ __  _| |_   ___  ___ _ __ _ _ __ | |_ "
echo -e "   | | | '_ \| | __| / __|/ __| '__| | '_ \| __|"
echo -e "  _| |_| | | | | |_  \__ \ (__| |  | | |_) | |_ "
echo -e " |_____|_| |_|_|\__| |___/\___|_|  |_| .__/ \__|"
echo -e "                                     | |        "
echo -e "                                     |_|        "
echo -e "${BOLD} Init basic software, config and environment \n\
                ${BOLD}for new linux OS in one script."
echo -e "\n${BOLD} Include: ${RESET}\n\
        ${SOFTWARES_READABLE}\n\
        Useful git configs, aliases\n\
        Useful bash aliases\n\
                            Author:${BOLD} LiuYue${RESET}\n\
                            Date:  ${BOLD} 2017-12-03"
echo -e "${DIV_LINE}"

[[ `yes_no "Are you ready?(y/n)"` == "no" ]] && exit 0;

# ====================
# START  =====>

if [[ "$IGNORE_INSTALL_SOFTWARE" == "false" ]]; then

	title "Checking package manager ..."
	INSTALLER=""
	[[ -n "`which yum`" ]] && INSTALLER="yum"
	[[ -n "`which apt`" ]] && INSTALLER="apt"
	[[ -z "$INSTALLER" ]] && error "Your OS has not \"apt\" or \"yum\" "

	title "Updateing ${INSTALLER}"
	sudo $INSTALLER update -y

	title "Installing basic software ..."
	sudo $INSTALLER install -y ${SOFTWARES};
	if [[ $? -ne 0 ]]; then
		warn "Install ${RED}${software}${YELLOW_BOLD} failed! Do you want to continue?"
		[[ `yes_no "continue(y/n): "` == "no" ]] && error 'You cancelled!';
	else
		success "Installed ${GREEN_BOLD}${software}"
	fi

else
	warn "Ignored install software step!"
fi
# =======================================================

if [[ "$IGNORE_SET_BASH_ALIASES" == "false" ]]; then
	title "Setting up useful bash aliases ..."

	i=0
	markText="# Useful bash aliases"
	OK="OK"
	if [[ -n "$(grep ${BASHRC_FILE} -e "${markText}")" ]]; then
		OK=""
		warn "You maybe has set up the Useful bash aliases! Do you want to ${RED}set up ${RED_BOLD}again?"
		[[ `yes_no "set up again(y/n): "` == "yes" ]] && OK="OK"
	fi
	if [[ "$OK" == "OK" ]]; then
		DIV_LINE="# ===================================";
		echo "$DIV_LINE" >> $BASHRC_FILE
		echo "$markText" >> $BASHRC_FILE
		while [[ -n "${ALIASES[$i]}" ]]; do
			ALIAS=`echo "${ALIASES[$i]}" | awk '{gsub(/\s+/, " ", $0); print $0;}'`;
			aliasExpression="alias ${ALIAS}"
			subTitle "alias ${aliasExpression%%\=*}"

			echo "$aliasExpression" >> $BASHRC_FILE;

			let i++;
		done
		echo "$DIV_LINE" >> $BASHRC_FILE
		success "Set up useful useful bash aliases into ${BASHRC_FILE}"
	fi
else
	warn "Ignored set up basic bash alias"
fi
# =======================================================


if [[ "$IGNORE_SET_GIT_CONFIG" == "false" ]]; then
	title "Configuring git ..."

	CMD="git config --global"

	subTitle "user.name"
	GIT_USER_NAME=`$CMD user.name`
	OK="OK"
	if [[ -n "$GIT_USER_NAME" ]]; then
		OK=""
		warn "You had set up git user.name: ${RED} ${GIT_USER_NAME}"
		[[ `yes_no "Do you want to covert? (y: covert/n):"` == "yes" ]] && OK="OK"
	fi
	if [[ "$OK" == "OK" ]]; then
		read -p "user.name: " NEW_GIT_USER_NAME
		$CMD user.name "$NEW_GIT_USER_NAME"

		success "git user.name is ${GREEN_BOLD} $($CMD user.name)"
	fi

	subTitle "user.email"
	GIT_USER_EMAIL=`$CMD user.email`
	OK="OK"
	if [[ -n "$GIT_USER_EMAIL" ]]; then
		OK=""
		warn "You had set up git user.email: ${RED} ${GIT_USER_EMAIL}"
		[[ `yes_no "Do you want to covert? (y: covert/n):"` == "yes" ]] && OK="OK"
	fi
	if [[ "$OK" == "OK" ]]; then
		read -p "user.email: " NEW_GIT_USER_EMAIL
		$CMD user.email "$NEW_GIT_USER_EMAIL"

		success "git user.email is ${GREEN_BOLD} $($CMD user.email)"
	fi

	i=0
	while [[ -n "${GIT_CONFIGS[$i]}" ]]; do
		cfg="${GIT_CONFIGS[$i]}"
		cfgName="${cfg%% *}"
		cfgBody="${cfg#* }"
		subTitle "$cfgName"
		
		OK="OK"
		ORIGINAL_VALUE=`$CMD $cfgName`
		if [[ -n "$ORIGINAL_VALUE"  ]]; then
			OK=""
			warn "You had set up git ${RED} $cfgName ${RED_BOLD} ${ORIGINAL_VALUE}"
			[[ `yes_no "Do you want to covert? (y: covert/n):"` == "yes" ]] && OK="OK"
		fi
		if [[ "$OK" == "OK" ]]; then
			$CMD "$cfgName" "$cfgBody"

			success "git ${cfgName} is ${GREEN_BOLD} $($CMD $cfgName)"
		fi
		let i++;
	done

else
	warn "Ignored configure git"
fi
# =======================================================

finish