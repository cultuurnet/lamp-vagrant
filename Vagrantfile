# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.librarian_puppet.puppetfile_dir = "puppet"
  config.librarian_puppet.use_v1_api  = '0'
  config.librarian_puppet.destructive = false

  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"
  config.vm.box_version = "1.0.1"

  config.cache.scope = :box
  config.cache.auto_detect = false
  config.cache.enable :apt

  config.vm.network "private_network", type: "dhcp"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 1080, host: 1080
  config.vm.network "forwarded_port", guest: 3306, host: 3306

  config.vm.synced_folder "sites", "/var/www/sites", type: "nfs", create: true

  config.vm.provision "fix-no-tty", type: "shell" do |shell|
    shell.privileged = false
    shell.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.provision "fix-puppet-templatedir-warning", type: "shell" do |shell|
    shell.privileged = false
    shell.inline = "sudo sed -i '/^templatedir/d' /etc/puppet/puppet.conf"
  end

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "site.pp"
    puppet.module_path = "puppet/modules"
    puppet.hiera_config_path = "puppet/hiera.yaml"
  end
end
