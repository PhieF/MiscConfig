#!/bin/bash

SRCDIR="/home/phoenamandre/testphotocopy/src"
DESTDIR="/home/phoenamandre/testphotocopy/dest"
DEPOT="/home/phoenamandre/testphotocopy/dest/depot"
minimumsize=1000000;# at least 1mo


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
		while read file2
		do
			if [ "$file2" != "" ]
			 then
				md5_f2=($(md5sum "$file2"))
				if [ "$md5" == "$md5_f2" ]
				then
					echo $file2;
					found=1
				fi	
			fi;
		done <<< "$(find "$DESTDIR/." -iname "$NAME")"
		if [ $found == 0 ]
		then
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
