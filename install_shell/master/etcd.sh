#!/usr/bin/env bash

set -o errexit

LOCAL_IP_ADDR=$1
ETCD_URL=$2
ETCD_PORT=$3

ETCD_DOWNLOAD_URL="https://storage.googleapis.com/etcd"
ETCD_VERSION="v3.3.8"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"

wget ${ETCD_DOWNLOAD_URL}/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz
tar vxf etcd-${ETCD_VERSION}-linux-amd64.tar.gz
# 配置etcd配置文件
mkdir -p /var/lib/etcd

# etcd配置文件
cat > /usr/lib/systemd/system/etcd.service <<EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos

[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
ExecStart=/usr/local/bin/etcd \
  --name=${LOCAL_IP_ADDR} \
  --listen-client-urls=http://${ETCD_URL},http://127.0.0.1:${ETCD_PORT} \
  --advertise-client-urls=http://${ETCD_URL} \
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# 复制二进制文件到目录 以及清理当前目录
cp "${ROOT_PATH}/etcd-${ETCD_VERSION}-linux-amd64/etcd" /usr/local/bin/
cp "${ROOT_PATH}/etcd-${ETCD_VERSION}-linux-amd64/etcdctl" /usr/local/bin/
systemctl daemon-reload
systemctl enable etcd.service
service etcd start
rm -rf ${ROOT_PATH}/etcd-${ETCD_VERSION}*