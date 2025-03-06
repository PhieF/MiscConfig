
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
        mkdir -p "$6"
        fi
cd "$8"
borg init $6 --encryption=none
DATE=`date '+%Y-%m-%d %H%M%S'`
timestamp=$(date +%s)
BACKUPNAME="$7"_nextcloud

cd "$8"
docker-compose exec -T db sh -c 'mysqldump -u '"$3"' -p'"$4"' '"$5"'  >/"dump.sql"'
docker cp "$(docker-compose ps -q db)":/"dump.sql" ./dump.sql
cp docker-compose.yml /tmp/"$BACKUPNAME"/
docker-compose exec -T db sh -c 'rm /"dump.sql"'
borg create  "$6"::"${DATE}" * --compression=lz4 --verbose --exclude '*/nextcloud.log*'
rm dump.sql
borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "$6"
borg compact  "$6"
