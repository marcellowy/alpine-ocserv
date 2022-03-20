From alpine:latest
MAINTAINER Ryo

# timezone
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
	&& cd \
	&& rm -fr ./$OC_FILE \
	&& apk del --purge $buildDeps

WORKDIR /root

COPY docker-entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]

CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]
