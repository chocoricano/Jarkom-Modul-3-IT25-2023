#!/bin/bash

# Path to the PHP-FPM pool configuration file
config_file="/etc/php/8.0/fpm/pool.d/www.conf"  # Ganti dengan versi PHP yang sesuai

# Ini disesuakan saja bebas angkanya tiap worker beda
new_max_children=50
new_start_servers=10
new_min_spare_servers=5
new_max_spare_servers=20

# Backup the original configuration file
cp "$config_file" "$config_file.bak"

# Update the PHP-FPM configuration values
sed -i "s/^pm\.max_children = .*/pm\.max_children = $new_max_children/" "$config_file"
sed -i "s/^pm\.start_servers = .*/pm\.start_servers = $new_start_servers/" "$config_file"
sed -i "s/^pm\.min_spare_servers = .*/pm\.min_spare_servers = $new_min_spare_servers/" "$config_file"
sed -i "s/^pm\.max_spare_servers = .*/pm\.max_spare_servers = $new_max_spare_servers/" "$config_file"

# Restart PHP-FPM to apply changes
sudo systemctl restart php8.0-fpm  # Ganti dengan versi PHP yang sesuai
