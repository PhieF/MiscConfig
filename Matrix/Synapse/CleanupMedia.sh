#!/bin/bash

# from https://codeberg.org/DecaTec/Matrix-Synapse-Helpers/raw/branch/main/CleanupMedia.sh

#
# Cleanup of local and remote media
#

# Requirements:
# - The script has to be executed on the same machine where Matrix Synapse is installed.
# - You'll need the domain of your server (variable "serverDomain").
# - For authentication, you will need the access token of your (admin) account.
#   You can obtain it in your Element client: "All settings" > "Help & About" > scroll down > click on "<click to reveal>" to get your access token.
#   Copy this token and paste it further down (variable "token").
#
# You can also specify another time span for deleting media.
# Default is media, which was not accessed over the last 60 days (variable "timestamp60DaysAgo")
#
# You can automate this script via cron, e.g. cleanup every night:
# 0 1 * * * /path/to/scripts/Matrix-Synapse-Helpers/CleanupMedia.sh > /dev/null 2>&1

serverDomain=$1
token=$2
protocol=$3
port=$4
# You may to customize this time span to fit your needs.
timestamp60DaysAgo=$(date +%s000 --date "60 days ago")

if [ -z "$serverDomain" ]
then
      read -pr "Enter the Matrix server domain: (e.g. matrix.mydomain.com): " serverDomain
      echo ""
fi

if [ -z "$token" ]
then
      read -pr "Enter your access token: " token
      echo ""
fi

# Delete local media
echo "Delete local media..."
echo ""
curlUrl="$protocol://localhost:$port/_synapse/admin/v1/media/$serverDomain/delete?before_ts=$timestamp60DaysAgo&access_token=$token"
curl -k -X POST "$curlUrl"
echo ""
echo "Done"
echo ""

# Purge remote media
echo "Purge remote media..."
echo ""
curlUrl="$protocol://localhost:$port/_synapse/admin/v1/purge_media_cache?before_ts=$timestamp60DaysAgo&access_token=$token"
curl -k -X POST "$curlUrl"
echo ""
echo "Done"
echo ""
