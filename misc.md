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




# Stream movie with subs to rtmp with cvlc

```
cvlc --sub-file subtitles.srt -vvv "movie.mp4" --sout '#transcode{vcodec=h264,scale=Auto,width=1280,height=720,acodec=mp3,ab=128,channels=2,samplerate=44100,soverlay}:std{access=rtmp,mux=ffmpeg{mux=flv},dst=rtmp://address}'

```

Better caching

```
cvlc --sub-file subtitles.srt -vvv "movie.mp4" --sout '#transcode{vcodec=x264,acodec=mp3,ab=320,channels=2,samplerate=44100,soverlay}:std{access=rtmp,mux=ffmpeg{mux=flv},dst=rtmp://address}' --rtp-caching=30000 --udp-caching=30000 --sout-mux-caching=15000 --http-caching=30000 --tcp-caching=30000 --file-caching=10000
```
