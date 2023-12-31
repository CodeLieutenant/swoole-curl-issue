FROM debian:bookworm-slim as base

ARG SWOOLE_VERSION="5.1.1"
ARG PHP_VERSION="8.3"

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y gnupg curl ca-certificates wget \
    libpq-dev zip unzip git supervisor libvips libcurl4-gnutls-dev libcurl4 \
    libpng-dev libpng16-16 apt-transport-https software-properties-common lsb-release \
    libc-ares-dev libc-ares2 gosu dnsutils \
    && curl -sSL https://packages.sury.org/php/README.txt | bash -x \
    && apt-get install -y  \
    php${PHP_VERSION}-cli php${PHP_VERSION}-pgsql php${PHP_VERSION}-imagick \
    php${PHP_VERSION}-curl php${PHP_VERSION}-mbstring  php${PHP_VERSION}-gmp  php${PHP_VERSION}-vips \
    php${PHP_VERSION}-zip php${PHP_VERSION}-bcmath php${PHP_VERSION}-ffi php${PHP_VERSION}-sockets \
    php${PHP_VERSION}-intl php${PHP_VERSION}-readline \
    php${PHP_VERSION}-msgpack php${PHP_VERSION}-igbinary php${PHP_VERSION}-redis php${PHP_VERSION}-xml php${PHP_VERSION}-apcu php${PHP_VERSION}-uuid php${PHP_VERSION}-zstd php${PHP_VERSION}-dev \
    && curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

FROM base as with-curl

RUN cd /tmp \
    && wget https://github.com/swoole/swoole-src/archive/refs/tags/v${SWOOLE_VERSION}.zip \
    && unzip v${SWOOLE_VERSION} \
    && cd swoole-src-${SWOOLE_VERSION} \
    && phpize \
    && ./configure \
    --enable-openssl \
    --enable-brotli \
    --enable-cares \
    --enable-swoole \
    --enable-sockets \
    --enable-swoole-coro-time \
    --enable-swoole-pgsql \
    --enable-thread-context \
    --enable-swoole-curl \
    --enable-http2 \
    && make \
    && make install
COPY ./php/php.ini /etc/php/${PHP_VERSION}/cli/conf.d/00-php.ini
COPY ./php/swoole.ini /etc/php/${PHP_VERSION}/cli/conf.d/25-swoole.ini

FROM base as without-curl

RUN cd /tmp \
    && wget https://github.com/swoole/swoole-src/archive/refs/tags/v${SWOOLE_VERSION}.zip \
    && unzip v${SWOOLE_VERSION} \
    && cd swoole-src-${SWOOLE_VERSION} \
    && phpize \
    && ./configure \
    --enable-openssl \
    --enable-brotli \
    --enable-cares \
    --enable-swoole \
    --enable-sockets \
    --enable-swoole-coro-time \
    --enable-swoole-pgsql \
    --enable-thread-context \
    --enable-http2 \
    && make \
    && make install

COPY ./php/php.ini /etc/php/${PHP_VERSION}/cli/conf.d/00-php.ini
COPY ./php/swoole.ini /etc/php/${PHP_VERSION}/cli/conf.d/25-swoole.ini