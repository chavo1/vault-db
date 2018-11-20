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
$ vagrant ssh vault
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
## Application integration with consule-template and envconsul tools

[Consul-Template](https://github.com/hashicorp/consul-template) run daemon consul-template queries a Consul or Vault cluster and updates any number of specified templates on the file system.

9. Go to the vagrant directory
```
cd /vagrant
```
10. Create policies in Vault to control what a user can access
```
vault policy write db_creds db_creds.hcl
```
11. Create vault token for consule-template
```
vault token create -policy=db_creds
```
Run command for consule-teplate to create config.yml with filled in credentials

VAULT_TOKEN="5jiDLgS9fWx4T4i5ECOQc546" consul-template -template="config.yml.tpl:config.yml" -once

12. Generated config.yml file should should look as follow:

---
username: v-token-mysqlrole-2DaeaMMs7CG45m
password: A1a-3gS1qnrtiAKiVcse
database: "vaultdb"

[Envconsul](https://github.com/hashicorp/envconsul) provides a convenient way to launch a subprocess with environment variables populated from HashiCorp Consul and Vault. 

13. Execute a following command - if your application is able read ENV it need minimum chages to use the credentials. 

```
root@vault:/vagrant# VAULT_TOKEN="j5ycE1fHckQtPZUWnS37lLME" envconsul -upcase -secret database/creds/mysqlrole ./app.sh
2018/11/20 08:50:29.727156 looking at vault database/creds/mysqlrole
2018/11/20 08:50:29.730029 [WARN] vault.token: TTL of "767h26m59s" exceeded the effective max_ttl of "767h23m34s"; TTL value is capped accordingly
My connection info is:

  username: "v-token-mysqlrole-3hTv9VDEgeeRvH"
  password: "A1a-5pyNy4D06KTQ5D0w"
  database: "my-app
```
14. If you need you can check the credentials as follow:

```
root@vault:/vagrant# VAULT_TOKEN="j5ycE1fHckQtPZUWnS37lLME" envconsul -upcase -secret database/creds/mysqlrole env | grep DATABASE
2018/11/20 09:00:49.795401 looking at vault database/creds/mysqlrole
2018/11/20 09:00:49.796890 [WARN] vault.token: TTL of "767h23m34s" exceeded the effective max_ttl of "767h13m14s"; TTL value is capped accordingly
DATABASE_CREDS_MYSQLROLE_PASSWORD=A1a-2qMOrtJeajXZBzX9
```