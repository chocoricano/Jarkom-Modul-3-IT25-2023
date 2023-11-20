# Jarkom-Modul-3-IT25-2023

## Modul 3 Jarkom IT25

### Anggota :

- ANDYANA MUHANDHATUL NABILA - 5027211029
- ANDREAS TIMOTIUS PARHORASAN SIHOMBING - 5027211019

- 
## Topologi 
<a href="https://ibb.co/RH1v9N3"><img src="https://i.ibb.co/zf1nrFX/283197783-b7ae49b5-70ff-4520-b0b0-d4f740f09198.png" alt="283197783-b7ae49b5-70ff-4520-b0b0-d4f740f09198" border="0"></a>

## Konfigurasi Awal
Jalankan semua setup.sh yang ada pada github sesuai dengan namanya

## No 0
diminta untuk melakukan register domain berupa riegel.canyon.yyy.com untuk worker Laravel dan granz.channel.yyy.com untuk worker PHP yang mengarah pada worker yang memiliki IP [prefix IP].x.1.


## Konfigurasi aura DHCP relay
```bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt update && apt install ne -y

# masukan ke ~/.bashrc
echo "echo nameserver 192.168.122.1 > /etc/resolv.conf
apt update && apt install ne -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.76.0.0/16
" > ~/.bashrc

# instal dhcp relay dan lakukan enter 3 kali 
apt-get install isc-dhcp-relay -y
echo '# Defaults for isc-dhcp-relay initscript
# sourced by /etc/init.d/isc-dhcp-relay
# installed at /etc/default/isc-dhcp-relay by the maintainer scripts

#
# This is a POSIX shell fragment
#

# What servers should the DHCP relay forward requests to?
SERVERS="10.76.1.2"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES="eth1 eth2 eth3 eth4"

# Additional options that are passed to the DHCP relay daemon?
OPTIONS=""
' > /etc/default/isc-dhcp-relay

# restart dhcp relay
service isc-dhcp-relay stop
service isc-dhcp-relay start

# setelah melakukan setting lakukan uncoment pada /etc/sysctl.conf sesuai modul
# dibawah sudah saya sediakan uncoment untuk net.ipv4.ip_forward=1
# uncoment net.ipv4.ip_forward=1 pada /etc/sysctl.conf
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

# restart 
service isc-dhcp-relay restart

```

dengan script setup.sh diatas pada aura
## Konfigurasi Himmel

```bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt update && apt install ne -y

# masukan ke ~/.bashrc
echo "echo nameserver 192.168.122.1 > /etc/resolv.conf
apt update && apt install ne -y
" > ~/.bashrc


apt-get install isc-dhcp-server -y

echo '#DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf

# Path to dhcpd PID file (default: /var/run/dhcpd.pid).
#DHCPDv4_PID=/var/run/dhcpd.pid
#DHCPDv6_PID=/var/run/dhcpd6.pid

# Additional options to start dhcpd with.
#       Dont use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4="eth0"
#INTERFACESv6=""' > /etc/default/isc-dhcp-server

#tambah di paling bawah /etc/dhcp/dhcpd.conf
# Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.16 - [prefix IP].3.32 dan [prefix IP].3.64 - [prefix IP].3.80
#Client yang melalui Switch4 mendapatkan range IP dari [prefix IP].4.12 - [prefix IP].4.20 dan [prefix IP].4.160 - [prefix IP].4.168
echo '# Konfigurasi untuk client yang terhubung melalui Switch3
subnet 10.76.3.0 netmask 255.255.255.0 {
    range 10.76.3.16 10.76.3.32; # 16-32
    range 10.76.3.64 10.76.3.80; # 64-80
    option routers 10.76.3.254;
    option broadcast-address 10.76.3.255;
    option domain-name-servers 10.76.1.3; # Ip Heiter
    default-lease-time 180; # 3 menit dalam detik
    max-lease-time 5760; # 96 menit dalam detik
}

# Konfigurasi untuk client yang terhubung melalui Switch4
subnet 10.76.4.0 netmask 255.255.255.0 {
    range 10.76.4.12 10.76.4.20; # 12-20
    range 10.76.4.160 10.76.4.168; # 160-168
    option routers 10.76.4.254;
    option broadcast-address 10.76.4.255;
    option domain-name-servers 10.76.1.3; # Ip Heiter
    default-lease-time 720; # 12 menit dalam detik
    max-lease-time 5760; # 96 menit dalam detik
}

subnet 10.76.1.0 netmask 255.255.255.0 {
    option routers 10.76.1.1;
    option broadcast-address 10.76.1.255;
    option domain-name-servers 10.76.1.3;
}


subnet 10.76.2.0 netmask 255.255.255.0 {
    option routers 10.76.2.1;
    option broadcast-address 10.76.2.255;
    option domain-name-servers 10.76.1.3;
}

' > /etc/dhcp/dhcpd.conf

rm /var/run/dhcpd.pid
# restart dhcp relay
service isc-dhcp-server stop
service isc-dhcp-server start
```

