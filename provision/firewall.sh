#!/bin/bash

ZONE_NAME="web"
INTERFACE=$1

if [[ -z $1 ]]; then
    INTERFACE=$(ip link show | cut -d " " -f 2 | sed -n 3p | sed -e "s/://g")
fi

# Install firewalld
yum install firewalld -y

# Start firewalld
systemctl enable firewalld
systemctl start firewalld

# Configure firewalld
firewall-cmd --permanent --new-zone="${ZONE_NAME}"
firewall-cmd --permanent --zone="${ZONE_NAME}" --add-service=http
firewall-cmd --permanent --zone="${ZONE_NAME}" --add-service=mysql
firewall-cmd --permanent --zone="${ZONE_NAME}" --add-service=ssh
firewall-cmd --permanent --zone="${ZONE_NAME}" --change-interface="${INTERFACE}"

# Reload network and firewall
sudo systemctl restart network
sudo systemctl restart firewalld
