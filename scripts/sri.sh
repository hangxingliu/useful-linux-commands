#!/usr/bin/env bash

cd "$( dirname "${BASH_SOURCE[0]}" )";
cd ../web-resource/static;

find . -name "*.css" -o -name "*.js" |
	awk '/\.\/.+\//' | # located in directory
	xargs -I __file__ sh -c 'echo __file__; shasum -b -a 384 __file__ | xxd -r -p | base64; echo "";'
