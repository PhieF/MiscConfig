#!/bin/bash

SRCDIR="/home/phoenamandre/testphotocopy/src"
DESTDIR="/home/phoenamandre/testphotocopy/dest"
DEPOT="/home/phoenamandre/testphotocopy/dest/depot"
minimumsize=1000000;# at least 1mo
md5array=()
at_least_one_file=0

while read file
do
	if [ "$file" != "" ] && [ $(wc -c <"$file") -ge $minimumsize ]
	then
		echo $(wc -c <"$file")
		at_least_one_file=1
		break;

	fi
done <<< "$(find "$SRCDIR/." -iname '*.jpg' -o -iname '*.png' -o -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.mov' )";
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
done <<< "$(find "$DESTDIR/." -iname '*.jpg' -o -iname '*.png' -o -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.mov')"

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

