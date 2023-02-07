# alpine-ocserv
Ocserv VPN docker image based on Alpine Linux

Forked from https://github.com/soniclidi/alpine-ocserv

Some codes from https://github.com/TommyLau/docker-ocserv

no-route list from https://github.com/CNMan/ocserv-cn-no-route

# useage

command:
```
# build
docker build --rm -t alpine-ocserv:0.0.1 .

# run
docker run --privileged=true -p 30443:443 -v /etc/ocserv:/etc/ocserv -itd alpine-ocserv:0.0.1
```

dockerfile:
```
version: "3.5"
services:
  ocserv:
    privileged: true
    image: alpine-ocserv:0.0.1
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


Note: copy "/etc/ocserv" to your server and don't forgot modify server-key.pem and server server-cert.pem

add new user: docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd newuser

delete user: docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -d test
