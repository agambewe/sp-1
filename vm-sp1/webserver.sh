#!/bin/bash

echo "Menyiapkan Installasi"
sudo apt update
#apt-get -y upgrade

echo "Melakukan Installasi Webserver"
#sudo apt install -y apache2 php php-mysql git
#sudo apt -y install apache2 php5 mysql-server git
#sudo apt -f install
#mysql-server mysql-client
sudo apt-get install -y apache2 php php-mysql mysql-client libapache2-mod-php

echo "Membuat Direktori Server"
sudo mkdir -p /var/www/html/sosialmedia
sudo mkdir -p /var/www/html/wordpress
sudo mkdir -p /var/www/html/landingpage

echo "Set Ownership Direktori Server Blocks"
sudo chown -R vagrant:vagrant /var/www/html/sosialmedia
sudo chown -R vagrant:vagrant /var/www/html/wordpress
sudo chown -R vagrant:vagrant /var/www/html/landingpage

echo "Set Permission Folder /var/www"
sudo chmod -R 755 /var/www

#download sc sosialmedia
echo "Clone Source Code Sosialmedia"
if [ -d "/var/www/html/sosialmedia" ] 
then
    echo "Directory Sosialmedia Already Exists." 
else
    git clone https://github.com/sdcilsy/sosial-media.git
    mv sosial-media/* /var/www/html/sosialmedia
    rm -rf sosial-media
    sed -i 's/localhost/192.168.56.56/g' /var/www/html/sosialmedia/config.php
    #sed -i "s/db_user = "devopscilsy"/db_user = "user_sp1"/g" /var/www/html/sosialmedia/config.php
    #sed -i "s/db_pass = "1234567890"/db_pass = "12345678"/g" /var/www/html/sosialmedia/config.php
    echo "Sucess Clone Sosialmedia."

    echo "Dump sql"
    #service mysql status
    mysql -h 192.168.56.56 -u devopscilsy -p1234567890 dbsosmed< /var/www/html/sosialmedia/dump.sql
fi

#configure wordpress
echo "Clone Source Code Wordpress"
if [ -d "/var/www/html/wordpress" ] 
then
    echo "Directory Wordpress Already Exists."
else
    git clone https://github.com/agambewe/WordPress.git
    mv WordPress/* /var/www/html/wordpress
    rm -rf WordPress

    sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'DB_NAME', 'database_name_here'/'DB_NAME', 'wordpress_db'/g" /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'DB_USER', 'username_here'/'DB_USER', 'devopscilsy'/g" /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'DB_PASSWORD', 'password_here'/'DB_PASSWORD', '1234567890'/g" /var/www/html/wordpress/wp-config.php
    sudo sed -i 's/localhost/192.168.56.56/g' /var/www/html/wordpress/wp-config.php
    #sed -i "s/'DB_HOST', 'localhost'/'DB_HOST', '12345678'/g" /tmp/wordpress/wp-config.php
    echo "Sucess Clone Wordpress."
fi

#download sc landingpage
    echo "Clone Source Code landing-page"
if [ -d "/var/www/html/landingpage" ] 
then
    echo "Directory landing-page Exists." 
else
    git clone https://github.com/sdcilsy/landing-page.git
    mv landing-page/* /var/www/html/landingpage
    rm -rf landing-page
    echo "Sucess Clone landing-page."
fi

#configurasi apache
echo "Configurasi Apache"
sudo cp /vagrant/sosialmedia.conf /etc/apache2/sites-enabled/
sudo cp /vagrant/wordpress.conf /etc/apache2/sites-enabled/
sudo cp /vagrant/landingpage.conf /etc/apache2/sites-enabled/

echo "Restart Service"
#sudo service apache2 restart;
sudo systemctl restart apache2