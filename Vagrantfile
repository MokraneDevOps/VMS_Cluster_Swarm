# -*- mode: ruby -*-
# vi: set ft=ruby -*-
VM1 = "master"
VM2 = "worker1"
VM3 = "worker2"
NETWORK_BASE = "192.168.198"

Vagrant.configure("2") do |config|
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: false

  # Configuration pour la machine virtuelle "master"
  config.vm.define VM1 do |master|
    master.vm.box = "generic/ubuntu2004"
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "#{NETWORK_BASE}.10"

    master.vm.provider "vmware_workstation" do |vmw|
      vmw.vmx["memsize"] = "4096"
      vmw.vmx["numvcpus"] = "2"
    end

    master.vm.provision :shell, path: "install_docker.sh"
    master.vm.provision :shell, path: "install_ansible.sh"
    master.vm.provision :shell, inline: <<-SHELL
      # Copie des clés SSH
      mkdir -p /home/vagrant/.ssh
      cp /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
      cp /vagrant/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub
      cat /vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
      chmod 600 /home/vagrant/.ssh/id_rsa
      chmod 600 /home/vagrant/.ssh/authorized_keys
      chown -R vagrant:vagrant /home/vagrant/.ssh

      docker swarm init --advertise-addr #{NETWORK_BASE}.10
      TOKEN=$(docker swarm join-token -q worker)
      echo "export SWARM_JOIN_TOKEN=$TOKEN" >> /vagrant/swarm_token.sh
      echo "export SWARM_JOIN_ADDR=#{NETWORK_BASE}.10:2377" >> /vagrant/swarm_token.sh
    SHELL
  end

  # Configuration pour la machine virtuelle "worker1"
  config.vm.define VM2 do |worker1|
    worker1.vm.box = "generic/ubuntu2004"
    worker1.vm.hostname = "worker1"
    worker1.vm.network "private_network", ip: "#{NETWORK_BASE}.11"

    worker1.vm.provider "vmware_workstation" do |vmw|
      vmw.vmx["memsize"] = "4096"
      vmw.vmx["numvcpus"] = "2"
    end

    worker1.vm.provision :shell, path: "install_docker.sh"
    worker1.vm.provision :shell, path: "install_ansible.sh"
    worker1.vm.provision :shell, inline: <<-SHELL
      # Copie des clés SSH
      mkdir -p /home/vagrant/.ssh
      cp /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
      cp /vagrant/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub
      cat /vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
      chmod 600 /home/vagrant/.ssh/id_rsa
      chmod 600 /home/vagrant/.ssh/authorized_keys
      chown -R vagrant:vagrant /home/vagrant/.ssh

      source /vagrant/swarm_token.sh
      docker swarm join --token $SWARM_JOIN_TOKEN $SWARM_JOIN_ADDR
    SHELL
  end

  # Configuration pour la machine virtuelle "worker2"
  config.vm.define VM3 do |worker2|
    worker2.vm.box = "generic/ubuntu2004"
    worker2.vm.hostname = "worker2"
    worker2.vm.network "private_network", ip: "#{NETWORK_BASE}.12"

    worker2.vm.provider "vmware_workstation" do |vmw|
      vmw.vmx["memsize"] = "4096"
      vmw.vmx["numvcpus"] = "2"
    end

    worker2.vm.provision :shell, path: "install_docker.sh"
    worker2.vm.provision :shell, path: "install_ansible.sh"
    worker2.vm.provision :shell, inline: <<-SHELL
      # Copie des clés SSH
      mkdir -p /home/vagrant/.ssh
      cp /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
      cp /vagrant/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub
      cat /vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
      chmod 600 /home/vagrant/.ssh/id_rsa
      chmod 600 /home/vagrant/.ssh/authorized_keys
      chown -R vagrant:vagrant /home/vagrant/.ssh

      source /vagrant/swarm_token.sh
      docker swarm join --token $SWARM_JOIN_TOKEN $SWARM_JOIN_ADDR
    SHELL
  end
end
