#!/bin/bash
PEERTUBE_ROOT_FOLDER="/var/www/peertube"
PEERTUBE_CONFIG=$PEERTUBE_ROOT_FOLDER"/config"
PEERTUBE_STORAGE=$PEERTUBE_ROOT_FOLDER"/storage"
DESTINATION_DIR="/mnt/backup500/Peertube"

PEERTUBE_USERNAME="peertube"
PEERTUBE_DB="peertube_prod"
PEERTUBE_DB_PORT=5432
PEERTUBE_DB_HOST="localhost"

#load my local variable, not needed by everyone
if [ -f local.sh ] 
   then
   source local.sh
fi

mkdir -p "$DESTINATION_DIR"
#save DB
#requires ~/.pgpass file localhost:5432:peertube-db:peertube-db-username:password
pg_dump --format=custom --file "$DESTINATION_DIR/peertube.dump" -p $PEERTUBE_DB_PORT -h $PEERTUBE_DB_HOST -U $PEERTUBE_USERNAME $PEERTUBE_DB 

#save config + storage
rsync -av --del --stats "$PEERTUBE_CONFIG" "$DESTINATION_DIR"
rsync -av --del --stats "$PEERTUBE_STORAGE" "$DESTINATION_DIR"
