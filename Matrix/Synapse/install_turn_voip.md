Enable VOIP in synapse / matrix needs for some device to install a turn server.


November 2019



You will need to have a turn server with AT LEAST version 4.5.1
be aware: ubuntu 18.04 ships with 4.5.0.7
if your debian/ubuntu is more recent, is simple 
```
sudo apt install coturn
```
is enough

install 4.5.1 on ubuntu 18.04:

```
wget http://de.archive.ubuntu.com/ubuntu/pool/universe/h/hiredis/libhiredis0.14_0.14.0-3_amd64.deb
wget http://de.archive.ubuntu.com/ubuntu/pool/universe/c/coturn/coturn_4.5.1.0-1build1_amd64.deb
sudo apt install ./libhiredis0.14_0.14.0-3_amd64.deb
sudo apt install ./coturn_4.5.1.0-1build1_amd64.deb
```

For other arch, see here

https://packages.ubuntu.com/disco/libhiredis0.14
https://packages.ubuntu.com/disco/coturn


once done, edit /etc/turnserver.conf 

uncomment

min-port=49152
max-port=65535
lt-cred-mech
use-auth-secret
static-auth-secret=<insert-random-string>
realm=your-domain-name

if you don't need tcp, uncomment
no-tcp-relay


now edit your matrix config
/etc/matrix-synapse/homeserver.yaml

turn_uris: [ "turn:your-domain-name:port?transport=udp" ] 
here your-domain-name is turn domain name put before, and port is default 3478

turn_shared_secret: <the-random-string-your-put-in-static-auth-secret>
turn_user_lifetime: 1h
