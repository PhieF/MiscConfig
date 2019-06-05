### Jenkins Docker
```
docker exec -u root d7f904e8ec51
```

add repo

```
docker exec -u root d7f904e8ec51 wget https://storage.googleapis.com/git-repo-downloads/repo -O /bin/repo
docker exec -u root d7f904e8ec51 chmod +x /bin/repo
```

do it all


```
sudo docker exec -u root `sudo docker ps | grep jenkins | sed -e 's/^\(.\{12\}\).*/\1/'` wget https://storage.googleapis.com/git-repo-downloads/repo -O /bin/repo && sudo docker exec -u root `sudo docker ps | grep jenkins | sed -e 's/^\(.\{12\}\).*/\1/'` chmod +x /bin/repo

```



### Nextcloud

build

make dev-setup

make build-js
