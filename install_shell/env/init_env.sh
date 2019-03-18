#!/usr/bin/env bash

set -o errexit

# 关闭防火墙 和 
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX= disabled/' /etc/selinux/config

systemctl disable firewalld.service 
systemctl stop firewalld.service

reboot