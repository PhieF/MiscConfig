#!/bin/bash

#A script useful to backup a list of folders from a file

#!/bin/bash

if [ "$#" -lt "2" ]
        then 
        echo "Usage backup_folder.sh folder_list_file backupdir [protocol]";
        exit 1
        fi
protocol=""
if [ "$#" -gt "2" ]
        then 
        protocol="-e $3"
else
        mkdir -p "$2"/data/
        fi

while IFS='' read -r line || [[ -n "$line" ]]; do
    name=$(basename "$line")
    rsync -av --del --stats "$line" $protocol "$2"
done < "$1"
