ARG BASE_ALPINE_IMAGE
FROM $BASE_ALPINE_IMAGE

ENV NGINX_VERSION 1.14.2
ENV NGINX_MORE_HEADER_VERSION 0.33
ENV NGINX_OPEN_SSL 1_0_2o
ENV INSTALL_DIR "/usr/local/web/nginx"

COPY nginx "/etc/service/nginx"

RUN chmod +x /etc/service/nginx/run \
    && chmod +x /etc/service/nginx/log/run \
    && mkdir -p "$INSTALL_DIR" \
	&& CONFIG="\
		--prefix=$INSTALL_DIR \
		--conf-path=$INSTALL_DIR/conf/nginx.conf \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
		--user=nginx \
		--group=nginx \
		--with-http_ssl_module \
		--with-openssl=/usr/src/openssl-OpenSSL_$NGINX_OPEN_SSL \
		--with-stream \
		--with-http_realip_module \
		--add-module=/usr/src/headers-more-nginx-module-$NGINX_MORE_HEADER_VERSION \
	" \
	&& addgroup -S nginx \
	&& adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
	&& apk add --no-cache --virtual .build-deps \
	    xz \
		gcc \
		libc-dev \
		make \
		openssl-dev \
		pcre-dev \
		zlib-dev \
		linux-headers \
		curl \
		gnupg1 \
		perl \
	&& curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
	&& curl -fSL https://codeload.github.com/openresty/headers-more-nginx-module/tar.gz/v$NGINX_MORE_HEADER_VERSION -o headers-more-nginx-module.tar.gz \
	&& curl -fSL https://codeload.github.com/openssl/openssl/tar.gz/OpenSSL_$NGINX_OPEN_SSL -o openssl.tar.gz \
	&& mkdir -p /usr/src \
	&& tar -zxC /usr/src -f nginx.tar.gz \
	&& tar -zxC /usr/src -f headers-more-nginx-module.tar.gz  \
	&& tar -zxC /usr/src -f openssl.tar.gz \
	&& rm nginx.tar.gz \
	&& rm headers-more-nginx-module.tar.gz \
	&& rm openssl.tar.gz \
	#安装OpenSSL
    && cd /usr/src/openssl-OpenSSL_$NGINX_OPEN_SSL \
    && ./config \
    && make \
    && make install \
    && make -t \
    && make depend \
    # 安装nginx
	&& cd /usr/src/nginx-$NGINX_VERSION \
	# 解决openssl安装问题
	&& sed -i 's#\.openssl/##g' auto/lib/openssl/conf \
	&& sed -i 's#lib/libssl.a#libssl.a#g' auto/lib/openssl/conf \
	&& sed -i 's#lib/libcrypto.a#libcrypto.a#g' auto/lib/openssl/conf \
	# 配置安装nginx
	&& ./configure $CONFIG --with-debug \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& ./configure $CONFIG \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& make install \
	&& rm -rf /etc/nginx/html/ \
	&& mkdir "$INSTALL_DIR/conf/conf.d/" \
	&& mkdir -p /usr/share/nginx/html/ \
	&& ln -s "$INSTALL_DIR/sbin/nginx" /usr/sbin/nginx \
	&& strip /usr/sbin/nginx* \
	#　清理安装包
	&& rm -rf /usr/src/nginx-$NGINX_VERSION \
	&& rm -rf /usr/src/headers-more-nginx-module-$NGINX_MORE_HEADER_VERSION \
	&& rm -rf /usr/src/openssl-OpenSSL_$NGINX_OPEN_SSL \
	\
	&& apk add --no-cache --virtual .gettext gettext \
	&& mv /usr/bin/envsubst /tmp/ \
	\
	&& runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" \
	&& apk del .build-deps \
    && apk del .gettext \
	&& apk add --no-cache --virtual .nginx-rundeps $runDeps \
	&& mv /tmp/envsubst /usr/local/bin/

COPY nginx.conf "$INSTALL_DIR/conf/nginx.conf"
COPY nginx.vh.default.conf "$INSTALL_DIR/conf/conf.d/default.conf"
COPY mpapi_cors.conf "$INSTALL_DIR/conf/mpapi_cors.conf"
COPY cors.conf "$INSTALL_DIR/conf/cors.conf"


EXPOSE 80

CMD ["runsvdir", "-P", "/etc/service"]
