#!/usr/bin/env bash

set -o errexit

LOCAL_IP_ADDR=$1
ROOT_PATH=$2
ETCD_SERVER_URL=$3

# 配置kube-apiserver开机启动
cat > /usr/lib/systemd/system/kube-apiserver.service <<EOF
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target
[Service]
ExecStart=/usr/local/bin/kube-apiserver \
  --admission-control=NamespaceLifecycle,LimitRanger,DefaultStorageClass,ResourceQuota,NodeRestriction \
  --insecure-bind-address=0.0.0.0 \
  --kubelet-https=false \
  --service-cluster-ip-range=10.68.0.0/16 \
  --service-node-port-range=20000-40000 \
  --etcd-servers=http://${ETCD_SERVER_URL} \
  --enable-swagger-ui=true \
  --allow-privileged=true \
  --audit-log-maxage=30 \
  --audit-log-maxbackup=3 \
  --audit-log-maxsize=100 \
  --audit-log-path=/var/lib/audit.log \
  --event-ttl=1h \
  --v=2
Restart=on-failure
RestartSec=5
Type=notify
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

# 复制二进制文件到目录
cp "${ROOT_PATH}/kubernetes/server/bin/kube-apiserver" /usr/local/bin/
systemctl daemon-reload
systemctl enable kube-apiserver.service
service kube-apiserver start