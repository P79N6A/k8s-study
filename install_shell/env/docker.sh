#!/usr/bin/env bash

set -o errexit
systemctl disable firewalld
systemctl stop firewalld

yum remove docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-engine

yum install -y yum-utils \
device-mapper-persistent-data \
lvm2

yum-config-manager \
--add-repo \
https://download.docker.com/linux/centos/docker-ce.repo

yum-config-manager --enable docker-ce-nightly

yum-config-manager --enable docker-ce-test

yum-config-manager --disable docker-ce-nightly

yum install docker-ce docker-ce-cli containerd.io

read -p "Input https proxy address:" HTTPS_PROXY

echo "Your https proxy address:${HTTPS_PROXY}"

read -p "Input http proxy address:" HTTP_PROXY

echo "Your http proxy address:${HTTP_PROXY}"

mkdir -p /etc/systemd/system/docker.service.d
cat > /etc/systemd/system/docker.service.d/http-proxy.conf <<<EOF
[Service]
Environment="HTTP_PROXY=${HTTP_PROXY}" "HTTPS_PROXY=${HTTPS_PROXY}" "NO_PROXY=127.0.0.1,localhost"
EOF
systemctl daemon-reload
systemctl restart docker
