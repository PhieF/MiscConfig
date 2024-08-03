#!/bin/bash

if [ "$#" -lt "2" ]
        then 
        echo "Usage $0 datadir backupdir";
        exit 1
        fi


DATE=`date '+%Y-%m-%d %H%M%S'`
borg create --stats "$2"::"${DATE}" $1 --compression=lz4
borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "$2"
borg compact "$2"
