#!/bin/bash
if [ "$#" -lt "8" ]
        then 
        echo "Usage backup.sh peertube_dir config_dir storage_dir dbusername db_port db_server database backupdir [protocol]";
        exit 1
        fi


PEERTUBE_ROOT_FOLDER=$1
PEERTUBE_CONFIG=$2
PEERTUBE_STORAGE=$3
DESTINATION_DIR=$8

PEERTUBE_USERNAME=$4
PEERTUBE_DB=$7
PEERTUBE_DB_PORT=$5
PEERTUBE_DB_HOST=$6
DATE=`date '+%Y-%m-%d %H:%M:%S'`

protocol=""
if [ "$#" -gt "8" ]
        then 
        protocol="-e $9"
	IFS=':' read -r -a array <<< "$DESTINATION_DIR"
	ssh ${array[0]} "mkdir -p ${array[1]}/data/config"
        ssh ${array[0]} "mkdir -p ${array[1]}/data/storage"
else
        mkdir -p "$8"/data/
fi
#mkdir -p "$DESTINATION_DIR"
#save DB
#requires ~/.pgpass file localhost:5432:peertube-db:peertube-db-username:password
mkdir "/tmp/$DATE/"
pg_dump --format=custom --file "/tmp/$DATE/dump.sql" -p $PEERTUBE_DB_PORT -h $PEERTUBE_DB_HOST -U $PEERTUBE_USERNAME $PEERTUBE_DB
scp "/tmp/$DATE/dump.sql" "$DESTINATION_DIR"
rm "/tmp/$DATE/dump.sql"

#save config + storage
rsync -av --del --stats "$PEERTUBE_CONFIG" "$DESTINATION_DIR/data/config"
rsync -av --del --stats "$PEERTUBE_STORAGE" "$DESTINATION_DIR/data/storage"
