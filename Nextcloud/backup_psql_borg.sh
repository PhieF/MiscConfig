
#!/bin/bash

if [ "$#" -lt "7" ]
        then 
        echo "Usage nextcloud.sh datadir ncdir dbusername database dbport dbserver backupdir tmp_mount_name [protocol]";
        exit 1
        fi
protocol=""
if [ "$#" -gt "8" ]
        then 
        protocol="-e $9"
        IFS=':' read -r -a array <<< "$7"
        ssh ${array[0]} "mkdir -p ${array[1]}"
else
        mkdir -p "$7"/data/
        fi
borg init $7 --encryption=none
DATE=`date '+%Y-%m-%d %H%M%S'`
BACKUPNAME="$8"_nextcloud
cd /tmp
mkdir "$BACKUPNAME"
cd "$BACKUPNAME"
mkdir nc
mkdir data
sudo umount -R /tmp/"$BACKUPNAME"/data || true
sudo umount -R /tmp/"$BACKUPNAME"/nc || true
sudo mount --rbind "$1" /tmp/"$BACKUPNAME"/data
sudo mount --rbind "$2" /tmp/"$BACKUPNAME"/nc
sudo mount --make-rslave /tmp/"$BACKUPNAME"/data
sudo mount --make-rslave /tmp/"$BACKUPNAME"/nc

#requires ~/.pgpass file dbserver:dbport:database:dbusername:dbpassword
pg_dump --format=custom --file "sql.dump" -p "$5" -h "$6" -U "$3" "$4"
mv "$1"/nextcloud*.log* ./

borg create -v --stats --files-cache mtime,size --list "$7"::"${DATE}" nc data "sql.dump" --compression=lz4 --exclude 'data/nextcloud.log*'
rm "sql.dump"
borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "$7"
sudo umount -R /tmp/"$BACKUPNAME"/nc
sudo umount -R /tmp/"$BACKUPNAME"/data
