#!/usr/bin/env bash

cd "$( dirname "${BASH_SOURCE[0]}" )";
cd ../useful-commands;

list="";
current_line="";
for i in *.sh; do
	current_line="${current_line}${i%.sh}";
	if [[ "${#current_line}" -gt 60 ]]; then
		list="${list}${current_line}\n\t\t";
		current_line="";
	else
		current_line="${current_line} ";
	fi
done;

list="${list}${current_line}";
printf "$list\n";
