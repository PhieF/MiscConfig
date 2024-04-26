26/04/24

Nextcloud failing when downloading more than 1024mo ?
Add this to your nginx reverse proxy conf:

        proxy_max_temp_file_size 16384m;



15/04/24

An Ardour Story....

I've recorded 12 hours of audio on Sartuday's Evening for the XUL Festival, without noticing that records are done in Wave, which is a 32bits format limited to 3,9gB files, so around 6 hours 12 minutes
Ardour continued writing into files so files were about 8 gB but only 3,9 readable 

fortunately, I was able to recover files using sndfile-salvage
```
sudo apt install sndfile-programs
sndfile-salvage wave-file-incomplete.wav new-working-file.w64

```

And... fixed !

18/10/23

How to... turn your robot vacuum into a web server :D

this website is currently running on my robot vacuum: https://robot.salcie.fi

This is a Viomi v2

The first thing I did was following this tutorial to get a root acccess through ssh:

https://github.com/Hypfer/valetudo-crl200s-root#5-install-valetudo

Then I've just pushed a simple http server binary from here https://github.com/TheWaWaR/simple-http-server

```
cat armv7-unknown-linux-musleabihf-simple-http-server | ssh root@ip "cat > /root/armv7-unknown-linux-musleabihf-simple-http-server"
```
and ran the server !

That's it :D 

Stupid but funny



About choosing S3QL over usual S3:

Peertube doesn't allow yet to switch S3 providers OR to go back to local storage, that explain yesterday's choice


17/10/23


First thing:

fixed my peertube chat by adding
```
  # Plugin websocket routes
  location ~ ^/plugins/[^/]+(/[^/]+)?/ws/ {
    try_files /dev/null @api_websocket;
  }
```
to the nginx conf 

Also moved everything to s3ql  with a weird conf

hope it will hold

my conf file:
```
[Unit]
Description=mount s3ql filesystem
Wants=network-online.target

[Service]
#Type=forking
ExecStartPre=fsck.s3ql --authfile /root/passsssssssss s3c://blabla --force --keep-cache --quiet --cachedir /home/s3ql-cache/
ExecStart=mount.s3ql --cachesize 10485760  --authfile /root/passsssssssss s3c://blabla /mnt/s3/exode.me/ --allow-other --cachedir /home/s3ql-cache/ --keep-cache --systemd
ExecStop=umount.s3ql /mnt/s3/exode.me
ExecStopPost=/bin/bash -c "umount /mnt/s3/exode.me || true"
ExecStopPost=/bin/bash -c "umount /home/blabla/docker/exode/docker-volume/data/streaming-playlists || true"
ExecStopPost=/bin/bash -c "umount /home/blabla/docker/exode/docker-volume/data/videos || true"
ExecStopPost=/bin/bash -c "umount /home/blabla/docker/exode/docker-volume/data/torrents || true"
ExecStopPost=/bin/bash -c "umount /home/blabla/docker/exode/docker-volume/data/redundancy || true"
TimeoutSec=900
Restart=always
RestartSec=5s



[Install]
WantedBy=multi-user.target
```

