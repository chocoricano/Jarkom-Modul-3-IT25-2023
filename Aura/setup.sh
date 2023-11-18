echo nameserver 192.168.122.1 > /etc/resolv.conf
apt update && apt install ne -y

# masukan ke ~/.bashrc
echo "echo nameserver 192.168.122.1 > /etc/resolv.conf
apt update && apt install ne -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.76.0.0/16
" > ~/.bashrc

# instal dhcp relay dan lakukan enter 3 kali 
apt-get install isc-dhcp-relay -y


# Jadi pada dhcp relay itu menggunakan library isc-dhcp-relay
# untuk mengkonfigurasi dhcp relay kita harus mengedit file /etc/default/isc-dhcp-relay
# dibawah sudah saya sediakan konfigurasi untuk dhcp relay
# untuk IP dhcp servernya adalah 10.76.1.2 sesuai dengan IP Himmel
# dan INTERFACES adalah eth1 eth2 eth3 eth4

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