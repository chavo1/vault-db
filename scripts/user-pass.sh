#!/bin/bash

export VAULT_ADDR=http://127.0.0.1:8200

vault secrets enable database

echo "Configure Vault *mysql-database-plugin* to be able to talk to MySQL database"

vault write database/config/vaultdb \
plugin_name=mysql-database-plugin \
connection_url="{{username}}:{{password}}@tcp(192.168.56.57:3306)/" \
allowed_roles="mysqlrole" \
username="vault" \
password="password"

echo "Configure the role that maps a name within Vault to a SQL statement to create the user within the mysql database"

vault write database/roles/mysqlrole \
db_name=vaultdb \
creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL PRIVILEGES ON vaultdb.* TO '{{name}}'@'%';" \
default_ttl="1h" \
max_ttl="24h"

echo "Tell Vault to generate a new login to MySQL database"

vault read database/creds/mysqlrole

echo "Use the above credentials to loging in your MYSQL database!"