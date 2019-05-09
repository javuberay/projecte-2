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

