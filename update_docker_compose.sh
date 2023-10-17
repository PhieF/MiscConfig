#/bin/bash
cd $1
docker-compose pull
docker-compose down
docker-compose up -d

