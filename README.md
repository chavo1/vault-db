# This is an example Vault repo which generate dynamic credential to login into MySQL db

## Rrequirment

1. Vagrant [installed](https://www.vagrantup.com/docs/installation/).
```
$ vagrant up
```
2. At the end of the process credentials will be generated as follow:
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
    vault: Use the above credentials to loging in your MYSQL database!
    ```
