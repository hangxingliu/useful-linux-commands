#!/usr/bin/env bash

WORKSPACE="ansible-playbooks";
HOSTS_FILE="hosts";

# ================================================================
# color variables
if [[ -t 1 ]]; then
	COLOR_MODE=`tput colors`;
	if [[ -n "$COLOR_MODE" ]] && [[ "$COLOR_MODE" -ge 8 ]]; then
		BOLD="\x1b[1m"; RESET="\x1b[0m";
		RED="\x1b[31m"; GREEN="\x1b[32m"; CYAN="\x1b[36m";
	fi
fi
# throw function
function throw() { echo -e "fatal: $*"; exit 1; }
# ================================================================

# checkout to directory same with this script
__DIRNAME=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`;
cd "$__DIRNAME" > /dev/null;

[[ -f "$HOSTS_FILE" ]] ||
	throw "please refer to file \"hosts.example\" to create file \"${BOLD}hosts${RESET}\"";


pushd "$WORKSPACE";
ansible-playbook pull.yml;
exit $?;
