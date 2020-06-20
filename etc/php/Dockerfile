FROM php:7.1.4-fpm-alpine

MAINTAINER Lyberteam <lyberteamltd@gmail.com>
LABEL Vendor="Lyberteam"
LABEL Description="PHP-FPM v7.1.4-alpine"
LABEL Version="1.0.1"

RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
    nano mysql-client curl mc libmcrypt libmcrypt-dev libxml2-dev g++ make autoconf  sqlite sqlite-dev \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} gd mcrypt pdo pdo_mysql pdo_sqlite soap bcmath mbstring \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-source extract delete \
    && apk del --no-cache freetype freetype-dev libpng libpng-dev libjpeg-turbo libjpeg-turbo-dev \
    && rm -rf /tmp/* \
    && rm -f /usr/local/etc/php-fpm.d/www.conf.default \
    && rm -f /usr/local/etc/php-fpm.d/www.conf \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD www.conf /usr/local/etc/php-fpm.d/
COPY php.ini /usr/local/etc/php/

USER www-data

CMD ["php-fpm"]

## Let's set the working dir
WORKDIR /var/www/html/

EXPOSE 9000

#
######################################## Other extensions ########################################
# Install composer globally
#RUN echo "Install composer globally"
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
#
## Install phpredis 2.2.7
#RUN apt-get install -y unzip
#WORKDIR /root
#COPY phpredis-2.2.7.zip phpredis-2.2.7.zip
#RUN unzip phpredis-2.2.7.zip
#WORKDIR phpredis-2.2.7
#RUN phpize
#RUN ./configure
#RUN make && make install
##RUN cp /root/phpredis-2.2.7/modules/redis.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012/
#RUN echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini
#
## Install memcached
#COPY memcached-2.2.0.zip memcached-2.2.0.zip
#RUN apt-get install -y libmemcached-dev zlib1g-dev libncurses5-dev
#RUN mkdir /usr/src/php/ext/memcached-2.2.0
#RUN unzip memcached-2.2.0.zip -d /usr/src/php/ext/memcached-2.2.0
#RUN rm memcached-2.2.0.zip
#RUN docker-php-ext-install memcached-2.2.0
#
## Install mongo
##RUN pecl install mongodb-beta
##RUN echo "extension=mongo.so" > /usr/local/etc/php/conf.d/mongo.ini
######################################## Other extensions ########################################

