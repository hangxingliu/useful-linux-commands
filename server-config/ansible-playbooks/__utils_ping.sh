#!/usr/bin/env bash

# checkout to directory same with this script
__DIRNAME=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`;
cd "$__DIRNAME" > /dev/null;

# ping test
ansible all -i ../hosts -m ping;
exit $?;
