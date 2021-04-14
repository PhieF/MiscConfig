#!/bin/bash

IFS=':' read -r -a array <<< "$2"
ssh ${array[0]} "mkdir -p ${array[1]}" || true
parent=`dirname "$1"`
name=`basename "$1"`
cd $parent
borg init $2 --encryption=none || true
DATE=`date '+%Y-%m-%d %H%M%S'`

/home/phie/MiscConfig/borg-linux64 create -p -v --list  "$2"::"$DATE" "$name"
#borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "$2"
