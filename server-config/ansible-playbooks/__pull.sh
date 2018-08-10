#!/usr/bin/env bash

#
# DESCRIPTION: this script is executed on VPS (remote server)
#

SRC_FILE_1="/etc/nginx/conf.d/useful-linux-commands.conf";
SRC_FILE_2="/etc/nginx/sites-enabled/useful-linux-commands.conf";
TMP_TO="/tmp/ansible-download.tmp";

# =================================================================

function throw() { echo -e "fatal: $*"; exit 1; }

SRC_FILE="$SRC_FILE_1";
[[ -f "$SRC_FILE" ]] || SRC_FILE="$SRC_FILE_2";
[[ -f "$SRC_FILE" ]] || throw "can not find file \"$SRC_FILE_1\" or \"$SRC_FILE_2\" !";

cp "$SRC_FILE" "$TMP_TO" || throw "copy nginx configuration file from \"$SRC_FILE\" to \"$TMP_TO\" failed!";
