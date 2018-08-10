#!/usr/bin/env bash

#
# DESCRIPTION: this script is executed on VPS (remote server)
#

TMP_FROM="/tmp/ansible-upload.tmp";
TARGET_FILE_NAME="useful-linux-commands.conf";

TARGET_DIR_1="/etc/nginx/conf.d";
TARGET_DIR_2="/etc/nginx/sites-enabled";

# =================================================================

function throw() { echo -e "fatal: $*"; exit 1; }

[[ -f "$TMP_FROM" ]] || throw "can not find upload tmp file: \"${TMP_FROM}\" !";

TARGET_DIR="$TARGET_DIR_1";
[[ -d "$TARGET_DIR" ]] || TARGET_DIR="$TARGET_DIR_2";
[[ -d "$TARGET_DIR" ]] || throw "can not nginx conf dir \"$TARGET_DIR_1\" or \"$TARGET_DIR_2\" !";

cp "$TMP_FROM" "$TARGET_DIR/$TARGET_FILE_NAME" ||
	throw "copy config file from \"$TMP_FROM\" to \"$TARGET_DIR/$TARGET_FILE_NAME\" failed!";

rm "$TMP_FROM";
