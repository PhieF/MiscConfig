ervice "database" is using volume "/var/lib/postgresql/data" from the previous container

fix 


sudo docker-compose rm database

to restore I first relaunch an empty weblate docker, then rsync the containers content to volumes
