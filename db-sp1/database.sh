#!/bin/bash

echo "Menyiapkan Installasi Database Server"    
sudo apt-get update    

echo "Melakukan Installasi Database Server"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password 123'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 123'    
sudo apt-get install -y mysql-server    
echo "Installasi Selesai"    

echo "Konfigurasi MySQL pada File /etc/mysql/mysql.conf.d/mysqld.cnf"
sudo cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.bak
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
echo "Update bind address MySQL pada File /etc/mysql/mysql.conf.d/mysqld.cnf agar mengizinkan koneksi eksternal"

echo "Restart Service Database Server"
sudo service mysql stop
sudo service mysql start
echo "Konfigurasi MySQL Selesai"

echo "CREATE DATABASE & USER"
sudo mysql -u root -p123 << EOF
CREATE DATABASE IF NOT EXISTS dbsosmed;
CREATE DATABASE IF NOT EXISTS dbwordpress;
CREATE USER IF NOT EXISTS 'devopscilsy'@'%' IDENTIFIED BY '1234567890';
GRANT ALL PRIVILEGES ON *.* TO 'devopscilsy'@'%';
FLUSH PRIVILEGES;
EOF
echo "Create Database & User Selesai"
