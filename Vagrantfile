# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

NUM_MANAGED_NODE = 2
IP_NW = "192.168.56."
MANAGED_IP_START = 200

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility).

Vagrant.configure("2") do |config|
  
  config.vm.box = "centos/8"
  config.vm.box_check_update = false
  config.ssh.insert_key = false

# config.vm.synced_folder "../.", "/vagrant_data"

# Provision ansible control Node
    
    config.vm.define "control" do |control|
    control.vm.hostname = "control.clevory.local"
		control.vm.network :private_network, ip: "192.168.56.200", dev: "virbr2", mode: "open" 
	  control.vm.provision "shell", path: "control.sh"
    control.vm.provider "libvirt" do |libvirt|
          libvirt.memory = 2048
      end
	end
 

  # Provision ansible managed Nodes
  
  (1..NUM_MANAGED_NODE).each do |i|
    
	config.vm.define "ansible#{i}" do |node|
	    node.vm.hostname = "ansible#{i}.clevory.local"
      node.vm.network :private_network, ip: IP_NW + "#{MANAGED_IP_START + i}", dev: "virbr2", mode: "open"
	    node.vm.provision "shell", path: "managed.sh"
      node.vm.provider "libvirt" do |libvirt|
            libvirt.memory = 2048
        end                
    end
  end
end
