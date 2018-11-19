# This repo contains an example how to generate dynamic credential with Vault to login into MySQL DB.

## Rrequirment

1. Vagrant [installed](https://www.vagrantup.com/docs/installation/).

2. Clone the repo:
```
$ git clone https://github.com/chavo1/vault-db.git && cd vault-db
$ vagrant up
```
3. Login to the vault node (become super user - export the vault address and port - enable database secret engine) and execute a following commands:

```
$ sudo su -
$ export VAULT_ADDR=http://127.0.0.1:8200
$ vault secrets enable database
```
4. We are ready to configure the database engine - Configure Vault to talk to MySQL database.

```
vault write database/config/vaultdb \
plugin_name=mysql-database-plugin \
connection_url="{{username}}:{{password}}@tcp(192.168.56.57:3306)/" \
allowed_roles="mysqlrole" \
username="vault" \
password="password"
```

5. Configure the role that maps a name in Vault to create the user in the mysql database.

```
vault write database/roles/mysqlrole \
db_name=vaultdb \
creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL PRIVILEGES ON vaultdb.* TO '{{name}}'@'%';" \
default_ttl="1h" \
max_ttl="24h"
```

6. Tell Vault to generate a new login to MySQL database
```
vault read database/creds/mysqlrole
```
7. Generated credentials should look as follow:
```
    vault: Key                Value
    vault: ---                -----
    vault: lease_id           database/creds/mysq
    vault: lrole/7HWcE
    vault: w4EDHLsYmvMdYI53z9w
    vault: lease_duration     1h
    vault: lease_renewable    true
    vault: password           A1a-6dkkQ6CbILtY6wXB
    vault: username           v-root-mysqlrole-2Zd2y4SARHaIqjN
```
8. Login to your db using generated username and password:

```
$ vagrant ssh db
vagrant@mysql:~$ mysql -u v-root-mysqlrole-2Zd2y4SARHaIqjN -p
Enter password:
```
