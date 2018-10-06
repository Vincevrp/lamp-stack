#!/bin/bash

DB_NAME=""
DB_USER=""
DB_PASSWD=
DB_ROOT_PASSWD=""

read  -r -p "Enter database name: " DB_NAME
read  -r -p "Enter database username: " DB_USER
read  -s -r -p "Enter database password for ${DB_USER}: (leave blank to generate) " DB_PASSWD

# Print new line after password prompt
printf "\\n"

read -s -r -p "Enter database root password: " DB_ROOT_PASSWD

# Print new line after password prompt
printf "\\n"

if [[ -z $DB_PASSWD  ]]; then
    DB_PASSWD=$(openssl rand -base64 32)
    printf "\\n Generated password: %s\\n" "${DB_PASSWD}"
fi

# Create database
mysql --user=root --password="${DB_ROOT_PASSWD}" <<_EOF_
    CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
    CREATE USER ${DB_USER}@localhost IDENTIFIED BY '${DB_PASSWD}';
    GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWD}';
_EOF_
