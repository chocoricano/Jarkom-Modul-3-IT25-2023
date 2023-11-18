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
