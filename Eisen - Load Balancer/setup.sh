#!/bin/bash

echo nameserver 192.168.122.1 > /etc/resolv.conf
apt update && apt install ne -y

# masukan ke ~/.bashrc
echo "echo nameserver 192.168.122.1 > /etc/resolv.conf
apt update && apt install ne -y
" > ~/.bashrc

apt autoremove nginx -y
# instal dependencies

apt install -y lsb-release apt-transport-https ca-certificates wget nginx apache2-utils
service nginx start

mkdir /etc/nginx/rahasisakita

htpasswd -bc /etc/nginx/rahasisakita/htpasswd netics ajkit25
# Mengatur load balancer dengan Round Robin
cat > /etc/nginx/conf.d/load_balancer_round_robin.conf <<EOF
upstream backend_round_robin {
    server 10.76.3.1;
    server 10.76.3.2;
    server 10.76.3.3;
}

server {
    listen 81;

    location / {
        # Konfigurasi pembatasan akses IP
        allow 127.0.0.1;
        allow 10.76.3.69;
        allow 10.76.3.70;
        allow 10.76.4.167;
        allow 10.76.4.168;
        deny all;

        # auth
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/rahasisakita/htpasswd;
        proxy_pass http://backend_round_robin;
    }

    location /its {
            rewrite ^/its(.*)$ https://www.its.ac.id$1 permanent;
    }
}
EOF

# Mengatur load balancer dengan Least Connection
cat > /etc/nginx/conf.d/load_balancer_least_conn.conf <<EOF
upstream backend_least_conn {
    least_conn;
    server 10.76.3.1;
    server 10.76.3.2;
    server 10.76.3.3;
}

server {
    listen 82;
    location / {
        # Konfigurasi pembatasan akses IP dan berikan juga akses untuk localhost
        allow 127.0.0.1;
        allow 10.76.3.69;
        allow 10.76.3.70;
        allow 10.76.4.167;
        allow 10.76.4.168;
        deny all;

        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/rahasisakita/htpasswd;
        proxy_pass http://backend_least_conn;
    }

    location /its {
            rewrite ^/its(.*)$ https://www.its.ac.id$1 permanent;
    }
}
EOF

# Mengatur load balancer dengan IP Hash
cat > /etc/nginx/conf.d/load_balancer_ip_hash.conf <<EOF
upstream backend_ip_hash {
    ip_hash;
    server 10.76.3.1;
    server 10.76.3.2;
    server 10.76.3.3;
}

server {
    listen 83;
    location / {
        # Konfigurasi pembatasan akses IP
        allow 127.0.0.1;
        allow 10.76.3.69;
        allow 10.76.3.70;
        allow 10.76.4.167;
        allow 10.76.4.168;
        deny all;
        
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/rahasisakita/htpasswd;
        proxy_pass http://backend_ip_hash;
    }

    location /its {
            rewrite ^/its(.*)$ https://www.its.ac.id$1 permanent;
        }
}
EOF

nginx -t
# Restart Nginx untuk menerapkan konfigurasi
service nginx restart