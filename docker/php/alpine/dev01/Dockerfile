# php-fpm 1.0v
FROM php-fpm-base:1.0

ENV PHP_MEMORY_LIMIT 512M
ENV MAX_UPLOAD 50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST 100M`
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN php -- --install-dir=/usr/bin --filename=composer \
        && sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" "$PHP_INI_DIR/php-fpm.conf" \
        && sed -i -e "s/listen\s*=\s*127.0.0.1:9000/listen = 9000/g" "$PHP_INI_DIR"/php-fpm.conf \
        && sed -i "s|;date.timezone =.*|date.timezone = ${TIMEZONE}|""$PHP_INI_DIR"/php/php.ini \
        && sed -i "s|memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|""$PHP_INI_DIR"/php/php.ini \
        && sed -i "s|upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|" "$PHP_INI_DIR"/php/php.ini \
        && sed -i "s|max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|" "$PHP_INI_DIR"/php/php.ini \
        && sed -i "s|post_max_size =.*|max_file_uploads = ${PHP_MAX_POST}|" "$PHP_INI_DIR"/php/php.ini \
        && sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" "$PHP_INI_DIR"/php/php.ini \
    && rm -rf /var/cache/apk/*
