
#!/bin/bash

if [ "$#" -lt "6" ]
        then 
        echo "Usage nextcloud.sh datadir ncdir dbusername database dbport dbserver backupdir [protocol]";
        exit 1
        fi
protocol=""
if [ "$#" -gt "7" ]
        then 
        protocol="-e $8"
        IFS=':' read -r -a array <<< "$7"
        ssh ${array[0]} "mkdir -p ${array[1]}"
else
        mkdir -p "$7"/data/
        fi
borg init $7 --encryption=none
DATE=`date '+%Y-%m-%d %H%M%S'`
BACKUPNAME=`basename "$1"`_nextcloud
cd /tmp
mkdir "$BACKUPNAME"
cd "$BACKUPNAME"
mkdir nc
mkdir data
sudo mount --bind "$1" /tmp/"$BACKUPNAME"/data
sudo mount --bind "$2" /tmp/"$BACKUPNAME"/nc

#requires ~/.pgpass file dbserver:dbport:database:dbusername:dbpassword
pg_dump --format=custom --file "sql.dump" -p "$5" -h "$6" -U "$3" "$4"
mv "$1"/nextcloud*.log* ./

borg create -v --stats "$7"::"${DATE}" nc data "sql.dump" --compression=lz4
rm "sql.dump"
borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "$7"
sudo umount /tmp/"$BACKUPNAME"/nc
sudo umount /tmp/"$BACKUPNAME"/data
