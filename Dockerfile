From alpine:latest
MAINTAINER Ryo

# china timezone
ENV TZ=Asia/Shanghai
RUN echo $TZ > /etc/timezone

RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
	&& echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories 

RUN apk update && apk add gnutls-utils musl-dev iptables gnutls-dev readline-dev libnl3-dev lz4-dev libseccomp-dev@testing protobuf-c-dev libev-dev

RUN buildDeps="xz openssl gcc autoconf make linux-headers"; \
	set -x \
	&& apk add $buildDeps \
	&& cd \
	&& wget https://ocserv.gitlab.io/www/download.html -O download.html \
	&& OC_VERSION=`cat download.html | grep -o '[0-9]*\.[0-9]*\.[0-9]*'` \
	&& OC_FILE="ocserv-$OC_VERSION" \
	&& rm -fr download.html \
	&& wget ftp://ftp.infradead.org/pub/ocserv/$OC_FILE.tar.xz \
	&& tar xJf $OC_FILE.tar.xz \
	&& rm -fr $OC_FILE.tar.xz \
	&& cd $OC_FILE \
	&& sed -i '/#define DEFAULT_CONFIG_ENTRIES /{s/96/200/}' src/vpn.h \
	&& ./configure \
	&& make -j"$(nproc)" \
	&& make install \
	&& mkdir -p /etc/ocserv \
	&& cp ./doc/sample.config /etc/ocserv/ocserv.conf \
	&& cd \
	&& rm -fr ./$OC_FILE \
	&& apk del --purge $buildDeps

RUN set -x \
	&& sed -i 's/\.\/sample\.passwd/\/etc\/ocserv\/ocpasswd/' /etc/ocserv/ocserv.conf \
	&& sed -i 's/\(max-same-clients = \)2/\110/' /etc/ocserv/ocserv.conf \
	&& sed -i 's/\.\.\/tests\/certs/\/etc\/ocserv/' /etc/ocserv/ocserv.conf \
    	&& sed -i 's/server-cert-secp521r1.pem/server-cert.pem/' /etc/ocserv/ocserv.conf \
    	&& sed -i 's/server-key-secp521r1.pem/server-key.pem/' /etc/ocserv/ocserv.conf \
	&& sed -i 's/#\(compression.*\)/\1/' /etc/ocserv/ocserv.conf \
	&& sed -i '/^ipv4-network = /{s/192.168.1.0/192.168.99.0/}' /etc/ocserv/ocserv.conf \
	&& sed -i 's/192.168.1.2/8.8.8.8/' /etc/ocserv/ocserv.conf \
	&& sed -i 's/^route/#route/' /etc/ocserv/ocserv.conf \
	&& sed -i 's/^no-route/#no-route/' /etc/ocserv/ocserv.conf

WORKDIR /etc/ocserv

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]
