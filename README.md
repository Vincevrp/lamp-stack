# LAMP Stack

**L**inux (CentOS 7) + **A**pache + **M**ariaDB + **P**HP 7.2

## Requirements

* Vagrant
* Virtualbox

## Usage

Initialize using `vagrant up`.

### Access webserver root

Connect using SFTP to put files on the server:
* Username: `developer`
* Password: check config.yml or `./share`

### Create database

You can easily create a new database using `./scripts/create-database.sh`.

### Install Drupal

Drupal installation can be done automatically using `./scripts/install-drupal.sh`

## Configuration

```
name: 'LAMP Stack'              # Virtual machine name
cpus: 2                         # CPU cores
memory: 1024                    # RAM in MB
update: false                   # Run yum update
hostname: 'lamp-stack'          # Hostname for virtual machine
ip-address: 172.16.16.16        # IP address

auth:                           # If blank, will generate passwords to ./share folder
  db_root: 'db_root_passwd'     # MariaDB root password
  ssh: 'ssh_passwd'             # SSH password for user developer

folders:                        # Folder settings
  provision: './provision'
  share: './share'

                                # DigitalOcean settings
digitalocean:                   # Refer to vagrant-digitalocean docs
  api_key: ''
  ssh_username: 'vagrant'
  ssh_key_path: 'key'
  ssh_key_name: 'vagrant'
  region: 'ams3'
  size: '1gb'
```

