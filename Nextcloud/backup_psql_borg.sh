
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
else
        mkdir -p "$7"/data/
        fi

DATE=`date '+%Y-%m-%d %H%M%S'`
#requires ~/.pgpass file dbserver:dbport:database:dbusername:dbpassword
pg_dump --format=custom --file "/tmp/$DATE.dump" -p "$5" -h "$6" -U "$3" "$4"
mv "$1"/nextcloud*.log* ./

borg create -v --stats "$7"::"${DATE}" "$1" "$2" "/tmp/$DATE.dump" --compression=lz4
rm "/tmp/$DATE.dump"
borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "$7"
