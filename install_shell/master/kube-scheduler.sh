#!/usr/bin/env bash

set -o errexit

MASTER_URL=$1
ROOT_PATH=$2

# 配置kube-scheduler
cat > /usr/lib/systemd/system/kube-scheduler.service <<EOF
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-scheduler \
  --address=127.0.0.1 \
  --master=http://${MASTER_URL} \
  --leader-elect=true \
  --v=2
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF

# 复制二进制文件到目录
cp "${ROOT_PATH}/kubernetes/server/bin/kube-scheduler" /usr/local/bin/
systemctl daemon-reload
systemctl enable kube-scheduler.service
service kube-scheduler start