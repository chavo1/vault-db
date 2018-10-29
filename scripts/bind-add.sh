#!/bin/bash

# Allowing external connection to DB 
echo "Updating mysql configs in /etc/mysql/mysql.conf.d/mysqld.cnf."
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
echo "Updated mysql bind address in /etc/mysql/mysql.conf.d/mysqld.cnf to 0.0.0.0 to allow external connections."
echo "Reastarting mysql service..."
sudo /etc/init.d/mysql stop
sudo /etc/init.d/mysql start
echo "Done"

# Creating Vault DB and User
echo "Create VaultDB"
mysql -uroot -pvagrant -e "CREATE DATABASE vaultdb";
echo "Create user with privileges"
mysql -uroot -pvagrant -e "CREATE USER 'vault'@'%' IDENTIFIED BY 'password'";
mysql -uroot -pvagrant -e "GRANT ALL PRIVILEGES ON vaultdb.* TO 'vault'@'%' WITH GRANT OPTION";
mysql -uroot -pvagrant -e "GRANT CREATE USER ON *.* to 'vault'@'%'";

