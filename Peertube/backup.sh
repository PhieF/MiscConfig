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
else
        mkdir -p "$8"/data/
fi
mkdir -p "$DESTINATION_DIR"
#save DB
#requires ~/.pgpass file localhost:5432:peertube-db:peertube-db-username:password
pg_dump --format=custom --file "/tmp/peertube $DATE.dump" -p $PEERTUBE_DB_PORT -h $PEERTUBE_DB_HOST -U $PEERTUBE_USERNAME $PEERTUBE_DB
tar cfJ "/tmp/$DATE.dump.tar.xz" "/tmp/peertube $DATE.dump"
scp "/tmp/$DATE.dump.tar.xz" "$DESTINATION_DIR"
rm "/tmp/$DATE.dump.tar.xz" "/tmp/peertube $DATE.dump"

#save config + storage
rsync -av --del --stats "$PEERTUBE_CONFIG" "$DESTINATION_DIR/data/config"
rsync -av --del --stats "$PEERTUBE_STORAGE" "$DESTINATION_DIR/data/storage"
