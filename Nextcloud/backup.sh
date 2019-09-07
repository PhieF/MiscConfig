
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
mysqldump -u "$3" -p"$4" "$5"  > "$DATE.sql"
tar cfJ "$DATE.sql.tar.xz" "$DATE.sql"
rm "$DATE.sql"
scp "$DATE.sql.tar.xz" "$6/"
rm "$DATE.sql.tar.xz"
mv "$1"/nextcloud*.log* ./
rsync -av --del --stats "$1" $protocol "$6"/data
rsync -av --del --stats "$2" $protocol "$6"/nc
mv nextcloud*.log* "$1"/
