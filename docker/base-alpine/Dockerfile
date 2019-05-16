ARG BASE_ALPINE_IMAGE_TAG
FROM $BASE_ALPINE_IMAGE_TAG

# 安装runit进程管理&设置中国时区
RUN apk update && apk --no-cache add runit tzdata \
    && mkdir -p /etc/runit \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata;

CMD ["runsvdir", "-P", "/etc/service"]
