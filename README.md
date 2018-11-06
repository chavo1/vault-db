# This repo contains an example how to generate dynamic credential with Vault to login into MySQL DB.

## Rrequirment

1. Vagrant [installed](https://www.vagrantup.com/docs/installation/).

2. Clone the repo:
```
$ git clone https://github.com/chavo1/vault-db.git && cd vault-db
$ vagrant up
```
3. At the end of the process credentials will be generated as follow:
```
vault: Tell Vault to generate a new login to MySQL database
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
4. Login to your db using generated username and password:

```
$ vagrant ssh db
vagrant@mysql:~$ mysql -u v-root-mysqlrole-2Zd2y4SARHaIqjN -p
Enter password:
```
