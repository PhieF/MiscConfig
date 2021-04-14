#!/bin/bash
set -e

if [ "$#" -lt "9" ]
        then 
        echo "Usage backup.sh peertube_dir config_dir storage_dir dbusername db_port db_server database backupdir tmpname [protocol]";
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
if [ "$#" -gt "9" ]
        then 
        protocol="-e $10"
	IFS=':' read -r -a array <<< "$DESTINATION_DIR"
        ssh ${array[0]} "mkdir -p ${array[1]}" || true
else
        mkdir -p "$8"/data/
fi


borg init $8 --encryption=none || true
DATE=`date '+%Y-%m-%d %H%M%S'`
BACKUPNAME=$9
cd /tmp
mkdir "$BACKUPNAME" || true
cd "$BACKUPNAME"
mkdir config || true
mkdir storage || true
umount -R /tmp/"$BACKUPNAME"/config || true
umount -R /tmp/"$BACKUPNAME"/storage || true
sudo mount --rbind "$2" /tmp/"$BACKUPNAME"/config
sudo mount --rbind "$3" /tmp/"$BACKUPNAME"/storage
sudo mount --make-rslave /tmp/"$BACKUPNAME"/config
sudo mount --make-rslave /tmp/"$BACKUPNAME"/storage

#requires ~/.pgpass file localhost:5432:peertube-db:peertube-db-username:password
pg_dump --format=custom --file "dump.sql" -p $PEERTUBE_DB_PORT -h $PEERTUBE_DB_HOST -U $PEERTUBE_USERNAME $PEERTUBE_DB
#save config + storage
borg create -v -p --list --files-cache mtime,size "$8"::"${DATE}" config storage "dump.sql" --compression=lz4
borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "$8"
umount -R /tmp/"$BACKUPNAME"/config
umount -R /tmp/"$BACKUPNAME"/storage
cd /tmp
#rm /tmp/"$BACKUPNAME" -R
