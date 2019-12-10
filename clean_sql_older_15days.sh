#!/bin/bash

cd $1
find . -maxdepth 1 -type f -mtime +15 -name '*.xz' -exec rm "{}" \;
find . -maxdepth 1 -type f -mtime +15 -name '*.dump' -exec rm "{}" \;
