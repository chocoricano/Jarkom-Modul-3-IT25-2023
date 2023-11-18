#!/bin/bash

echo nameserver 192.168.122.1 > /etc/resolv.conf
apt update && apt install ne -y

# masukan ke ~/.bashrc
echo "echo nameserver 192.168.122.1 > /etc/resolv.conf
apt update && apt install ne -y
" > ~/.bashrc

apt remove --purge *mysql* -y
apt remove --purge *mariadb* -y
rm -rf /etc/mysql /var/lib/mysql
apt autoremove -y
apt autoclean -y

apt-get install mariadb-server -y

service mysql start