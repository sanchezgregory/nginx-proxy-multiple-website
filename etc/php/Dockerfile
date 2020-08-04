FROM php:7.1.14-fpm
#FROM php:7.3.6-fpm
RUN apt-get update && apt-get install -y \
    libzip-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libcurl4-gnutls-dev \
        libxml2-dev \
        libbz2-dev \
        re2c \
        libpng++-dev \
        libjpeg-dev \
        libvpx-dev \
        zlib1g-dev \
        libgd-dev \
        libssl-dev \
        libtidy-dev \
        libxslt1-dev \
        libmagic-dev \
        libexif-dev \
        file \
        libssh2-1-dev \
        git \
        wget    \
        sqlite3 \
        libsqlite3-dev \
        libgmp-dev \
        libmemcached-dev \
        memcached \

    && docker-php-ext-install json \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install tokenizer \
    && docker-php-ext-install gmp \
    && docker-php-ext-install gd \
    && docker-php-ext-install curl \
    && docker-php-ext-install dom \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install phar \
    && docker-php-ext-install posix \
    && docker-php-ext-install simplexml \
    && docker-php-ext-install soap \
    && docker-php-ext-install sockets \
    && docker-php-ext-install tidy \
    && docker-php-ext-install zip \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install calendar \
    && docker-php-ext-install ctype \
    && docker-php-ext-install exif \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install pdo_sqlite \
    && docker-php-ext-install opcache \

    #&& pecl install xdebug && docker-php-ext-enable xdebug \
    && pecl install memcached && docker-php-ext-enable memcached \
    #&& pecl install mongodb && docker-php-ext-enable mongodb \
    #&& pecl install redis && docker-php-ext-enable redis \
    && pecl install mcrypt-1.0.0 && docker-php-ext-enable mcrypt \
    && docker-php-source delete \
    && apt-get remove -y g++ wget \
    && apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -f /usr/local/etc/php-fpm.d/www.conf.default
