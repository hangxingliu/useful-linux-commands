#!/usr/bin/env bash

###-begin-useful-commands-completion-###
#
# useful-commands command completion script
#
# Installation: useful-commands completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: useful-commands completion > /usr/local/etc/bash_completion.d/useful-commands
#
_useful_commands_completion() {
	local CURRENT_WORD LAST_WORD FILES_ARRAY FILES _F_FILES OPTS;

	# COMPLETION_FOR_CMD="$1"; # useful-commands
	CURRENT_WORD="$2";
	LAST_WORD="$3";

	OPTS="-a -A -b -B -f -F -m --mini --help --color --no-color";
	FILES_ARRAY=( awk bash curl disk docker ffmpeg find_xargs firewall git gpg gui_software
                httpie image_magick index inotify install_deluge_on_centos_6 install_macos_in_virtualbox
                log lsyncd monitor_and_usage mysql proxy qt raspberrypi samba
                sed ssh_enc ssh swap ui vagrant vim vm xbindkeys );
	for FNAME in "${FILES_ARRAY[@]}"; do
		FILES="${FILES} ${FNAME}";
		_F_FILES="${_F_FILES} -f${FNAME}";
	done

	if [[ "$CURRENT_WORD" == -f* ]] || [[ "$CURRENT_WORD" == -F* ]]; then
		COMPREPLY=( $( compgen -W "$_F_FILES" -- $CURRENT_WORD ) );
	elif [[ "$LAST_WORD" == "-f" ]] || [[ "$LAST_WORD" == "-F" ]]; then
		COMPREPLY=( $( compgen -W "$FILES" -- $CURRENT_WORD ) );
	elif [[ "$CURRENT_WORD" == -* ]]; then
		COMPREPLY=( $( compgen -W "$OPTS" -- $CURRENT_WORD ) );
	fi
}

complete -F _useful_commands_completion useful-commands;
###-end-useful-commands-completion-###
