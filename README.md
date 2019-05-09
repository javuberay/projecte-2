# Projecte Vagrant
# Pràctica 17

Aquesta és la nostra pràctica de Vagrant i explicació per a preparar i provisionar una màquina Linux amb els seu servei LAMP amb una aplicació d'administració de MYSQL usant ADMINER 

## Inici

Per a preparar l'entorn on s'allotjarà Vagrant, crearem una carpeta on guardarem tots els fitxers (i on romandrà el fitxer 'Vagrantfile') per a tenir centralitzat els fitxers amb els que treballarem durant la pràctica

### Prerequisits i creació de 'Vagrantfile'

Necesitarem tenir la màquina actualitzada amb les últimes actualitzacions de les llibreries i repositoris del sistema per si de cas ens falta alguna dependencia

Al tenir la carpeta creada on allotjarem els fitxers:

```
$ mkdir vagrant
$ cd vagrant/
$ vagrant init

```

Amb aquesta última comanda ens aparareixerà aquest codi si hem realitzat correctament l'allotjament per al fitxer 'Vagrantfile'

```

A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.

```

### Fitxer 'Vagrantfile'

Quan tinguem localitzat el fitxer de 'Vagrantfile', podem veure la plantilla que ens autogenera per defecte

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "base"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end

```

## Configuració

Els paràmetres que configurarem seran els de la màquina inicialitzada amb Virtualbox (provider)

```
#Configuració de la màquina virtualbox que serà creada
Vagrant.configure("2") do |config|
  #Seleccionant la imatge de Vagrant hub files
  config.vm.box = "ubuntu/xenial64"
  #Configurant la tarjeta a 'Adaptador de només l'amfitrió' amb DHCP
  config.vm.network "private_network", type: "dhcp"  
  
  #Provisionant la màquina virtual
  config.vm.provider "virtualbox" do |vb|
     #Mostra el VirtualBox GUI
     vb.gui = true
     #Indiquem el nom/etiqueta que tindrà la nostra màquina
     vb.name = "UbuSrvrXenial64"
     #Asignem la memòria virtual
     vb.memory = "2048"
   end
   
   #Configuració del servei
   config.vm.hostname = "lamp" 
   #Ruta de l'script d'on instal·larà el servidor apache i mysql
   config.vm.provision "shell", path: "provision-for-lamp.sh"
end 

```
Script per a la instalació en 'Vagrantfile' per tal de fer-ho automàticament

```

#!/bin/bash

#APACHE/PHP
apt-get update
apt-get install -y apache2
apt-get install -y php libapache2-mod-php php-mysql
sudo /etc/init.d/apache2 restart
cd /var/www/html

#ADMINER
wget https://github.com/vrana/adminer/releases/download/v4.3.1/adminer-4.3.1-mysql.php
mv adminer-4.3.1-mysql.php adminer.php

#MYSQL
apt-get update
apt-get -y install debconf-utils
DB_ROOT_PASSWD=root
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"
apt-get install -y mysql-server

#Indiquem que es pugui connectar des de qualsevol lloc al servidor Mysql
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf /etc/init.d/mysql restart

#Assignem tots els permisos per a l'usuari root
mysql -u root mysql -p $DB_ROOT_PASSWD <<< "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '$DB_ROOT_PASSWD';FLUSH PRIVILEGES;"

#Creem una base de dades per tal de consultar-la amb l'adminer
mysql -u root mysql -p $DB_ROOT_PASSWD <<< "CREATE DATABASE projecte17;"


```
## Autors

* **Javier Úbeda** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

* **Tomàs Silva** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
