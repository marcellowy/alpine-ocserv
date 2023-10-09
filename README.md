# Alpine-Ocserv
Ocserv VPN docker image based on Alpine Linux

Forked from https://github.com/soniclidi/alpine-ocserv

Some codes from https://github.com/TommyLau/docker-ocserv

no-route list from https://github.com/CNMan/ocserv-cn-no-route

# Usage
via build command:
```shell
# build
docker build --rm -t alpine-ocserv:0.0.1 .
# run
docker run --privileged=true -p 30443:443 -v /etc/ocserv:/etc/ocserv -itd alpine-ocserv:0.0.1
```

via docker hub image:
```shell
# pull image
docker pull docker push lovewy123/alpine-ocserv:latest
# run
docker run --privileged=true -p 30443:443 -v /etc/ocserv:/etc/ocserv -itd alpine-ocserv:latest
```

via Dockerfile:
```yaml
version: "3.5"
services:
  ocserv:
    privileged: true
    image: alpine-ocserv:0.0.1 # or use docker hub image: lovewy123/alpine-ocserv:latest
    container_name: ocserv
    restart: always
    ports:
      - "443:443"
    volumes:
      - /etc/ocserv:/etc/ocserv
    networks:
      - "light-network" 
networks:
  light-network:
    driver: bridge
```
<span style="color: #cb5b5b">
Note: copy "/etc/ocserv" to your server path and don't forgot modify server-key.pem and server server-cert.pem
</span>

# How to Add/Delete user
```shell
# Add new user: 
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd foo
# input password for user "foo"

# Delete user: 
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -d test
```

# Version
- update ocserv to 1.2.2 @10/09/2023 

# Licence
MIT