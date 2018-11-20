#!/usr/bin/env bash

CONSUL=1.4.0
CONSULTEMPLATE=0.19.5
ENVCONSUL=0.7.3

PKG="wget unzip"
which ${PKG} &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y ${PKG}
}

# check consul binary
which consul || {
  pushd /usr/local/bin
  [ -f consul_${CONSUL}_linux_amd64.zip ] || {
    sudo wget https://releases.hashicorp.com/consul/${CONSUL}/consul_${CONSUL}_linux_amd64.zip
  }
  sudo unzip consul_${CONSUL}_linux_amd64.zip
  sudo chmod +x consul
  popd
}

# check consul-template binary
which consul-template || {
  pushd /usr/local/bin
  [ -f consul-template_${CONSULTEMPLATE}_linux_amd64.zip ] || {
    sudo wget https://releases.hashicorp.com/consul-template/${CONSULTEMPLATE}/consul-template_${CONSULTEMPLATE}_linux_amd64.zip
  }
  sudo unzip consul-template_${CONSULTEMPLATE}_linux_amd64.zip
  sudo chmod +x consul-template
  popd
}

# check envconsul binary
which envconsul || {
  pushd /usr/local/bin
  [ -f envconsul_${ENVCONSUL}_linux_amd64.zip ] || {
    sudo wget https://releases.hashicorp.com/envconsul/${ENVCONSUL}/envconsul_${ENVCONSUL}_linux_amd64.zip
  }
  sudo unzip envconsul_${ENVCONSUL}_linux_amd64.zip
  sudo chmod +x envconsul
  popd
}