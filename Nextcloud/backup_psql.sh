
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
tar cfJ "/tmp/$DATE.dump.tar.xz" "/tmp/$DATE.dump"
rm "/tmp/$DATE.dump"
scp "/tmp/$DATE.dump.tar.xz" "$7/"
rm "/tmp/$DATE.dump.tar.xz"
mv "$1"/nextcloud*.log* ./
rsync -av --del --stats "$1" $protocol "$7"/data
rsync -av --del --stats "$2" $protocol "$7"/nc
mv nextcloud*.log* "$1"/
