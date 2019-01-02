#!/bin/bash

# This script analyses a source folder to check if photos and videos are already in your photos folder and if they are not, it
# puts them in the destination folder ordering them by date

# Example:
# /Photos is your photo folders, ordered as you wish
# /RawPhotos are your photos you want to order or check if they are already in /Photos
# /Photos/Uploads is the photo folder you want the script to put the ordered by date photos of /RawPhotos
# then execute 'bash script.sh /RawPhotos /Photos /Photos/Uploads'
if [ "$#" -lt "3" ]
	then 
	echo "Usage script.sh photo-to-sort whole-photo-folder depot";
	exit 1
	fi
SRCDIR=$1
DESTDIR=$2
DEPOT=$3

minimumsize=100000;# at least 1mo
md5array=()
at_least_one_file=0

while read file
do
	if [ "$file" != "" ] && [ $(wc -c <"$file") -ge $minimumsize ]
	then
		at_least_one_file=1
		break;
	fi
done <<< "$(find "$SRCDIR/." -iname '*.jpg' -o -iname '*.png' -o -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.mov' -o -iname '*.avi'  -o -iname '*.bmp')";
echo $at_least_one_file
if [ "$at_least_one_file" == "0" ]
then
	exit 0
fi
while read file2
do
	echo $file2;
	if [ "$file2" != "" ]
	 then
		md5_f2=($(md5sum "$file2"))
		md5array+=("$md5_f2")
	fi;
done <<< "$(find "$DESTDIR/." -iname '*.jpg' -o -iname '*.png' -o -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.mov' -o -iname '*.avi' -o -iname '*.bmp')"

find "$SRCDIR/." -iname '*.jpg' -o -iname '*.png' -o -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.mov' | while read file
do
	if [ $(wc -c <"$file") -ge $minimumsize ]
	then
		REPERTOIRE=`dirname "$file"`
		NAME=`basename "$file"`
		EXTNORM="${NAME##*.}"
		EXT=${EXTNORM,,}
		NAMEWITHOUTEXT="${NAME%.*}"
		md5=($(md5sum "$file"))
		found=0
		if [[ " ${md5array[@]} " =~ " ${md5} " ]]; then
			echo "found"
			found=1
		fi
		if [ $found == 0 ]
		then
			echo "not found :("
			DATEBITS=( $(exiftool -CreateDate -FileModifyDate -DateTimeOriginal "$file" | awk -F: '{ print $2 ":" $3 ":" $4 ":" $5 ":" $6 }' | sed 's/+[0-9]*//' | sort | grep -v 1970: | cut -d: -f1-6 | tr ':' ' ' | head -1) )
			YR=${DATEBITS[0]}
			MTH=${DATEBITS[1]}
			DAY=${DATEBITS[2]}
			echo $YR;
			dest_dir="$DEPOT"/"$YR"/"$MTH"/"$DAY"
			mkdir -p "$dest_dir"
			mv "$file" "$dest_dir"/"$NAME"
		else
			rm "$file"
		fi
	fi
done;

