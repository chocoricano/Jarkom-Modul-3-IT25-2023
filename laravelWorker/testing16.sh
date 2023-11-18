#!/bin/bash
apt-get update
apt-get install apache2-utils -y
echo '
{
  "username": "kelompokit25",
  "password": "passwordit25"
}' > login.json

ab -n 100 -c 10 -p login.json -T application/json http://10.76.4.2:8000/api/auth/login