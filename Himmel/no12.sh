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
echo '# Konfigurasi untuk client yang terhubung melalui Switch3\
host Revolter {
    hardware ethernet 92:3a:3c:c7:ed:98;
    fixed-address 10.76.3.69;
    option host-name "Revolter";
}

host Sein {
    hardware ethernet ae:70:84:b0:03:11;
    fixed-address 10.76.4.167;
    option host-name "Sein";
}

subnet 10.76.3.0 netmask 255.255.255.0 {
    range 10.76.3.16 10.76.3.32;
    range 10.76.3.64 10.76.3.80;
    option routers 10.76.3.254;
    option broadcast-address 10.76.3.255;
    option domain-name-servers 10.76.1.3; # Ganti x.x dengan alamat IP aktual Heiter
    default-lease-time 180; # 3 menit dalam detik
    max-lease-time 5760; # 96 menit dalam detik
}

# Konfigurasi untuk client yang terhubung melalui Switch4
subnet 10.76.4.0 netmask 255.255.255.0 {
    range 10.76.4.12 10.76.4.20;
    range 10.76.4.160 10.76.4.168;
    option routers 10.76.4.254;
    option broadcast-address 10.76.4.255;
    option domain-name-servers 10.76.1.3; # Ganti x.x dengan alamat IP aktual Heiter
    default-lease-time 720; # 12 menit dalam detik
    max-lease-time 5760; # 96 menit dalam detik
}

subnet 10.76.1.0 netmask 255.255.255.0 {
    option routers 10.76.1.1;
    option broadcast-address 10.76.1.255;
    option domain-name-servers 10.76.1.3; # Ganti dengan alamat DNS yang diinginkan
}


subnet 10.76.2.0 netmask 255.255.255.0 {
    option routers 10.76.2.1;
    option broadcast-address 10.76.2.255;
    option domain-name-servers 10.76.1.3; # Ganti dengan alamat DNS yang diinginkan
}
' > /etc/dhcp/dhcpd.conf

rm /var/run/dhcpd.pid
# restart dhcp relay
service isc-dhcp-server stop
service isc-dhcp-server start