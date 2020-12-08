
#!/bin/bash

if [ "$#" -lt "5" ]
        then 
        echo "Usage nextcloud.sh datadir ncdir dbusername dbpassword database backupdir [protocol]";
        exit 1
        fi
protocol=""
if [ "$#" -gt "6" ]
        then 
        protocol="-e $7"
        IFS=':' read -r -a array <<< "$6"
        ssh ${array[0]} "mkdir -p ${array[1]}"
else
        mkdir -p "$6"/data/
        fi
borg init $6 --encryption=none
DATE=`date '+%Y-%m-%d %H%M%S'`
BACKUPNAME=`basename "$2"_nextcloud`
cd /tmp
mkdir "$BACKUPNAME"
cd "$BACKUPNAME"
mkdir nc
mkdir data
sudo mount --bind "$1" /tmp/"$BACKUPNAME"/data
sudo mount --bind "$2" /tmp/"$BACKUPNAME"/nc

mysqldump -u "$3" -p"$4" "$5"  > "dump.sql"
#XZ_OPT="--threads=8" tar cfJ "/tmp/$DATE.sql.tar.xz" "/tmp/$DATE.sql"
#rm "/tmp/$DATE.sql"
#scp "/tmp/$DATE.sql.tar.xz" "$6/"
#rm "/tmp/$DATE.sql.tar.xz"
mv "$1"/nextcloud*.log* ./
#rsync -av --del --stats "$1" $protocol "$6"/data
#rsync -av --del --stats "$2" $protocol "$6"/nc
borg create -v --stats "$6"::"${DATE}" nc data "dump.sql" --compression=lz4
rm "/tmp/$SQLNAME.sql"
mv nextcloud*.log* "$1"/
borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "$6"
