sudo docker run -t  --net="host" -d -p 9980:9980 -e 'domain=domain1|domain2' --restart always --cap-add MKNOD collabora/code

