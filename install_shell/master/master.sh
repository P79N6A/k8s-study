#!/usr/bin/env bash
set -o errexit

# 本机IP地址
LOCAL_IP_ADDR=`ip a | grep inet | grep -v inet6 | grep -v 127 | grep 192.168.56 | sed 's/^[ \t]*//g' | cut -d ' ' -f2 | cut -d '/' -f1`

# 当前目录
ROOT_PATH=$(cd `dirname $0`; pwd)

ETCD_PORT=2379
ETCD_URL=${LOCAL_IP_ADDR}:${ETCD_PORT}

CONTROLLER_MANAGER_PORT=8080
CONTROLLER_MANAGER_URL=127.0.0.1:${CONTROLLER_MANAGER_PORT}

# 安装etcd 配置中心 
. etcd.sh ${LOCAL_IP_ADDR} ${ETCD_URL} ${ETCD_PORT}

# 下载k8s二进制包
VERSION="v1.13.4"
DOWNLOAD_URL="https://storage.googleapis.com/kubernetes-release/release/${VERSION}/kubernetes-server-linux-amd64.tar.gz"

# 下载指定版本的k8s
wget ${DOWNLOAD_URL}

# 解压k8s
tar vxf kubernetes-server-linux-amd64.tar.gz
mkdir -p /etc/kubernetes


# 安装k8s组件
# 安装kube-apiserver
. kube-apiserver.sh ${LOCAL_IP_ADDR} ${ROOT_PATH} ${ETCD_URL}

# 安装kube-controller-manager
. kube-controller-manager.sh ${CONTROLLER_MANAGER_URL} ${ROOT_PATH}

# 安装kube-scheduler
. kube-scheduler.sh ${CONTROLLER_MANAGER_URL} ${ROOT_PATH}

# 安装kube-calico
. kube-calico.sh ${ETCD_URL} ${LOCAL_IP_ADDR}

cp "${ROOT_PATH}/kubernetes/server/bin/kubectl" /usr/local/bin/
chmod +x /usr/local/bin/kubectl

# 清理文件
rm -rf kubernetes*
