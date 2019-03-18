#!/usr/bin/env bash

MASTER_URL=$1
LOCAL_IP_ADDR=$2
ETCD_URL=$3

mkdir -p /var/lib/kubelet
mkdir -p /etc/kubernetes
mkdir -p /etc/cni/net.d


# kubelet.setvice 配置文件
cat > /usr/lib/systemd/system/kubelet.service <<EOF
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
WorkingDirectory=/var/lib/kubelet
ExecStart=/usr/local/bin/kubelet \
  --address=${LOCAL_IP_ADDR} \
  --hostname-override=${LOCAL_IP_ADDR} \
  --pod-infra-container-image=mirrorgooglecontainers/pause-amd64:3.0 \
  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig \
  --network-plugin=cni \
  --cni-conf-dir=/etc/cni/net.d \
  --cni-bin-dir=/usr/local/bin \
  --cluster-dns=10.68.0.2 \
  --cluster-domain=cluster.local. \
  --allow-privileged=true \
  --fail-swap-on=false \
  --logtostderr=true \
  --v=2

ExecStartPost=/sbin/iptables -A INPUT -s 10.0.0.0/8 -p tcp --dport 4194 -j ACCEPT
ExecStartPost=/sbin/iptables -A INPUT -s 172.16.0.0/12 -p tcp --dport 4194 -j ACCEPT
ExecStartPost=/sbin/iptables -A INPUT -s 192.168.0.0/16 -p tcp --dport 4194 -j ACCEPT
ExecStartPost=/sbin/iptables -A INPUT -p tcp --dport 4194 -j DROP
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


cat > /etc/kubernetes/kubelet.kubeconfig <<EOF 
apiVersion: v1
clusters:
- cluster:
    insecure-skip-tls-verify: true
    server: http://${MASTER_URL}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: ""
  name: system:node:kube-master
current-context: system:node:kube-master
kind: Config
preferences: {}
users: []
EOF

cat > /etc/cni/net.d/10-calico.conf <<EOF
{
    "name": "calico-k8s-network",
    "cniVersion": "0.1.0",
    "type": "calico",
    "etcd_endpoints": "${ETCD_URL}",
    "log_level": "info",
    "ipam": {
        "type": "calico-ipam"
    },
    "kubernetes": {
        "k8s_api_root": "http://${MASTER_URL}"
    }
}
EOF

systemctl enable kubelet.service
service kubelet start
