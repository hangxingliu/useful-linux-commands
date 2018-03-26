#!/usr/bin/env bash

LOCAL_TARGET="../server-config-mirror/sites-enabled";

if [[ -z "$1" ]]; then
	echo "";
	echo "  Usage: ./mirror-server-config.sh <[user@]host> [--upload]";
	echo "";
	echo "    copy server config on the server to local directory.";
	echo "";
	exit 0;
fi

echo "server info: ${1}";
echo "=============================";

set -x;
cd "$( dirname "${BASH_SOURCE[0]}" )";

if [[ ! -e "$LOCAL_TARGET" ]]; then
	mkdir -p "$LOCAL_TARGET";
	if [[ "$?" != "0" ]]; then
		echo "fatal: could not create directory: $LOCAL_TARGET";
		exit 1;
	fi
fi

if [[ "$2" == "--upload" ]]; then
	scp $LOCAL_TARGET/*.conf "$1:/etc/nginx/sites-enabled";
	OK=$?;
else
	scp "$1:/etc/nginx/sites-enabled/*.conf" $LOCAL_TARGET;
	OK=$?;
fi

if [[ "$OK" != "0" ]]; then
	echo "fatal: could not scp!";
	exit 1;
fi

echo "success!";
