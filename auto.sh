#!/bin/bash
#Instalação php 7, apache2, mysql, phpmyadmin, git, vim, testado em servidores ubuntu

echo
echo "Script para ubuntu"
echo
echo "Aguarde 2 segundos..."
sleep 2
clear
echo "------Facilitando sua vida no Linux!----------"
echo
####MENU DE PROGRAMAS#####
echo "::Digite o numero e tecle enter ou para cancelar feche no (X)::

1-Update e upgrade
2-Instalar apache2
3-Instalar mysql
4-Instalar phpmyadmin 
5-Instalar php8.1 - (servidores ubuntu 22.04)
6-Instalar git
7-Instalar vim
8-Instalar composer
9-Instalar Laravel 
10-Reiniciar o apache2
"
echo 

####INSTALAÇÃO DE PROGRAMAS#####
read programas

if [ "$programas" = "1" ];
then 
    echo "--- Iniciando update ---"
    sleep 3
	sudo apt-get update 

    echo "--- Iniciando upgrade ---"
    sleep 3
	sudo apt-get -y upgrade    
    echo "--- Fim da Atualização---"

elif [ "$programas" = "2" ];
then
    echo "--- Iniciando Instalação apache ---"
    sleep 3
    sudo apt-get -y install apache2
    sudo ufw app list
    sudo ufw allow 'Apache'
    sudo ufw status    
    echo "--- Fim da intalação apache ---"  

elif [ "$programas" = "3" ];
then
    echo "--- Instalando MySQL  ---"
    sleep 3
    read -p "Entre com a senha Mysql somente uma vez e tecle Enter para continuar::" senha
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $senha"
	sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $senha"
    sudo apt-get -y install mysql-server   
    sudo service mysql restart
    echo "--- Fim da instalação MySQL ---"   

elif [ "$programas" = "4" ];
then
    echo "--- Instalando Phpmyadmin  ---"
    sleep 3
    read -p "Entre com a senha PHPmyadmin somente uma vez e tecle Enter para continuar::" senha
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $senha"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $senha"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $senha"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
    sudo apt-get -y install phpmyadmin
    echo "--- Fim da Instalação Phpmyadmin ---" 

elif [ "$programas" = "5" ];
then
    echo "--- instalar extensoes php 8 ---"
    sleep 3
    sudo apt-get -y install php8.1 
    sudo apt-get -y install libapache2-mod-php8.1 
    sudo apt-get -y install php8.1-pear 
    sudo apt-get -y install php8.1-dev 
    sudo apt-get -y install php8.1-zip 
    sudo apt-get -y install php8.1-curl 
    sudo apt-get -y install php8.1-xmlrpc 
    sudo apt-get -y install php8.1-gd 
    sudo apt-get -y install php8.1-mbstring 
    sudo apt-get -y install php8.1-xml mcrypt 
    sudo apt-get -y install php8.1-common 
    sudo apt-get -y install php8.1-cli 
    sudo apt-get -y install php8.1-intl 
    sudo apt-get -y install php8.1-bcmath 
    sudo apt-get -y install php8.1-imap 
    sudo apt-get -y install php8.1-tokenizer 
    sudo apt-get -y install php8.1-json 
    sudo apt-get -y install php8.1-pgsql 
    sudo apt-get -y install php8.1-soap 
    sudo apt-get -y install php8.1-xs 
    sudo apt-get -y install php8.1-odbc 
    sudo apt-get -y install php8.1-apcu 
    sudo apt-get -y install php8.1-imagick 
    sudo apt-get -y install php8.1-fpm
    sudo apt-get -y install php8.1-ldap
    sudo apt-get -y install php8.1-mysql 
    sudo apt-get -y install php8.1-sqlite
    sudo apt-get -y install php8.1-sqlite3
    sudo apt-get -y install php8.1-redis

    echo "Reniciando Apache"
    sleep 3
    sudo apt-get -y install yarn
    sudo apt-get -y install nodejs
    sudo apt-get -y install npm
    sudo apt-get -y install redis-server
    sudo service mysql restart
    sudo systemctl restart redis.service
    sudo /etc/init.d/apache2 restart

    echo "--- Fim da instalação PHP 8 ---" 
    php -v

elif [ "$programas" = "6" ];
then
    echo "--- Instalando GIT  ---"
    sudo apt-get -y install git
	read -p "Entre com seu nome::" name
	git config --global user.name "$name"
	read -p "Entre com seu email::" email
	git config --global user.email "$email"
	git config --list
    echo "--- Fim da instalação do GIT  ---"

elif [ "$programas" = "7" ];
then 
   echo "Instalando vim" 
   sudo apt-get -y install vim
   echo "Fim da instalação vim" 

elif [ "$programas" = "8" ];
then 
   echo "Instalando composer" 
   sleep 3 
    sudo apt install curl
    curl -sS https://getcomposer.org/installer -o composer-setup.php
    HASH=`curl -sS https://composer.github.io/installer.sig`
    echo $HASH
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
   echo "Fim da instalação composer" 

elif [ "$programas" = "9" ];
then 
    echo "instalação e configuracao do host do laravel"    
    sleep 3 
    read -p "Entre com o nome do projeto::" project
    read -p "Entre com a versao do projeto exemplo 6.* ::" version
    read -p "Entre com seu email para server admin ::" serveradmin
    read -p "Entre com a url servename exemplo dev.com ::" servername
    composer create-project --prefer-dist laravel/laravel /var/www/html/${project} "${version}"
      
# read -p "Entre com ::" hostname
# sudo touch "$hostname" /etc/apache2/sites-available/

echo "Editando arquivo host" 
sleep 3 
echo "--- arquivo host ---"
VHOST=$(cat <<EOF
<VirtualHost *:80>
    ServerAdmin ${serveradmin}
    ServerName  ${project}.${servername}
    ServerAlias ${project}.${servername}
    DocumentRoot "/var/www/html/${project}/public"
    <Directory "/var/www/html/${project}/public">
        AllowOverride All
        Require all granted
    </Directory>    
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/${project}.conf
echo "Inserido permição na pasta" 
sleep 3 
sudo chmod -R 777 /var/www/html/"$project"

echo "--- habilitar mod-rewrite do apache ---"
sleep 3 
sudo a2enmod rewrite
echo "--- habilitar hostname ---"
sleep 3 
sudo a2ensite ${project}.conf
echo "--- habilitar mod-rewrite do apache ---"
sleep 3 
sudo service apache2 reload
echo "--- Configurando host no ubuntu ---"
sleep 3 
sudo echo 127.0.1.7 ${project}.${servername} >>/etc/hosts
#composer show laravel/framework


elif [ "$programas" = "10" ];
then 
   echo "Reniciando Apache"
   sleep 3 
   sudo /etc/init.d/apache2 restart
   php -v
fi

####LOOP E VOLTA AO MENU#####
echo "Deseja instalar outro programa? [s/n]"
 read programas2

if [ "$programas2" = "s" ];
then 
 ./auto.sh
 
else
 exit
fi

