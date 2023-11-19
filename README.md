# Jarkom-Modul-3-IT25-2023

## Modul 3 Jarkom IT25

### Anggota :

- ANDYANA MUHANDHATUL NABILA - 5027211029
- ANDREAS TIMOTIUS PARHORASAN SIHOMBING - 5027211019
## Topologi 


## No 0
diminta untuk melakukan register domain berupa riegel.canyon.yyy.com untuk worker Laravel dan granz.channel.yyy.com untuk worker PHP yang mengarah pada worker yang memiliki IP [prefix IP].x.1.

## Configurasi aura DHCP relay
```
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
