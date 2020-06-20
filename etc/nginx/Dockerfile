FROM alpine

MAINTAINER EgoFelix <docker@egofelix.de>

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