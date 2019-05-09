# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "private_network", type: "dhcp"  
  

  config.vm.provider "virtualbox" do |vb|
     #Mostra el VirtualBox GUI
     vb.gui = true
     #Indiquem el nom que tindrà la nostra màquina
     vb.name = "UbuSrvrXenial64"
     #Asignem la memòria virtual
     vb.memory = "2048"
   end
    
   config.vm.hostname = "lamp" 
   #Ruta de l'script d'on instal·larà el servidor apache i mysql
   config.vm.provision "shell", path: "provision-for-lamp.sh"
end 
