#!/bin/bash

# MariaDB installation

DB_ROOT_PASSWD=$1
PASSWD_FILE_PATH="/vagrant/share/db_root_passwd.txt"

# Install MariaDB
yum install mariadb-server mariadb -y

# Start MariaDB server
sudo systemctl start mariadb

# Generate random password if none is passed
if [[ -z "$1" ]]; then
    DB_ROOT_PASSWD=$(openssl rand -base64 32)

    echo "${DB_ROOT_PASSWD}" > "${PASSWD_FILE_PATH}"
    chown vagrant:vagrant "${PASSWD_FILE_PATH}"
    chmod 200 "${PASSWD_FILE_PATH}"
fi

# Automatic mysql_secure_installation
# Author: Bert Van Vreckem <bert.vanvreckem@gmail.com>

is_mysql_root_password_set() {
  ! mysqladmin --user=root status > /dev/null 2>&1
}

if is_mysql_root_password_set; then
    echo "Database root password is already set. Refer to:" "${PASSWD_FILE_PATH}"
    exit 0
fi

mysql --user=root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('${DB_ROOT_PASSWD}') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_

# Start MariaDB on boot
sudo systemctl enable mariadb.service
