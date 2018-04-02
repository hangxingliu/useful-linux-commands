#!/usr/bin/env bash

function throw() { echo "fatal: $1"; exit 1; }

[[ -z `which cleancss` ]] &&
	throw "'cleancss' is missing! (sudo npm install clean-css-cli -g)";

cd "$( dirname "${BASH_SOURCE[0]}" )";

pushd "../web-resource/static/highlight.js/styles" || throw "could not goto highlight.js styles directory!";

for name in *.css; do
	if [[ "$name" == *.min.css ]]; then
		continue;
	fi
	newName="${name%%.css}.min.css";
	printf "$name => ";

	cleancss -o "$newName" "$name";
	if [[ "$?" == 0 ]]; then
		printf "$newName\n";
	else
		printf " error!\n";
	fi
done

