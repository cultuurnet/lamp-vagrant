# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.librarian_puppet.puppetfile_dir = "puppet"
  config.librarian_puppet.use_v1_api  = '0'
  config.librarian_puppet.destructive = false

  config.vm.box = "cultuurnet/ubuntu-14.04-64-puppet"
  config.vm.box_version = "1.0.1"

  config.cache.scope = :box
  config.cache.auto_detect = false
  config.cache.enable :apt
  config.cache.enable :composer
  config.cache.synced_folder_opts = {
    type: :nfs,
    mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
  }

  config.vm.provision "fix-no-tty", type: "shell" do |shell|
    shell.privileged = false
    shell.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.provision "fix-puppet-templatedir-warning", type: "shell" do |shell|
    shell.privileged = false
    shell.inline = "sudo sed -i '/^templatedir/d' /etc/puppet/puppet.conf"
  end

  # Hack needed because of Vagrant mangling /etc/hosts (see https://github.com/mitchellh/vagrant/issues/7263)
  # Fix scheduled for Vagrant 1.8.2. In the meantime, dirty fix provided in:
  # http://stackoverflow.com/questions/33117939/vagrant-do-not-map-hostname-to-loopback-address-in-etc-hosts
  config.vm.provision "fqdn-in-etc-hostname", type: "shell" do |shell|
    shell.privileged = true
    shell.inline = "hostname --fqdn > /etc/hostname && hostname -F /etc/hostname"
  end

  config.vm.provision "fix-etc-hosts", type: "shell" do |shell|
    shell.privileged = false
    shell.inline = "sudo sed -ri 's/127\.0\.0\.1\s.*/127.0.0.1 localhost localhost.localdomain/' /etc/hosts"
  end

  config.vm.define "lamp", autostart: true, primary: true do |lamp|
    lamp.vm.hostname = "lamp.dev"
    lamp.vm.box = "cultuurnet/ubuntu-14.04-64-puppet"
    lamp.vm.box_version = "1.0.1"

    lamp.vm.network "private_network", ip: "192.168.144.110", lxc__bridge_name: 'lxcbr1'

    lamp.vm.provider "virtualbox" do |virtualbox|
      virtualbox.memory = 512
      virtualbox.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
    end

    lamp.vm.provider "lxc" do |lxc|
      lxc.customize 'cgroup.memory.limit_in_bytes', '512M'
    end

    lamp.vm.synced_folder "sites", "/var/www/sites", owner: "www-data", group: "www-data", create: true

    lamp.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "site.pp"
      puppet.module_path = "puppet/modules"
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.facter = {
        "nodename"    => "lamp",
        "noop_deploy" => ENV['without_deploy'] == "true" ? true : false
      }
    end
  end
end
