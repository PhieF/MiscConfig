#!/bin/bash
MASTODON_DATA_FOLDER="/mnt/raid0/phie/mastodon/public"
MASTODON_CONFIG="/mnt/raid0/docker-compose.yml"
DESTINATION_DIR="phie@palaiseau.phie.ovh:/mnt/sto4to/backup_ovh2/mastodon/"
DB_USERNAME="postgres"
DB="postgres"
DB_PORT=5434
DB_HOST="127.0.0.1"
DATE=`date '+%Y-%m-%d %H:%M:%S'`

#load my local variable, not needed by everyone
if [ -f local.sh ] 
   then
   source local.sh
fi

mkdir -p "$DESTINATION_DIR"
#save DB
#requires ~/.pgpass file localhost:5432:peertube-db:peertube-db-username:password
pg_dump --format=custom --file "/tmp/m$DATE.dump" -p $DB_PORT -h $DB_HOST -U $USERNAME $DB
scp "/tmp/m$DATE.dump" "$DESTINATION_DIR"/
rm "/tmp/m$DATE.dump"
#save config + storage
rsync -av --del --stats "$MASTODON_CONFIG" -e ssh "$DESTINATION_DIR"
rsync -av --del --stats "$MASTODON_DATA_FOLDER" -e ssh "$DESTINATION_DIR"
