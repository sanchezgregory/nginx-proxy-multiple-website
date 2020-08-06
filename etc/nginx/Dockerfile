FROM alpine:3.7

MAINTAINER EgoFelix <docker@egofelix.de>

# ensure www-data user exists
RUN set -x ; \
  addgroup -g 82 -S www-data ; \
  adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1
# 82 is the standard uid/gid for "www-data" in Alpine

# Install nginx
RUN apk --no-cache add \
    nginx nginx-mod-stream \
    && \
    mkdir -p /run/nginx/ /etc/nginx/sites-enabled/ /var/log/nginx/ && \
    touch /etc/nginx/global.conf && \
    touch /etc/nginx/modules.conf

# Install config
COPY nginx.conf /etc/nginx/nginx.conf

VOLUME ["/etc/nginx/site-enabled", "/etc/nginx/includes", "/etc/nginx/certs", "/etc/nginx/conf"]

# Entry
HEALTHCHECK  --interval=30s --timeout=5s CMD wget --quiet --tries=1 --spider http://127.0.0.1/ || exit 1
ENTRYPOINT /usr/sbin/nginx -g 'daemon off;'