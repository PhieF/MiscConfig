#!/bin/bash

cd mastodon
docker-compose run --rm web bundle exec bin/tootctl media remove
cd ..
cp mastodon mastodon.old -R
cd mastodon
git stash
git pull --rebase
git stash pop
docker-compose build
docker-compose down
docker-compose run --rm web bundle exec rake db:migrate
docker-compose run --rm web bundle exec rake assets:precompile
docker-compose up -d
