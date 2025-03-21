#!/bin/bash
#MASTODON_DATA_FOLDER="/mnt/raid0/phie/mastodon/public"
MASTODON_DOCKER_FOLDER=$1
DESTINATION_DIR=$2
MASTODON_DB_USER=$3
MASTODON_DB=$4
BACKUPNAME=$5
DATE=`date '+%Y-%m-%d %H:%M:%S'`
cd $MASTODON_DOCKER_FOLDER
#save DB
docker exec -i $(sudo docker-compose ps -q db) pg_dump --format=custom --file "dump.sql" -U $MASTODON_DB_USER $MASTODON_DB
docker cp "$(docker-compose ps -q db)":/"dump.sql" ./dump.sql
docker exec -i $(sudo docker-compose ps -q db) rm /"dump.sql"
borg create -p  --files-cache mtime,size "$DESTINATION_DIR"::"${DATE}" dump.sql public docker-compose.yml .env.production --compression=lz4 --exclude public/system/cache
rm dump.sql
borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "$DESTINATION_DIR"
borg compact "$DESTINATION_DIR"




