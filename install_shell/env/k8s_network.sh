#!/usr/bin/env bash

set -o errexit


cat > /etc/sysctl.d/k8s.conf <<EOF 
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl -p /etc/sysctl.d/k8s.conf