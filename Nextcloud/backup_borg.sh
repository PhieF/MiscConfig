
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
else
        mkdir -p "$6"/data/
        fi

DATE=`date '+%Y-%m-%d %H%M%S'`
SQLNAME=`basename "$2"`
echo $6
mysqldump -u "$3" -p"$4" "$5"  > "/tmp/$SQLNAME.sql"
#XZ_OPT="--threads=8" tar cfJ "/tmp/$DATE.sql.tar.xz" "/tmp/$DATE.sql"
#rm "/tmp/$DATE.sql"
#scp "/tmp/$DATE.sql.tar.xz" "$6/"
#rm "/tmp/$DATE.sql.tar.xz"
mv "$1"/nextcloud*.log* ./
#rsync -av --del --stats "$1" $protocol "$6"/data
#rsync -av --del --stats "$2" $protocol "$6"/nc
borg create -v --stats "$6"::"${DATE}" "$1" "$2" "/tmp/$SQLNAME.sql" --compression=lz4
rm "/tmp/$SQLNAME.sql"
mv nextcloud*.log* "$1"/
borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "$6"
