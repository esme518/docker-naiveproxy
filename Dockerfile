#
# Dockerfile for naiveproxy
#

FROM golang:alpine as builder

RUN set -ex \
  && go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest \
  && bin/xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive \
  && ./caddy version

FROM alpine

COPY --from=builder /go/caddy /usr/bin/caddy
COPY Caddyfile.init /etc/caddy/Caddyfile.init
COPY docker-entrypoint.sh /entrypoint.sh

RUN set -ex \
  && apk add --update --no-cache \
     ca-certificates \
  && mkdir -p /usr/share/caddy \
  && rm -rf /tmp/* /var/cache/apk/*

ENV DOMAIN example.com
ENV EMAIL me@example.com
ENV USER user
ENV PASSWORD=

WORKDIR /etc/caddy

ENTRYPOINT ["/entrypoint.sh"]
CMD ["caddy","run","--config","/etc/caddy/Caddyfile","--adapter","caddyfile"]
