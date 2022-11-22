#
# Dockerfile for naiveproxy
#

FROM caddy:builder as builder

RUN set -ex \
  && xcaddy build \
  --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive

FROM alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY Caddyfile.init /etc/caddy/Caddyfile.init
COPY docker-entrypoint.sh /entrypoint.sh

RUN set -ex \
  && apk add --update --no-cache \
     ca-certificates \
  && rm -rf /tmp/* /var/cache/apk/*

ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

ENV ADDRESS example.com
ENV EMAIL me@example.com
ENV USER user
ENV PASSWORD=

EXPOSE 443
EXPOSE 443/udp

WORKDIR /etc/caddy

ENTRYPOINT ["/entrypoint.sh"]
CMD ["caddy","run","--config","/etc/caddy/Caddyfile","--adapter","caddyfile"]
