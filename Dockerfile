FROM php:7-fpm-alpine
RUN set -x && \
  apk add --no-cache icu-libs && \
  apk add --no-cache --virtual build-dependencies $PHPIZE_DEPS icu-dev && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j${NPROC} intl && \
  docker-php-ext-install -j${NPROC} pdo_mysql && \
  apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
    docker-php-ext-configure gd \
      --with-gd \
      --with-freetype-dir=/usr/include/ \
      --with-png-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include/ && \
	docker-php-ext-install -j${NPROC} gd && \
  pecl install xdebug && \
  docker-php-ext-enable xdebug && \
  apk del --no-cache --purge build-dependencies $PHPIZE_DEPS freetype-dev libpng-dev libjpeg-turbo-dev && \
  rm -rf /tmp/pear

VOLUME /var/www/html