## Konfigurasikan Heiter
Untuk meregister domain pada heiter sebagai DNS server dengan script setup.sh
```bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt update && apt install ne -y


echo "echo nameserver 192.168.122.1 > /etc/resolv.conf
apt update && apt install ne -y
" > ~/.bashrc


apt-get install bind9 bind9utils bind9-doc -y


# setup untuk nameserver agar tidak pakai 192.168.122.1 
cat > /etc/bind/named.conf.options << EOF
options {
    listen-on { 10.76.1.3; };  # IP Heiter
    listen-on-v6 { none; };
    directory "/var/cache/bind";

    # Forwarders
    forwarders {
        192.168.122.1;  
    };

    # If there is no answer from the forwarders, don't attempt to resolve recursively
    forward only;

    dnssec-validation no;

    auth-nxdomain no;    # conform to RFC1035
    allow-query { any; };
};
EOF

rm /etc/bind/named.conf.local

# Menambahkan konfigurasi zona
cat >> /etc/bind/named.conf.local << EOF
zone "canyon.it25.com" {
    type master;
    file "/etc/bind/db.canyon.it25.com";
};
EOF

# Memeriksa konfigurasi zona untuk channel.it25.com
cat >> /etc/bind/named.conf.local << EOF
zone "channel.it25.com" {
    type master;
    file "/etc/bind/db.channel.it25.com";
};
EOF

# Membuat file zona untuk riegel.canyon.it25.com
rm /etc/bind/db.canyon.it25.com
cat > /etc/bind/db.canyon.it25.com << EOF
\$TTL 604800
@ IN SOA canyon.it25.com. admin.canyon.it25.com. (
              2         ; Serial
         604800         ; Refresh
          86400         ; Retry
        2419200         ; Expire
         604800 )       ; Negative Cache TTL
;
@    IN NS           ns.canyon.it25.com.
ns   IN A            10.76.4.1
riegel IN A          10.76.4.1
EOF
 
# Memeriksa file zona untuk channel.it25.com
rm /etc/bind/db.channel.it25.com
cat > /etc/bind/db.channel.it25.com << EOF
\$TTL 604800
@ IN SOA channel.it25.com. admin.channel.it25.com. (
              2         ; Serial
         604800         ; Refresh
          86400         ; Retry
        2419200         ; Expire
         604800 )       ; Negative Cache TTL
;
@    IN NS           ns.channel.it25.com.
ns   IN A            10.76.3.1
granz IN A          10.76.3.1
EOF




service bind9 restart
```

### Testing
Untuk testing kita masuk pada salah satu client dan lakukan command
```bash
apt update && apt-get install dnsutils -y
dig riegel.canyon.it25.com
```
dan akan menghasilkan output
```
;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: cb50f1af612f2cfd202c4fe56554c73af3480b5c905969ee (good)
;; QUESTION SECTION:
;riegel.canyon.it25.com.                IN      A

;; ANSWER SECTION:
riegel.canyon.it25.com. 604800  IN      A       10.76.4.1

;; AUTHORITY SECTION:
canyon.it25.com.        604800  IN      NS      ns.canyon.it25.com.

;; ADDITIONAL SECTION:
ns.canyon.it25.com.     604800  IN      A       10.76.4.1

;; Query time: 1 msec
;; SERVER: 10.76.1.3#53(10.76.1.3)
;; WHEN: Wed Nov 15 13:27:22 UTC 2023
;; MSG SIZE  rcvd: 128
```
untuk granz lakukan command
```bash
dig granz.channel.it25.com
```
dan outputnya akan
```
;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 284f3e6aaffe92bc257965446554c7781ed8b290c7eed4ec (good)
;; QUESTION SECTION:
;riegel.canyon.it25.com.                IN      A

;; ANSWER SECTION:
riegel.canyon.it25.com. 604800  IN      A       10.76.4.1

;; AUTHORITY SECTION:
canyon.it25.com.        604800  IN      NS      ns.canyon.it25.com.

;; ADDITIONAL SECTION:
ns.canyon.it25.com.     604800  IN      A       10.76.4.1

;; Query time: 1 msec
;; SERVER: 10.76.1.3#53(10.76.1.3)
;; WHEN: Wed Nov 15 13:28:24 UTC 2023
;; MSG SIZE  rcvd: 128
```

