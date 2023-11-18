apt-get update
apt install nginx wget zip htop -y
apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2

# Add Sury.org repository key
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

# Add Sury.org repository to sources.list
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

apt-get update

apt-get install php8.0-mbstring php8.0-xml php8.0-cli php8.0-common php8.0-intl php8.0-opcache php8.0-readline php8.0-mysql php8.0-fpm php8.0-curl mariadb-client -y

curl -L --insecure https://getcomposer.org/download/2.0.13/composer.phar -o composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer

wget -O '/var/www/jarkom.zip' 'https://github.com/martuafernando/laravel-praktikum-jarkom/archive/refs/heads/main.zip'
unzip -o /var/www/jarkom.zip -d /var/www/
rm /var/www/jarkom.zip

echo '
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=10.76.2.3
DB_PORT=3306
DB_DATABASE=dbkelompokit25
DB_USERNAME=kelompokit25
DB_PASSWORD=passwordit25

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
VITE_PUSHER_HOST="${PUSHER_HOST}"
VITE_PUSHER_PORT="${PUSHER_PORT}"
VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
' > /var/www/laravel-praktikum-jarkom-main/.env

cd /var/www/laravel-praktikum-jarkom-main

composer update
composert insall
php artisan migrate:fresh
php artisan db:seed --class=AiringsTableSeeder
php artisan key:generate
php artisan jwt:secret

cd ~

echo '
 server {

 	listen 8000;

 	root /var/www/laravel-praktikum-jarkom-main/public;

 	index index.php index.html index.htm;
 	server_name _;

 	location / {
 			try_files $uri $uri/ /index.php?$query_string;
 	}

 	# pass PHP scripts to FastCGI server
 	location ~ \.php$ {
 	include snippets/fastcgi-php.conf;
 	fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
 	}

    location ~ /\.ht {
 			deny all;
 	}

 	error_log /var/log/nginx/jarkom_error.log;
 	access_log /var/log/nginx/jarkom_access.log;
 }
' > /etc/nginx/sites-available/laravel-praktikum-jarkom-main

ln -s --force /etc/nginx/sites-available/laravel-praktikum-jarkom-main /etc/nginx/sites-enabled/laravel-praktikum-jarkom-main

chown -R www-data.www-data /var/www/laravel-praktikum-jarkom-main/storage

rm /etc/nginx/sites-enabled/default

service nginx restart
service php8.0-fpm stop
service php8.0-fpm start