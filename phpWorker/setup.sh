#!/bin/bash

# Update apt cache
apt-get update

# Install PHP dan dependencies lainnnya
apt install -y lsb-release apt-transport-https ca-certificates wget
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt-get update
apt install -y php7.3 php7.3-mbstring php7.3-xml php7.3-cli php7.3-common php7.3-intl php7.3-opcache php7.3-readline php7.3-mysql php7.3-fpm php7.3-curl unzip wget nginx

# Start nginx service
service nginx start

# membuat direktori jarkom untuk menyimpan file web nya
mkdir /var/www/jarkom

#download file webnya dengan curl
curl -L --insecure "https://drive.google.com/uc?export=download&id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1" -o granz.zip

#unzip file webnya
unzip granz.zip -d /var/www
rm granz.zip

mv /var/www/modul-3/* /var/www/jarkom/
rm -rf /var/www/modul-3

# Konfigurasi Nginx agar bisa mengakses file php
echo 'server {
    listen 80;
    root /var/www/jarkom;
    index index.php index.html index.htm;
    server_name 10.76.3.1 10.76.3.2 10.76.3.3;
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
    }
    location ~ /\.ht {
        deny all;
    }
    
    error_log /var/log/nginx/jarkom_error.log;
    access_log /var/log/nginx/jarkom_access.log;
}' >/etc/nginx/sites-available/jarkom.conf

# Mengaktifkan konfigurasi jarkom
ln -s --force /etc/nginx/sites-available/jarkom.conf /etc/nginx/sites-enabled/

# Remove default Nginx configuration
rm /etc/nginx/sites-enabled/default

# Restart Nginx service
service nginx restart
service nginx status

# Start PHP-FPM service
service php7.3-fpm start
service php7.3-fpm status
