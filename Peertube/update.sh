#!/bin/bash

cd "$1"
cd peertube-latest/scripts && sudo -H -u peertube ./upgrade.sh "$1"
sudo systemctl restart $2
