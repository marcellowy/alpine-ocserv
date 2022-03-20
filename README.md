# alpine-ocserv
Ocserv VPN docker image based on Alpine Linux

Forked from https://github.com/soniclidi/alpine-ocserv

Some codes from https://github.com/TommyLau/docker-ocserv

no-route list from https://github.com/CNMan/ocserv-cn-no-route

# useage

```
# build
docker build --rm -t alpine-ocserv:0.0.1 .

# run
docker run --name ocserv --privileged -p 443:443 -d alpine-ocserv:0.0.1
```

add user: docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd newuser

delete user: docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -d test
