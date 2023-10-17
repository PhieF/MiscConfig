
#!/bin/bash

if [ "$#" -lt "6" ]
        then 
        echo "Usage $0 datadir synapse_conf_dir dbusername database dbport dbserver backupdir tmp_name [protocol]";
        exit 1
        fi
protocol=""
if [ "$#" -gt "8" ]
        then 
        protocol="-e $9"
        IFS=':' read -r -a array <<< "$7"
        ssh ${array[0]} "mkdir -p ${array[1]}"
        borg init $7 --encryption=none
else
        mkdir -p "$7"/data/
        fi

DATE=`date '+%Y-%m-%d %H%M%S'`
BACKUPNAME=`basename "$8"`_synapse
cd /tmp
mkdir /tmp/"$BACKUPNAME"/data -p
mkdir /tmp/"$BACKUPNAME"/synapse_conf -p
cd "$BACKUPNAME"
mount --bind "$1" /tmp/"$BACKUPNAME"/data
mount --bind "$2" /tmp/"$BACKUPNAME"/synapse_conf
#requires ~/.pgpass file dbserver:dbport:database:dbusername:dbpassword
pg_dump --format=custom  -p "$5" -h "$6" -U "$3" "$4" > "/tmp/$BACKUPNAME/psql.dump"


borg create --stats "$7"::"${DATE}" data synapse_conf psql.dump --compression=lz4
umount /tmp/"$BACKUPNAME"/data 
umount /tmp/"$BACKUPNAME"/synapse_conf
rm "/tmp/$BACKUPNAME/psql.dump"
borg prune --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "$7"
