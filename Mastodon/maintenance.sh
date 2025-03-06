#!/bin/bash
export DOCKER_BUILDKIT=1
#rm mastodon.old -R
cd $1
docker-compose run --rm web bundle exec bin/tootctl media remove
#cd ..
#cp mastodon mastodon.old -R
#cd mastodon
git stash
git pull --rebase
git stash pop
docker-compose build
docker-compose down
docker-compose run --rm web bundle exec rake db:migrate
docker-compose run --rm web bundle exec rake assets:precompile
docker-compose run --rm web bundle exec bin/tootctl cache clear
docker-compose up -d
docker-compose run --rm web bundle exec bin/tootctl search deploy
