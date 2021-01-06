FROM php:7.4-fpm-alpine
LABEL Maintainer Federico Pereira <fpereira@cnsoluciones.com>
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    AUTOCONFIGURE='false'

RUN apk update \
    && apk add --no-cache tzdata bash \
    && rm /var/cache/apk/*

# Add Build Dependencies
RUN apk add --no-cache --virtual .build-deps  \
    zlib-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    bzip2-dev \
    zip \
    libzip-dev 

# Configure & Install Extension
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    sockets \
    json \
    gd \
    xml \
    bz2 \
    pcntl \
    bcmath \
    zip

# Add Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 

#RUN DOCKER SCRIPT
COPY ./build/php/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

WORKDIR /var/www/html
ENTRYPOINT ["/docker-entrypoint.sh"]