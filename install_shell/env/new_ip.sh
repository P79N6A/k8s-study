#!/usr/bin/env bash

set -o errexit

read -p "Input Local host Ip :" IP

echo "Local host ip: ${IP}"

UUID=`cat /proc/sys/kernel/random/uuid`


cat > /etc/sysconfig/network-scripts/ifcfg-enp0s8 <<EOF 
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp0s8
UUID=${UUID}
DEVICE=enp0s8
ONBOOT=yes
IPADDR=${IP}
GATEWAY=192.168.56.1
NETMASK=255.255.255.0
EOF

service network restart