## No 1,2,3
Diminta agar Semua CLIENT harus menggunakan konfigurasi dari DHCP Server.(1)
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.16 - [prefix IP].3.32 dan [prefix IP].3.64 - [prefix IP].3.80 (2)
Client yang melalui Switch4 mendapatkan range IP dari [prefix IP].4.12 - [prefix IP].4.20 dan [prefix IP].4.160 - [prefix IP].4.168 (3)

```bash
echo '# Konfigurasi untuk client yang terhubung melalui Switch3
subnet 10.76.3.0 netmask 255.255.255.0 {
    range 10.76.3.16 10.76.3.32; # 16-32
    range 10.76.3.64 10.76.3.80; # 64-80
    option routers 10.76.3.254;
    option broadcast-address 10.76.3.255;
    option domain-name-servers 10.76.1.3; # Ip Heiter
    default-lease-time 180; # 3 menit dalam detik
    max-lease-time 5760; # 96 menit dalam detik
}


# Konfigurasi untuk client yang terhubung melalui Switch4
subnet 10.76.4.0 netmask 255.255.255.0 {
    range 10.76.4.12 10.76.4.20; # 12-20
    range 10.76.4.160 10.76.4.168; # 160-168
    option routers 10.76.4.254;
    option broadcast-address 10.76.4.255;
    option domain-name-servers 10.76.1.3; # Ip Heiter
    default-lease-time 720; # 12 menit dalam detik
    max-lease-time 5760; # 96 menit dalam detik
}


subnet 10.76.1.0 netmask 255.255.255.0 {
    option routers 10.76.1.1;
    option broadcast-address 10.76.1.255;
    option domain-name-servers 10.76.1.3;
}


subnet 10.76.2.0 netmask 255.255.255.0 {
    option routers 10.76.2.1;
    option broadcast-address 10.76.2.255;
    option domain-name-servers 10.76.1.3;
```
Dengan Script diatas yang sudah ada pada setup.sh pada Himmel

### Testing
untuk melakukan testing, Bukalah node client(Sein, Start, Revolte,richter) salah satu harusnya saat pertama kali membuka sudah mendapatkankan ip contohnya:

udhcpc: started, v1.30.1
udhcpc: sending discover
udhcpc: sending select for 10.76.4.14
udhcpc: lease of 10.76.4.14 obtained, lease time 720
artinya dia sudah dapat ip secara otomatis (dhcp nya bekerja) 

## No 4
Client mendapatkan DNS dari Heiter dan dapat terhubung dengan internet melalui DNS tersebut (4)

jika pada modul sebelumnya kita me assign nameserver 192.168.122.1  pada setiap node agar bisa internet, untuk soal nomer 4 kita disuruh assign ip dari Heiter yaitu 192.168.1.3 pada setiap dhcp client disini tinggal dimasukan pada conf sebelumnya
```
option domain-name-servers 10.76.1.3;
```
 jadi akan teregister otomatis namservernya

tapi jangan lupa pada heiter di set untuk di forward ke nameserver yang biasanya
```bash
options {
    listen-on { 10.76.1.3; };  # IP Heiter
    listen-on-v6 { none; };
    directory "/var/cache/bind";


    # Forwarders
    forwarders {
        192.168.122.1;  
    };


    # If there is no answer from the forwarders, don't attempt to resolve recursively
    forward only;


    dnssec-validation no;


    auth-nxdomain no;    # conform to RFC1035
    allow-query { any; };
};
```
### Testing
ketikan command
```
cat /etc/resolv.conf
```

dan outputnya akan
```
root@Stark:/# cat /etc/resolv.conf
nameserver 10.76.1.3
```
maka nameserver sudah terdaftar

