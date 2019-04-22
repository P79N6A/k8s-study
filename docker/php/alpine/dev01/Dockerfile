# php-fpm 1.0v
FROM php-fpm-base:1.0

ENV PHP_MEMORY_LIMIT 512M
ENV MAX_UPLOAD 50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST 100M`
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    && apk add freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-ext-install -j$(nproc) bcmath calendar mysqli pcntl pdo_mysql soap sockets sysvsem sysvshm wddx  zip \
    && docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev \
    && cp "$PHP_INI_DIR/php/php.ini-production" "$PHP_INI_DIR/php/php.ini" \
    php -- --install-dir=/usr/bin --filename=composer \
        && sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" "$PHP_INI_DIR/php-fpm.conf" \
        && sed -i -e "s/listen\s*=\s*127.0.0.1:9000/listen = 9000/g" "$PHP_INI_DIR"/php-fpm.conf \
        && sed -i "s|;date.timezone =.*|date.timezone = ${TIMEZONE}|""$PHP_INI_DIR"/php/php.ini \
        && sed -i "s|memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|""$PHP_INI_DIR"/php/php.ini \
        && sed -i "s|upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|" "$PHP_INI_DIR"/php/php.ini \
        && sed -i "s|max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|" "$PHP_INI_DIR"/php/php.ini \
        && sed -i "s|post_max_size =.*|max_file_uploads = ${PHP_MAX_POST}|" "$PHP_INI_DIR"/php/php.ini \
        && sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" "$PHP_INI_DIR"/php/php.ini \
    && mkdir /www \
    && rm -rf /var/cache/apk/*
