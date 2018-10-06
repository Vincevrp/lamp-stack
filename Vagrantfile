# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Import config.yml
settings  = YAML.load_file File.dirname(File.expand_path(__FILE__)) + '/config.yml'
auth      = settings['auth']
provision = settings['folders']['provision']
share     = settings['folders']['share']
digitalocean = settings['digitalocean']

# Use version 2
Vagrant.configure("2") do |config|

  # Import Centos 7 box
  config.vm.box = "bento/centos-7.4"

  # Virtualbox settings
  config.vm.provider "virtualbox" do |vb|
    vb.name = settings['name']
    vb.cpus = settings['cpus']
    vb.memory = settings['memory']
  end

  # DigitalOcean settings
  config.vm.provider "digital_ocean" do | oc, override |
    override.vm.box = 'digital_ocean'
    override.ssh.username = digitalocean['ssh_username']
    override.ssh.private_key_path = digitalocean['ssh_key_path']
    override.vm.provision "firewall",
      type: "shell",
      args: "eth0",
      path: provision + "/firewall.sh"
    oc.ssh_key_name = digitalocean['ssh_key_name']
    oc.setup = true
    oc.token = digitalocean['api_key']
    oc.image = "centos-7-x64"
    oc.region = digitalocean['region']
    oc.size = digitalocean['size']
  end

  # Provisioning
  if settings['update'] then
    config.vm.provision "update",
      type: "shell",
      inline: "yum update -y"
  end

   config.vm.provision "selinux",
       type: "shell",
       path: provision + "/selinux.sh"

   config.vm.provision "apache",
       type: "shell",
       path: provision + "/apache.sh"

   config.vm.provision "mariadb",
       type: "shell",
       args: auth['db_root'],
       path: provision + "/mariadb.sh"

   config.vm.provision "php",
       type: "shell",
       path: provision + "/php.sh"

   config.vm.provision "ssh",
       type: "shell",
       args: auth['ssh'],
       path: provision + "/ssh.sh"

   config.vm.provision "firewall",
       type: "shell",
       args: "enp0s8",
       path: provision + "/firewall.sh"

  # Rsync current folder
  config.vm.synced_folder ".", "/vagrant", type:"rsync",
    rsync__exclude: ["Vagrantfile", "share/", "scripts/", "docs/", "*.yml", "*.md"]

  # Shared folder
  config.vm.synced_folder share, '/vagrant/share', create: true

  # Network configuration
  config.vm.hostname = settings['hostname']
  config.vm.network "private_network", ip: settings['ip-address']

end
