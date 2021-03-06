
#!/bin/bash

if [ "$#" -lt "7" ]
        then 
        echo "Usage nextcloud.sh datadir ncdir dbusername dbpassword database backupdir tmp_mount_name docker_compose_dir [protocol]";
        exit 1
        fi
protocol=""
if [ "$#" -gt "8" ]
        then 
        protocol="-e $9"
        IFS=':' read -r -a array <<< "$6"
        ssh ${array[0]} "mkdir -p ${array[1]}"
else
        mkdir -p "$6"/data/
        fi
cd "$8"
borg init $6 --encryption=none
DATE=`date '+%Y-%m-%d %H%M%S'`
BACKUPNAME="$7"_nextcloud
cd /tmp
mkdir "$BACKUPNAME"
cd "$BACKUPNAME"
mkdir nc
mkdir data
sudo umount /tmp/"$BACKUPNAME"/data | true
sudo umount /tmp/"$BACKUPNAME"/nc | true
sudo mount --bind "$1" /tmp/"$BACKUPNAME"/data
sudo mount --bind "$2" /tmp/"$BACKUPNAME"/nc

cd "$8"
docker-compose exec db sh -c 'mysqldump -u '"$3"' -p'"$4"' '"$5"'  >/"dump.sql"'
docker cp "$(docker-compose ps -q db)":/"dump.sql" /tmp/"$BACKUPNAME"/dump.sql
cd /tmp/"$BACKUPNAME"
#XZ_OPT="--threads=8" tar cfJ "/tmp/$DATE.sql.tar.xz" "/tmp/$DATE.sql"
#rm "/tmp/$DATE.sql"
#scp "/tmp/$DATE.sql.tar.xz" "$6/"
#rm "/tmp/$DATE.sql.tar.xz"
mv "$1"/nextcloud*.log* ./
#rsync -av --del --stats "$1" $protocol "$6"/data
#rsync -av --del --stats "$2" $protocol "$6"/nc
borg create -v --list "$6"::"${DATE}" nc data "dump.sql" --compression=lz4
rm "/tmp/$SQLNAME.sql"
mv nextcloud*.log* "$1"/
borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "$6"
sudo umount /tmp/"$BACKUPNAME"/data | true
sudo umount /tmp/"$BACKUPNAME"/nc | true
