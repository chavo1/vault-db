#!/usr/bin/env bash

if [ -d /vagrant ]; then
  mkdir /vagrant/logs
  LOG="/vagrant/logs/vault_${HOSTNAME}.log"
else
  LOG="vault.log"
fi

#lets kill past instance
sudo killall vault &>/dev/null

#delete old token if present
[ -f /root/.vault-token ] && sudo rm /root/.vault-token

#start vault
sudo /usr/local/bin/vault server  -dev -dev-listen-address=0.0.0.0:8200  &> ${LOG} &
echo vault started
sleep 3 

grep VAULT_ADDR ~/.bashrc || {
  echo export VAULT_ADDR=http://127.0.0.1:8200 | sudo tee -a ~/.bashrc
}

echo "vault token:"
cat /root/.vault-token
echo -e "\nvault token is on /root/.vault-token"
  
# enable secret KV version 1
sudo VAULT_ADDR="http://127.0.0.1:8200" vault secrets enable -version=1 kv
  
# setup .bashrc
grep VAULT_TOKEN ~/.bashrc || {
  echo export VAULT_TOKEN=\`cat /root/.vault-token\` | sudo tee -a ~/.bashrc
}