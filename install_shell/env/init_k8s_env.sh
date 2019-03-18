#!/usr/bin/env bash

set -o errexit

# 关闭防火墙 和 SELINUX  disabled  enforcing$
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/g' /etc/selinux/config
systemctl disable firewalld.service 
systemctl stop firewalld.service

# 关闭swap
swapoff -a
sed '/dev\/mapper\/centos-swap/d'  /etc/fstab

# k8s 配置文件
cat > /etc/sysctl.d/k8s.conf <<EOF
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
vm.swappiness=0
EOF
sysctl -p /etc/sysctl.d/k8s.conf

yum install net-tools wget


