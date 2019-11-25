
#!/bin/bash

if [ "$#" -lt "7" ]
        then 
        echo "Usage nextcloud.sh datadir ncdir dbusername dbpassword database dbport dbserver backupdir [protocol]";
        exit 1
        fi
protocol=""
if [ "$#" -gt "8" ]
        then 
        protocol="-e $9"
else
        mkdir -p "$8"/data/
        fi

DATE=`date '+%Y-%m-%d %H%M%S'`
#requires ~/.pgpass file dbserver:dbport:database:dbusername:dbpassword
pg_dump --format=custom --file "/tmp/$DATE.dump" -p "$6" -h "$7" -U "$3" "$5"
tar cfJ "/tmp/$DATE.dump.tar.xz" "/tmp/$DATE.dump"
rm "/tmp/$DATE.dump"
scp "/tmp/$DATE.dump.tar.xz" "$8/"
rm "/tmp/$DATE.dump.tar.xz"
mv "$1"/nextcloud*.log* ./
rsync -av --del --stats "$1" $protocol "$8"/data
rsync -av --del --stats "$2" $protocol "$8"/nc
mv nextcloud*.log* "$1"/
