#!/usr/bin/env bash

set -o errexit

# 当前目录
ROOT_PATH=$(cd `dirname $0`; pwd)

ETCD_URL="192.168.56.101:2379"

LOCAL_IP_ADDR=`ip a | grep inet | grep -v inet6 | grep -v 127 | grep 192.168.56 | sed 's/^[ \t]*//g' | cut -d ' ' -f2 | cut -d '/' -f1`

MASTER_URL="192.168.56.101:8080"


wget -O /usr/local/bin/calicoctl https://github.com/projectcalico/calicoctl/releases/download/v1.6.1/calicoctl
chmod +x /usr/local/bin/calicoctl


. kube-calico.sh ${ETCD_URL} ${LOCAL_IP_ADDR}

# 下载k8s二进制包
VERSION="v1.13.4"
DOWNLOAD_URL="https://storage.googleapis.com/kubernetes-release/release/${VERSION}/kubernetes-server-linux-amd64.tar.gz"

# 下载指定版本的k8s
wget ${DOWNLOAD_URL}

# 解压k8s
tar vxf kubernetes-server-linux-amd64.tar.gz

# kubelet安装
cp kubernetes/server/bin/kubelet /usr/local/bin/kubelet
chmox +x /usr/local/bin/kubelet
. kube-kubelet.sh ${MASTER_URL} ${LOCAL_IP_ADDR} ${ETCD_URL}



