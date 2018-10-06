#!/bin/bash

# Install Drupal

DRUPAL_URL="https://ftp.drupal.org/files/projects/drupal-8.5.0.tar.gz"
DB_NAME="drupaldb"
DB_USER="drupal"
WWW_PATH="/var/www/html/"
CONFIG_FILE_PATH="/vagrant/provision/config/drupal.conf"
APACHE_CONF_D="/etc/httpd/conf.d/"

# Prompt for MariaDB root password
read -s -r -p "Enter MariaDB root password: " DB_ROOT_PASSWD

# Prompt MariaDB root password
read -s -r -p "Enter password for Drupal database: " DB_PASSWD

# Download Drupal and install in $WWW_PATH
curl -o /tmp/drupal.tar.gz "${DRUPAL_URL}"
mkdir /tmp/drupal && tar -xzf /tmp/drupal.tar.gz -C /tmp/drupal/ --strip-components=1
mv /tmp/drupal/{.,}* "${WWW_PATH}"

# Permissions for $WWW_PATH
chown -R apache:apache "${WWW_PATH}"
chcon -R -t httpd_sys_content_rw_t "${WWW_PATH}"

# Copy config file for Apache
cp "${CONFIG_FILE_PATH}" "${APACHE_CONF_D}"

# Create database
mysql --user=root --password="${DB_ROOT_PASSWD}" <<_EOF_
    CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
    CREATE USER ${DB_USER}@localhost IDENTIFIED BY '${DB_PASSWD}';
    GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWD}';
_EOF_

# Restart Apache
systemctl restart httpd.service
