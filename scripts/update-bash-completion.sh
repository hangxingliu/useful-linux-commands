#!/usr/bin/env bash

pushd "$( dirname "${BASH_SOURCE[0]}" )";

completion_file="../src/bash-completion.sh";
tmp_file="bash-completion.sh.tmp";
files=`bash generate-file-names.sh`;

throw() { echo "fatal: $1"; exit 1; }

if [[ -f "$tmp_file" ]]; then
	rm "$tmp_file" || throw "could not delete \"$tmp_file\"!";
fi

awk_append() { gawk "$1" "$completion_file" >> "$tmp_file" || throw "write to \"$tmp_file\" failed! ($1)"; }

awk_append '{ print $0; } /begin automatically generating region/ { exit 0; }';
echo -e "\tFILES_ARRAY=( $files );" >> "$tmp_file" || throw "write to \"$tmp_file\" failed! (FILES_ARRAY)";
awk_append 'BEGIN { p = 0; } /end automatically generating region/ { p = 1; } { if(p) print $0; }';

cp "$tmp_file" "$completion_file" || throw "copy to \"$completion_file\" failed!";
rm "$tmp_file" || throw "could not delete \"$tmp_file\"!";

echo "success: updated \"$completion_file\"!";
