#/bin/bash

#usage
#restore.sh nextcloud_install_path [-f] [root-database-password] 
set -e
dbuser=`echo "<?php include('nc/config/config.php'); echo \\$CONFIG['dbuser'];" |php`
dbpassword=`echo "<?php include('nc/config/config.php'); echo \\$CONFIG['dbpassword'];" |php`
dbname=`echo "<?php include('nc/config/config.php'); echo \\$CONFIG['dbname'];" |php`
datadirectory=`echo "<?php include('nc/config/config.php'); echo \\$CONFIG['datadirectory'];" |php`


if [ "$2" != "-f" ]
then
read -p "This script will drop $dbname database and delete this user $dbuser then recreate then with the backup, delete everything in $datadirectory and replace files with backup, are you sure you want to continue ? " -n 1 -r
echo
else
REPLY="y"
fi

if [[ $REPLY =~ ^[Yy]$ ]]
then
    mysql -u root -p$3 -e "DROP DATABASE IF EXISTS $dbname; DROP USER IF EXISTS '$dbuser'@'localhost'; CREATE DATABASE $dbname; CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpassword';GRANT ALL ON $dbname.* TO '$dbuser'@'localhost';FLUSH PRIVILEGES;"
   sudo rm "$datadirectory" -r
   sudo mkdir "$(dirname "$datadirectory")" -p
   sudo cp data "$datadirectory" -R
   sudo chown www-data "$datadirectory"
   sudo rm "$1" -R
   sudo mkdir "$(dirname "$1")" -p
   sudo cp nc "$1" -R
   sudo chown www-data "$1" -R
   
fi

