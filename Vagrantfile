Vagrant.configure("2") do |config|
  
  config.vm.define "vault" do |vault|
    config.vm.box = "chavo1/xenial64base"
      
    vault.vm.hostname = "vault"
    vault.vm.network "private_network", ip: "192.168.56.56"
    vault.vm.network "forwarded_port", guest: 8200, host: 8200
    vault.vm.provision :shell, :path => "scripts/provision.sh"
    vault.vm.provision :shell, :path => "scripts/vault.sh", run: "always"
    
    # set VM specs
    config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
    end  
  end
  
  config.vm.define "db" do |db|
    db.vm.box = "chavo1/mysql"
    db.vm.hostname = "mysql"
    db.vm.network "private_network", ip: "192.168.56.57"
    db.vm.network "forwarded_port", guest: 3306, host: 3306
    db.vm.provision :shell, :path => "scripts/bind-add.sh"
    
    # set VM specs
    config.vm.provider "virtualbox" do |v2|
      v2.memory = 1024
      v2.cpus = 2
    end
  end

end
