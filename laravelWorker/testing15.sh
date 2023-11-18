#!/bin/bash
apt-get update
apt-get install apache2-utils -y

echo '
{
  "username": "kelompokit25_2",
  "password": "passwordit25"
}' > register.json

ab -n 100 -c 10 -p register.json -T application/json http://10.76.4.1:8000/api/auth/register