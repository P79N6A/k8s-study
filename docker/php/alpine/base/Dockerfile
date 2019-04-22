#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM alpine:3.8

ENV PHPIZE_DEPS \
		autoconf \
		dpkg-dev dpkg \
		file \
		g++ \
		gcc \
		libc-dev \
		make \
		pkgconf \
		re2c

ENV PHP_INSTALL_DIR /usr/local/web/php
ENV PHP_INI_DIR "$PHP_INSTALL_DIR/etc/php"
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --disable-cgi
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

ENV GPG_KEYS A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 1729F83938DA44E27BA0F4D3DBDB397470D12172
ENV PHP_VERSION 7.1.28
ENV PHP_URL="https://www.php.net/get/php-7.1.28.tar.xz/from/this/mirror" PHP_ASC_URL="https://www.php.net/get/php-7.1.28.tar.xz.asc/from/this/mirror"
ENV PHP_SHA256="45131497ec0a947e3f9145c000e8fcc1f86b46518ee3f6810d80efa2d39521e2" PHP_MD5=""

COPY docker-php-source docker-php-ext-* docker-php-entrypoint /usr/local/bin/

RUN     set -eux; \
        mkdir -p "$PHP_INI_DIR/conf.d"; \
        \
        \
        ## 创建运行用户和运行组
        addgroup -g 82 -S www-data \
        && adduser -u 82 -D -S -G www-data www-data; \
        \
        \
        ## 创建工作目录
        [ ! -d /var/www/html ]; \
        mkdir -p /var/www/html; \
        chown www-data:www-data /var/www/html; \
        chmod 777 /var/www/html; \
        \
        \
        ## 设置时区为上海
        apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && apk del tzdata; \
        \
        \
        ## 下载php 并且验证php 的正确性
        apk add --no-cache --virtual .fetch-deps \
		ca-certificates \
		curl \
		tar \
		xz \
		gnupg \
        wget \
        # https://github.com/docker-library/php/issues/494
		libressl; \
        \
        # 源码地址
        mkdir -p /usr/src; \
        cd /usr/src; \
        \
        wget -O php.tar.xz "$PHP_URL"; \
        \
        if [ -n "$PHP_SHA256" ]; then \
            echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -; \
        fi; \
        if [ -n "$PHP_MD5" ]; then \
            echo "$PHP_MD5 *php.tar.xz" | md5sum -c -; \
        fi; \
        \
        if [ -n "$PHP_ASC_URL" ]; then \
            wget  -O php.tar.xz.asc "$PHP_ASC_URL"; \
            export GNUPGHOME="$(mktemp -d)"; \
            #for key in $GPG_KEYS; do \
            #    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
            #done; \
            #gpg --batch --verify php.tar.xz.asc php.tar.xz; \
            #command -v gpgconf > /dev/null && gpgconf --kill all; \
            rm -rf "$GNUPGHOME"; \
        fi; \
        \
        apk del --no-network .fetch-deps; \
        \
        \
        ## 安装php 的依赖包
        apk add --no-cache --virtual .build-deps \
            $PHPIZE_DEPS \
            coreutils \
            curl-dev \
            libedit-dev \
            libxml2-dev \
            libressl-dev \
            sqlite-dev \
        \
        && export CFLAGS="$PHP_CFLAGS" \
            CPPFLAGS="$PHP_CPPFLAGS" \
            LDFLAGS="$PHP_LDFLAGS" \
        && docker-php-source extract \
        && cd /usr/src/php \
        && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        \
        \
        ##　执行编译php-fpm
        && ./configure \
            --prefix="$PHP_INSTALL_DIR" \
            --build="$gnuArch" \
            --with-config-file-path="$PHP_INI_DIR" \
            --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
            \
            # make sure invalid --configure-flags are fatal errors intead of just warnings
            --enable-option-checking=fatal \
            \
            # https://github.com/docker-library/php/issues/439
            --with-mhash \
            \
            # --enable-ftp is included here because ftp_ssl_connect() needs ftp to be compiled statically (see https://github.com/docker-library/php/issues/236)
            --enable-ftp \
            # --enable-mbstring is included here because otherwise there's no way to get pecl to use it properly (see https://github.com/docker-library/php/issues/195)
            --enable-mbstring \
            # --enable-mysqlnd is included here because it's harder to compile after the fact than extensions are (since it's a plugin for several extensions, not an extension in itself)
            --enable-mysqlnd \
            --enable-soap \
            \
            --with-curl \
            --with-libedit \
            --with-openssl \
            --with-zlib \
            \
            # bundled pcre does not support JIT on s390x
            # https://manpages.debian.org/stretch/libpcre3-dev/pcrejit.3.en.html#AVAILABILITY_OF_JIT_SUPPORT
            $(test "$gnuArch" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
            \
            $PHP_EXTRA_CONFIGURE_ARGS \
        && make -j "$(nproc)" \
        && find -type f -name '*.a' -delete \
        && make install \
        && { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
        && make clean \
        \
        # https://github.com/docker-library/php/issues/692 (copy default example "php.ini" files somewhere easily discoverable)
        && cp -v php.ini-* "$PHP_INI_DIR/" \
        \
        && cd / \
        && docker-php-source delete \
        \
        && runDeps="$( \
            scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
                | tr ',' '\n' \
                | sort -u \
                | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        )" \
        && apk add --no-cache $runDeps \
        \
        && apk del --no-network .build-deps \
        \
        && ln -s "$PHP_INSTALL_DIR/bin/pear" /usr/local/bin/pear \
        && ln -s "$PHP_INSTALL_DIR/bin/pecl" /usr/local/bin/pecl \
        && ln -s "$PHP_INSTALL_DIR/bin/php" /usr/local/bin/php \
        && ln -s "$PHP_INSTALL_DIR/bin/php-config" /usr/local/bin/php-config \
        && ln -s "$PHP_INSTALL_DIR/bin/php-cgi" /usr/local/bin/php-cgi \
        && ln -s "$PHP_INSTALL_DIR/bin/phpize" /usr/local/bin/phpize \
        && ln -s "$PHP_INSTALL_DIR/bin/phpdbg" /usr/local/bin/phpdbg \
        && ln -s "$PHP_INSTALL_DIR/bin/phar" /usr/local/bin/phar \
        && ln -s "$PHP_INSTALL_DIR/bin/phar.phar" /usr/local/bin/phar.phar \
        && ln -s "$PHP_INSTALL_DIR/sbin/php-fpm" /usr/local/bin/php-fpm \
        # https://github.com/docker-library/php/issues/443
        && pecl update-channels \
        && rm -rf /tmp/pear ~/.pearrc \
        \
        \
        ## 配置配置文件信息
        && set -ex \
        && cd "$PHP_INSTALL_DIR/etc" \
        && if [ -d php-fpm.d ]; then \
            # for some reason, upstream's php-fpm.conf.default has "include=NONE/etc/php-fpm.d/*.conf"
            sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
            cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
        else \
            # PHP 5.x doesn't use "include=" by default, so we'll create our own simple config that mimics PHP 7+ for consistency
            mkdir php-fpm.d; \
            cp php-fpm.conf.default php-fpm.d/www.conf; \
            { \
                echo '[global]'; \
                echo 'include=etc/php-fpm.d/*.conf'; \
            } | tee php-fpm.conf; \
        fi \
        && { \
            echo '[global]'; \
            echo 'error_log = /proc/self/fd/2'; \
            echo; \
            echo '[www]'; \
            echo '; if we send this to /proc/self/fd/1, it never appears'; \
            echo 'access.log = /proc/self/fd/2'; \
            echo; \
            echo 'clear_env = no'; \
            echo; \
            echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
            echo 'catch_workers_output = yes'; \
        } | tee php-fpm.d/docker.conf \
        && { \
            echo '[global]'; \
            echo 'daemonize = no'; \
            echo; \
            echo '[www]'; \
            echo 'listen = 9000'; \
        } | tee php-fpm.d/zz-docker.conf \
        && cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
        \
        \
        ## 扩展安装
        && apk add freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev libxml2-dev \
        && docker-php-ext-install bcmath calendar mysqli pcntl pdo_mysql sockets sysvsem sysvshm wddx  zip \
        && docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
        && docker-php-ext-install -j$(nproc) gd \
        && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev libxml2-dev

ENTRYPOINT ["docker-php-entrypoint"]

##<autogenerated>##
WORKDIR /var/www/htmls

EXPOSE 9000
CMD ["php-fpm"]
