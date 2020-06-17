#!/bin/bash

cd $1

count=`find . -maxdepth 1 -type f -mtime -15 -name '*.xz' -printf '.' | wc -c`
if [ $count -gt 5 ]
then
   find . -maxdepth 1 -type f -mtime +15 -name '*.xz' -exec rm "{}" \;
fi
count=`find . -maxdepth 1 -type f -mtime -15 -name '*.dump' -printf '.' | wc -c`
if [ $count -gt 5 ]
then
   find . -maxdepth 1 -type f -mtime +15 -name '*.dump' -exec rm "{}" \;
fi

