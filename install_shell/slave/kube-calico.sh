#!/usr/bin/env bash

set -o errexit

ETCD_URL=$1
LOCAL_IP_ADDR=$2

# 配置kube-scheduler
cat > /usr/lib/systemd/system/kube-calico.service <<EOF
[Unit]
Description=calico node
After=docker.service
Requires=docker.service
[Service]
User=root
PermissionsStartOnly=true
ExecStart=/usr/bin/docker run --net=host --privileged --name=calico-node \
-e ETCD_ENDPOINTS=http://${ETCD_URL} \
-e CALICO_LIBNETWORK_LABEL_ENDPOINTS=true \
-e CALICO_NETWORKING_BACKEND=bird \
-e CALICO_DISABLE_FILE_LOGGING=true \
-e CALICO_IPV4POOL_CIDR=172.20.0.0/16 \
-e CALICO_IPV4POOL_IPIP=off \
-e FELIX_DEFAULTENDPOINTTOHOSTACTION=ACCEPT \
-e FELIX_IPV6SUPPORT=false \
-e FELIX_LOGSEVERITYSCREEN=info \
-e FELIX_IPINIPMTU=1440 \
-e FELIX_HEALTHENABLED=true \
-e IP=${LOCAL_IP_ADDR} \
-v /var/run/calico:/var/run/calico \
-v /lib/modules:/lib/modules \
-v /run/docker/plugins:/run/docker/plugins \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /var/log/calico:/var/log/calico \
calico/node:v3.2.5
ExecStop=/usr/bin/docker rm -f calico-node
Restart=always
RestartSec=10
[Install]
WantedBy=multi-user.target
EOF

# 配置文件
systemctl daemon-reload
systemctl enable kube-calico.service
service kube-calico start