## No 5
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch3 selama 3 menit sedangkan pada client yang melalui Switch4 selama 12 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 96 menit (5)
Memasukan script pada setup.sh pada DHCP server
```
default-lease-time 180; # 3 menit dalam detik
max-lease-time 5760; # 96 menit dalam detik

default-lease-time 720; # 12 menit dalam detik
max-lease-time 5760; # 96 menit dalam detik
```
jika membuka client maka akan terdapat output:
```
udhcpc: started, v1.30.1
udhcpc: sending discover
udhcpc: sending select for 10.76.4.14
udhcpc: lease of 10.76.4.14 obtained, lease time 720
```

## No 6
Pada masing-masing worker PHP, lakukan konfigurasi virtual host untuk website berikut dengan menggunakan php 7.3. (6)
Lakukan Setup pada masing masing php worker dengan setup.sh dibawah:

```bash
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
```
### Testing
ketikan command
```
curl localhost
```
dan akan menghasilkan output berupa file html dari file yg sudah di download
```
<!DOCTYPE html>
<html>
<head>
    <title>Riegel Canyon Map</title>
    <link rel="stylesheet" type="text/css" href="css/styles.css">
</head>
<body>
    <div class="container">
        <h1>Welcome to Riegel Canyon</h1>
        <p>Request ini dihandle oleh: Linie-workerPHP<br> </p>
        <p>Enter your name to validate:</p>
        <form method="POST" action="index.php">
            <input type="text" name="name" id="nameInput">
            <button type="submit" id="submitButton">Submit</button>
        </form>
        <p id="greeting"></p>
    </div>

    <script src="js/script.js"></script>
</body>
</html>root@Linie-workerPHP:~#
```


## No 7
Kepala suku dari Bredt Region memberikan resource server sebagai berikut:
Lawine, 4GB, 2vCPU, dan 80 GB SSD.
Linie, 2GB, 2vCPU, dan 50 GB SSD.
Lugner 1GB, 1vCPU, dan 25 GB SSD.
aturlah agar Eisen dapat bekerja dengan maksimal, lalu lakukan testing dengan 1000 request dan 100 request/second. (7)

Secara tidak langsung soal ini menyuruh kita konfigurasi Elsen yang bertindak sebagai Load balancer
run script setup6-7.sh isinya konfigurasi 3 load balancer dengan 3 algoritma berbeda
- Round Robin
- Least Connection
- IP Hash

```bash
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
```
### Testing
```
curl localhost:81                                    (untuk Algoritma Round Robin)
curl localhost:82			   (Least Connection)
curl localhost:83 			   (IP Hash)
```
yang akan menghasilkan output
```
</html>root@Elsen:~# curl localhost:81
<!DOCTYPE html>
<html>
<head>
    <title>Riegel Canyon Map</title>
    <link rel="stylesheet" type="text/css" href="css/styles.css">
</head>
<body>
    <div class="container">
        <h1>Welcome to Riegel Canyon</h1>
        <p>Request ini dihandle oleh: Linie-workerPHP<br> </p>
        <p>Enter your name to validate:</p>
        <form method="POST" action="index.php">
            <input type="text" name="name" id="nameInput">
            <button type="submit" id="submitButton">Submit</button>
        </form>
        <p id="greeting"></p>
    </div>

    <script src="js/script.js"></script>
</body>
````

masuk ke worker Elsen
pertama isntall dulu
```
apt-get update 
apt-get install apache2-utils -y
```

lalu ketik untuk  testing dengan 1000 request dan 100 request/second
```
ab -n 1000 -c 100 -k http://10.76.2.2:81/
```
![image](https://github.com/chocoricano/Jarkom-Modul-3-IT25-2023/assets/56831859/4934d810-533e-44c4-8b19-6f9a80a2e522)

## No 8
Analisa pada load balancer dengan 200 request dan 10 request/second

### testing
pada worker:
```
apt install htop -y
htop
```
```
pada client:
apt install apache2-utils -y

ab -n 200 -c 10 -k http://10.76.2.2:81/                     (ingat port 81 untuk algoritma round robin)
ab -n 200 -c 10 -k http://10.76.2.2:82/                         (82 untuk algoritma Least Connection)
ab -n 200 -c 10 -k http://10.76.2.2:83/                         (82 untuk algoritma IP hash)
```

Hasil analisis ada pada [https://github.com/chocoricano/Jarkom-Modul-3-IT25-2023/blob/main/IT25grimoire.md](grimoire)
