#!/bin/bash

PASSWD_FILE_PATH="/vagrant/share/ssh_password.txt"
CONFIG_PATH="/vagrant/provision/config/sshd_config"
SSHD_PATH="/etc/ssh"
USERNAME="developer"
PASSWORD=$1
APACHE_GRP="apache"
WWW_DIR="/var/www"
CHROOT_DIR="$WWW_DIR/html"

# Generate random password if none is passed
if [[ -z "$1" ]]; then
    PASSWORD=$(openssl rand -base64 32)

    echo "${PASSWORD}" > "${PASSWD_FILE_PATH}"
    chown vagrant:vagrant "${PASSWD_FILE_PATH}"
    chmod 200 "${PASSWD_FILE_PATH}"
fi

# Create user
useradd --no-create-home --groups "${APACHE_GRP}" "${USERNAME}"
echo "${USERNAME}":"${PASSWORD}" | chpasswd
echo "${PASSWORD}" > "${SHARE_PATH}"/ssh_password.txt

# Permissions for chroot
chown root:root "${WWW_DIR}"
chmod 755 "${WWW_DIR}"
chown "${USERNAME}":"${APACHE_GRP}" "${CHROOT_DIR}"

# Copy config
cp "${CONFIG_PATH}" "${SSHD_PATH}"

# Restart sshd and network
systemctl restart sshd
systemctl restart network
