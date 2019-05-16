# 基础构建镜像
ARG GO_BUILD_IMAGE_TAG
FROM $GO_BUILD_IMAGE_TAG

ENV http_proxy ${http_proxy}
ENV https_proxy ${https_proxy}
ENV no_proxy ${no_proxy}
ENV GOLANG_VER "1.12.5"
ENV GO111MODULE auto
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND noninteractive
# 安装证书
COPY --chown=root:root ca-certificates/* /usr/local/share/ca-certificates/

RUN apt-get update \
    && apt-get install -y curl \
    git \
    runit \
    tzdata; \
    \
    # 更新证书
    update-ca-certificates \
    # 下载并安装golang
    && curl -O "https://dl.google.com/go/go${GOLANG_VER}.linux-amd64.tar.gz" \
    && tar -C /usr/local -xzf "go${GOLANG_VER}.linux-amd64.tar.gz" \
    \
    # gitconfig 配置
    &&  { \
        echo '[core]'; \
        echo '      autocrlf = input'; \
        echo; \
        echo '[url "git@git.code.oa.com:"]'; \
        echo '      insteadOf = https://git.code.oa.com/'; \
        echo ; \
        echo '[gc]'; \
        echo; \
        echo '      autoDetach = false'; \
        } | tee ~/.gitconfig \
    # 设置时区
    && rm -rf /etc/localtime \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get remove -y tzdata \
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 设置go bin的环境变量
ENV PATH="/usr/local/go/bin:${PATH}"

CMD ["runsvdir", "-P", "/etc/service"]
