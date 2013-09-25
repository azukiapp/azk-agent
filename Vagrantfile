# -*- mode: ruby -*-
# # vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.synced_folder "/var/lib/azk", "/azk-nfs", id: "azk", :nfs => true, :mount_options => ['nolock,vers=3,udp']

  config.bindfs.bind_folder "/azk-nfs", "/azk"

  # improvement: mapping the folder docker
  #config.bindfs.bind_folder "/azk-nfs/docker", "/var/lib/docker", :owner => "root", :group => "root"

  config.vm.provision :ansible do |ansible|
    ansible.verbose  = true
    ansible.sudo     = true
    ansible.playbook = "provisioning/playbook.yml"
    ansible.inventory_path = "provisioning/ansible_hosts"
  end
end
