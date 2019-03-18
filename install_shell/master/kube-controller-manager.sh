#!/usr/bin/env bash

set -o errexit

URL=$1
ROOT_PATH=$2
# 配置kube-manager-controller配置文件
cat > /usr/lib/systemd/system/kube-controller-manager.service <<EOF
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
[Service]
ExecStart=/usr/local/bin/kube-controller-manager \
  --address=127.0.0.1 \
  --master=http://${URL} \
  --allocate-node-cidrs=true \
  --service-cluster-ip-range=10.68.0.0/16 \
  --cluster-cidr=172.20.0.0/16 \
  --cluster-name=kubernetes \
  --leader-elect=true \
  --cluster-signing-cert-file= \
  --cluster-signing-key-file= \
  --v=2
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF

# 复制二进制文件到目录
cp "${ROOT_PATH}/kubernetes/server/bin/kube-controller-manager" /usr/local/bin/
systemctl daemon-reload
systemctl enable kube-controller-manager.service
service kube-controller-manager start