#!/bin/bash

curl -X POST -H "Content-Type: application/json" -d @login.json http://10.76.2.2:84/api/auth/login > login_output.txt
token=$(cat login_output.txt | jq -r '.token')
ab -n 10000 -c 100 -H "Authorization: Bearer $token" http://10.76.2.2:84/api/me